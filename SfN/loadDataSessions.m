function [data] = loadDataSessions(varargin)

    close all

    if length(varargin) > 0
        ratInitials = varargin{1};
        %fprintf(strcat('Analysing data for rat: ',string()))
    else
        error('Rat initials argument missing.')
        return
    end
    
    filenames = dir(strcat(ratInitials,'*')); 
    
    
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
    
    validTrial = cell(0,1);
    conditionTrial = cell(0,1);
    
    moveOnset = cell(0,1);
    timeMax = cell(0,1);
    maxPos = cell(0,1);
    vmax = cell(0,1);
    
    %% loop through files (j) and trials (i)
    for j = 1:numel(filenames)
        
        td = load(strcat(filenames(j).name));

        session = td.td;
        ratName = string(td.td.trials(j).subject);
        
        if ratName == 'Zeldah'
            currentParams = [-7.3126e-05, 0.1606];
            torqueParams = [2.9157e-07, 2.3302e-04, 2.5335e-04];
        elseif ratName == 'Bonapp'
            currentParams = [-7.1327e-05, 0.1474];
            torqueParams = [2.8747e-07, 2.0122e-04, 2.1316e-04];
        else
            error('Invalid rat.')
        end
        
        allTrials = session.trials;
        
        for k = 1:numel(allTrials)

            touchStatusk = allTrials(k).touchStatus;
            statek = allTrials(k).state;
            state3Start = find(statek == 3, 1);
            state3End = find(statek == 3, 1, 'last');
            touchStatusModifiedk = touchStatusk(state3Start:state3End);

            % align to first touch
            firstTouch = find(touchStatusModifiedk, 1) + state3Start - 1;
            lastTouchRelease = find(diff(touchStatusModifiedk)-1,1,'last') + state3Start -1;

            positionk = allTrials(k).pos(firstTouch:lastTouchRelease);
            trialTimek = allTrials(k).trialData_time(firstTouch:lastTouchRelease);
            % replace without real parameters
            
            if length(trialTimek) > 6
            
                i = numel(position) + 1;
                
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
                [b,a] = butter(2,Wn);
                
                pos = pi/180*positionk;
                pos = filtfilt(b,a,pos);
                vel = diff(pos)/0.002;
                accel = diff(vel)/0.002;
                
                i_mot = currentParams(1)*double(allTrials(k).currentBitsShunt) + currentParams(2);
                i_mot_i = i_mot - i_mot(1);
                %i_mot_i = -i_mot_i;
                
                
                i_mot_i = filtfilt(b,a,i_mot_i);

                i_mot_i = i_mot_i(firstTouch+1:lastTouchRelease-1);
                

                motorCurrentCom{i} = (1-2*double(allTrials(k).dirMotor(firstTouch+1:lastTouchRelease-1))).*allTrials(k).motorCurrent(firstTouch+1:lastTouchRelease-1)/1000;
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
                torque{i} = torqueParams(1) * accel - 0.036 * i_mot_i - (-fric_i_pos*torqueParams(2)) - (fric_i_neg*torqueParams(3));

                if allTrials(k).dirTask == 1
                    [maxPos{i}, timeMax{i}] = max(-position{i});
                    moveOnset{i} = find(-180/pi*pos>5, 1);
                    %moveOnset{i} = find(velocity{i}<-2, 1);
                    %[vmax{i}, moveOnset{i}] = max(-velocity{i});
                    %moveOnset{i} = find(velocity{i}<-0.15*vmax, 1);
                else
                    [maxPos{i}, timeMax{i}] = max(position{i});
                    moveOnset{i} = find(180/pi*pos>5, 1);
                    %moveOnset{i} = find(velocity{i}>2, 1);
                    %[vmax{i}, moveOnset{i}] = max(velocity{i});
                    %moveOnset{i} = find(velocity{i}>0.15*vmax, 1);
                end

                if(abs(maxPos{i}) >= 20)
                    validTrial{i} = 1;
                else
                    validTrial{i} = 0;
                end

                conditionTrial{i} = allTrials(k).stiffCurrentMax * (1-allTrials(k).catchTrialFlag);
            
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

    data.validTrial = validTrial;
    data.conditionTrial = conditionTrial;

    data.moveOnset = moveOnset;
    data.timeMax = timeMax;
    data.maxPos = maxPos;
    data.vmax = vmax;
    
end