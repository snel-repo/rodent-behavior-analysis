function [data] = loadDataSessions(varargin)

    close all

    if length(varargin) > 0
        ratInitials = varargin{1};
        %fprintf(strcat('Analysing data for rat: ',string()))
    else
        error('Rat initials argument missing.')
        return
    end
    
    filenames = dir(strcat('data/',ratInitials,'*')); 
    
    
    %% pre-allocate variables
    touchStatus = cell(0,1);
    touchStatusModified = cell(0,1);
    position = cell(0,1);
    velocity = cell(0,1);
    acceleration = cell(0,1);
    torque = cell(0,1);
    motorCurrent = cell(0,1);
    motorCurrentCom = cell(0,1);
    state = cell(0,1);
    trialTime = cell(0,1);
    
    forceX = cell(0,1);
    forceY = cell(0,1);
    forceZ = cell(0,1);
    forceMag = cell(0,1);
    
    validTrial = cell(0,1);
    conditionTrial = cell(0,1);
    
    cueOnset = cell(0,1);
    touchOnset = cell(0,1);
    moveOnset = cell(0,1);   
    timeMax = cell(0,1);
    
    moveDuration = cell(0,1);
    taskDuration = cell(0,1);
    maxPos = cell(0,1);
    vmax = cell(0,1);
    
    %% loop through files (j) and trials (i)
    for j = 1:numel(filenames)

        td = load(strcat('data/',filenames(j).name));

        session = td.td;
        ratName = string(td.td.trials(j).subject);
        
        if ratName == 'Zeldah' || ratName == 'Cleopa'
            currentParams = [-7.3126e-05, 0.1606];
            torqueParams = [2.8721e-07,  2.3345e-04, 2.5233e-04];
        elseif ratName == 'Bonapp' || ratName == 'Androi'
            currentParams = [-7.1327e-05, 0.1474];
            torqueParams = [2.9450e-07, 2.1138e-04, 2.1712e-04];
        else
            error('Invalid rat.')
        end
        
        allTrials = session.trials;
        
        for k = 1:numel(allTrials)

            touchStatusk = allTrials(k).touchStatus;
            statek = allTrials(k).state;
            state3Start = find(statek == 3, 1);
            start = state3Start-200;
            state3End = find(statek == 3, 1, 'last');
            touchStatusModifiedk = touchStatusk(state3Start:state3End);

            % align to first touch
            firstTouch = find(touchStatusModifiedk, 1); % + state3Start - 1;
            lastTouchRelease = find(diff(touchStatusModifiedk)-1,1,'last') + state3Start - 1;

            positionk = allTrials(k).pos(start:lastTouchRelease);% - allTrials(k).pos(start);
            trialTimek = allTrials(k).trialData_time(start:lastTouchRelease);
            
            if length(trialTimek) > 9 
            
                i = numel(position) + 1;
                
                cueOnset{i} = state3Start-start;
                touchOnset{i} = firstTouch + state3Start - start - 2;
                
                touchStatus{i} = touchStatusk(2:end-1);
                state{i} = statek(2:end-1);
                %touchStatusModified{i} = touchStatusModifiedk(firstTouch+1:lastTouchRelease-1);
                
                %position{i} = positionk;
                trialTime{i} = trialTimek(2:end-1) - trialTimek(1);
                
                %length(positionk)
                %length(trialTimek)
                
                fc = 100;
                fs = 500;
                Wn = fc/(fs/2);
                [b,a] = butter(3,Wn);
                
                if allTrials(k).dirTask == 1
                    sgn = -1;
                else
                    sgn = 1;
                end
                
                pos = sgn*pi/180*positionk;
                %pos = filtfilt(b,a,pos);
                vel = diff(pos)/0.002;
                vel = filtfilt(b,a,vel);
                accel = diff(vel)/0.002;
                accel = filtfilt(b,a,accel);
                
                i_mot = sgn*currentParams(1)*double(allTrials(k).currentBitsShunt) + currentParams(2);
                i_mot_i = i_mot - i_mot(1);
                %i_mot_i = -i_mot_i;
                
                i_mot_i = filtfilt(b,a,i_mot_i);

                i_mot_i = i_mot_i(start+1:lastTouchRelease-1);
                

                motorCurrentCom{i} = sgn*(1-2*double(allTrials(k).dirMotor(start+1:lastTouchRelease-1))).*allTrials(k).motorCurrent(start+1:lastTouchRelease-1)/1000;
                motorCurrent{i} = i_mot_i;
                pos = pos(2:end-1);
                position{i} = pos;
                vel = vel(2:end);
                velocity{i} = vel;
                acceleration{i} = accel;

                fric_i_pos = vel > 15*pi/180;
                fric_i_neg = vel < -15*pi/180;

                %torque{i} = 2.7966e-07 * -accel{i} - 0.036 * motorCurrent{i} - fric_i;
                %torque{i} = - 0.036 * (-motorCurrent{i}) - 100*(-sign(velocity{i})*fric_i);
                torq = torqueParams(1) * accel - 0.036 * i_mot_i - (-fric_i_pos*torqueParams(3)) - (fric_i_neg*torqueParams(2));
                torq = filtfilt(b,a,torq);
                torque{i} = torq;

                forceX{i} = filtfilt(b,a,allTrials(k).forceRawX(start+1:lastTouchRelease-1));
                forceY{i} = filtfilt(b,a,allTrials(k).forceRawY(start+1:lastTouchRelease-1));
                forceZ{i} = filtfilt(b,a,allTrials(k).forceRawZ(start+1:lastTouchRelease-1));
                
                forceMag{i} = sqrt(forceX{i}.*forceX{i} + forceY{i}.*forceY{i} + forceZ{i}.*forceZ{i});
                
%                 if allTrials(k).dirTask == 1
%                     [maxPos{i}, timeMax{i}] = max(-position{i});
%                     moveOnset{i} = find(-180/pi*pos>5, 1);
%                     %moveOnset{i} = find(velocity{i}<-2, 1);
%                     %[vmax{i}, moveOnset{i}] = max(-velocity{i});
%                     %moveOnset{i} = find(velocity{i}<-0.15*vmax, 1);
%                 else
                [maxPos{i}, timeMax{i}] = max(position{i});
                moveOnset{i} = find(180/pi*pos>5, 1);
                    %moveOnset{i} = find(velocity{i}>2, 1);
                    %[vmax{i}, moveOnset{i}] = max(velocity{i});
                    %moveOnset{i} = find(velocity{i}>0.15*vmax, 1);
                %end

                if(abs(180/pi*maxPos{i}) >= 30)
                    validTrial{i} = 1;
                else
                    validTrial{i} = 0;
                end

                conditionTrial{i} = allTrials(k).stiffCurrentMax * (1-allTrials(k).catchTrialFlag);
                
                moveDuration{i} = timeMax{i} - moveOnset{i};
                if isempty(moveDuration{i})
                     moveDuration{i} = 0;
                end
                taskDuration{i} = timeMax{i} - touchOnset{i};
                if isempty(taskDuration{i})
                     taskDuration{i} = 0;
                end
                
            end
                
        end
    end
    
    data.touchStatus = touchStatus;
    %data.touchStatusModified = touchStatusModified;
    data.position = position;
    data.velocity = velocity;
    data.acceleration = acceleration;
    data.torque = torque;
    data.motorCurrent = motorCurrent;
    data.motorCurrentCom = motorCurrentCom;
    data.state = state;
    data.trialTime = trialTime;

    data.forceX = forceX;
    data.forceY = forceY;
    data.forceZ = forceZ;
    data.forceMag = forceMag;
    
    data.validTrial = validTrial;
    data.conditionTrial = conditionTrial;

    data.cueOnset = cueOnset;
    data.touchOnset = touchOnset;
    data.moveOnset = moveOnset;
    data.timeMax = timeMax;
    
    data.moveDuration = moveDuration;
    data.taskDuration = taskDuration;
    data.maxPos = maxPos;
    data.vmax = vmax;
    
end