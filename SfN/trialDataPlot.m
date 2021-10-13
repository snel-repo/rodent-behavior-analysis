function trialDataPlot(varargin)

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
    position_filt = cell(0,1);
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
    moveMax = cell(0,1);
    maxPos = cell(0,1);
    vmax = cell(0,1);
    
    %% loop through files (j) and trials (i)
    for j = 1:numel(filenames)
        
        td = load(strcat(filenames(j).name));

        session = td.td;
        ratName = string(td.td.trials(j).subject);
        sessionDateTimeAndSaveTag = string(td.td.trials(j).date);
        
        if ratName == 'Zeldah'
            currentParams = [-7.3126e-05, 0.1606];
        elseif ratName == 'Bonapp'
            currentParams = [-7.1327e-05, 0.1474];
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
            trialTimek = allTrials(k).trialData_time(firstTouch:lastTouchRelease) - allTrials(k).trialData_time(firstTouch);
            % replace without real parameters
            
            if length(trialTime) >= 0
            
                i = numel(position) + 1;
                
                touchStatus{i} = touchStatusk;
                state{i} = statek;
                touchStatusModified{i} = touchStatusModifiedk;
                
                position{i} = positionk;
                trialTime{i} = trialTimek;
                
                motorCurrent{i} = currentParams(1)*double(allTrials(k).currentBitsShunt(firstTouch:lastTouchRelease)) + currentParams(2);
                %motorCurrent{i} = motorCurrent{i} - motorCurrent{i}(1);
                motorCurrentCom{i} = 1e-3*allTrials(k).motorCurrent(firstTouch:lastTouchRelease);
                velocity{i} = pi/180*allTrials(k).velRaw(firstTouch:lastTouchRelease);
                %accel{i} = allTrials(i).accel(firstTouch:lastTouchRelease);
                acceleration{i} = diff([velocity{i}; 0])/0.002;



                pos = pi/180*position{i};
                vel = [0; (diff(pos)/0.002)];
                accel = diff(diff([0; 0; pos])/0.002)/0.002;
                i_mot = motorCurrent{i}; 

                fc = 50;
                fs = 500;
                Wn = fc/(fs/2);
                [b,a] = butter(2,Wn);
                accel_filt1 = filter(b,a,accel);
                if length(pos) > 6
                    pos_filt1 = filtfilt(b,a,pos);
                else
                    pos_filt1 = filter(b,a,pos);
                end


                windowSize = 10; 
                b = (1/windowSize)*ones(1,windowSize);
                a = 1;

                accel1_filt2 = filter(b,a,accel);

                vel2 = diff([0; pos_filt1])/0.002;
                accel2 = diff(diff([0; 0; pos_filt1])/0.002)/0.002;

                fric_i_pos = vel2 > 15*pi/180;
                fric_i_neg = vel2 < -15*pi/180;

                %torque{i} = 2.7966e-07 * -accel{i} - 0.036 * motorCurrent{i} - fric_i;
                %torque{i} = - 0.036 * (-motorCurrent{i}) - 100*(-sign(velocity{i})*fric_i);
                torque{i} = 2.7966e-07 * accel2 - 0.036 * (-motorCurrent{i}) - (-fric_i_pos*2.0664e-04) - (fric_i_neg*2.2047e-04);

                position_filt{i} = pos_filt1;

                %moveOnset{i} = find(abs(velocity{i})>2, 1);
                %moveOnset{i} = find(abs(vel2)>2, 1);

                if allTrials(k).dirTask == 1
                    [maxPos{i}, moveMax{i}] = max(-position{i});
                    moveOnset{i} = find(-position{i}>5, 1);
                    %moveOnset{i} = find(velocity{i}<-2, 1);
                    %[vmax{i}, moveOnset{i}] = max(-velocity{i});
                    %moveOnset{i} = find(velocity{i}<-0.15*vmax, 1);
                else
                    [maxPos{i}, moveMax{i}] = max(position{i});
                    moveOnset{i} = find(position{i}>5, 1);
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
    
    
%     catchTrialIdxs = [allTrials.catchTrialFlag];
%     allCatchIdx = find(catchTrialIdxs);
%     
%     nonCatchTrialIdxs = ~catchTrialIdxs;
%     
%     hitTrialIdxs = [allTrials.hitTrial];
%     
%     hitCatchTrialsIdxs = uint8(catchTrialIdxs) .* uint8(hitTrialIdxs);
%     hitNonCatchTrialsIdxs = uint8(nonCatchTrialIdxs) .* uint8(hitTrialIdxs);
%     
%     HR_c = sum(hitCatchTrialsIdxs) / sum(catchTrialIdxs);
%     HR_nc = sum(hitNonCatchTrialsIdxs) / sum(nonCatchTrialIdxs);
% 
%     failFlags = cell(length(allTrials),1);
%     
%     for i = 1:numel(allTrials)    
%         failFlags{i} = allTrials(i).flagFail; 
%     end

    %% histogram of max angles
    
%     edges = 0:5:100;
%     maxPosArray = cell2mat(maxPos);
%     
%     figure()
%     set(gcf, 'OuterPosition', [10, 10, 1290, 1290]);
%     
%     ax1 = subplot(2,1,1); hold('on');
%     xlabel('Max. angle (deg.)');
%     ylabel('# trials');
%     title(strcat("(Catch trials) Histogram of max. angles for ", ratName, " for Session ", sessionDateTimeAndSaveTag));
%     
%     size(maxPosArray)
%     size(catchTrialIdxs)
%     
%     histogram(maxPosArray(find(catchTrialIdxs==1)),edges);
% 
%     ax2 = subplot(2,1,2); hold('on');
%     
%     xlabel('Max. angle (deg.)');
%     ylabel('# trials');
%     title(strcat("(Non-catch trials) Histogram of max. angles for ", ratName, " for Session ", sessionDateTimeAndSaveTag));
%     
%     histogram(maxPosArray(find(nonCatchTrialIdxs==1)),edges);
%     
%     linkaxes([ax1,ax2],'xy')
    
    %% histogram of max velocities
    
%     edges = 0:2.5:40;
%     maxVelArray = cell2mat(vmax);
%     
%     figure()
%     set(gcf, 'OuterPosition', [10, 10, 1290, 1290]);
%     
%     ax1 = subplot(2,1,1); hold('on');
%     xlabel('Max. angle (deg.)');
%     ylabel('# trials');
%     title(strcat("(Catch trials) Histogram of max. velocities for ", ratName, " for Session ", sessionDateTimeAndSaveTag));
%     
%     histogram(maxVelArray(find(catchTrialIdxs==1)),edges);
% 
%     ax2 = subplot(2,1,2); hold('on');
%     
%     xlabel('Max. velocity (rad/s)');
%     ylabel('# trials');
%     title(strcat("(Non-catch trials) Histogram of max. velocities for ", ratName, " for Session ", sessionDateTimeAndSaveTag));
%     
%     histogram(maxVelArray(find(nonCatchTrialIdxs==1)),edges);
%     
%     linkaxes([ax1,ax2],'xy')
    
    %% plot data velocity

    plotInfo = {};
    plotInfo.ratName = ratName;
    plotInfo.sessionDateTimeAndSaveTag = sessionDateTimeAndSaveTag;
    plotInfo.ylabel = 'Angular velocity (rad/s)';
    plotInfo.varName = 'Velocity';
    %plotInfo.HRstr1 = strcat(string(sum(hitCatchTrialsIdxs)),"/",string(sum(catchTrialIdxs)));
    %plotInfo.HRstr2 = strcat(string(sum(hitNonCatchTrialsIdxs)),"/",string(sum(nonCatchTrialIdxs)));
    
    plotAlignedAll(trialTime, moveOnset, velocity, moveMax, conditionTrial, validTrial, plotInfo);

    %% plot data position

    plotInfo = {};
    plotInfo.ratName = ratName;
    plotInfo.sessionDateTimeAndSaveTag = sessionDateTimeAndSaveTag;
    plotInfo.ylabel = 'Angle (degrees)';
    plotInfo.varName = 'Position';
    %plotInfo.HRstr1 = strcat(string(sum(hitCatchTrialsIdxs)),"/",string(sum(catchTrialIdxs)));
    %plotInfo.HRstr2 = strcat(string(sum(hitNonCatchTrialsIdxs)),"/",string(sum(nonCatchTrialIdxs)));
    
    plotAlignedAll(trialTime, moveOnset, position, moveMax, conditionTrial, validTrial, plotInfo);

    %% plot data current

    plotInfo = {};
    plotInfo.ratName = ratName;
    plotInfo.sessionDateTimeAndSaveTag = sessionDateTimeAndSaveTag;
    plotInfo.ylabel = 'Current (A)';
    plotInfo.varName = 'Motor current';
    %plotInfo.HRstr1 = strcat(string(sum(hitCatchTrialsIdxs)),"/",string(sum(catchTrialIdxs)));
    %plotInfo.HRstr2 = strcat(string(sum(hitNonCatchTrialsIdxs)),"/",string(sum(nonCatchTrialIdxs)));
    
    %plotAlignedAll(trialTime, moveOnset, motorCurrentCom, moveMax, conditionTrial, validTrial, plotInfo);
    plotAlignedAll(trialTime, moveOnset, motorCurrent, moveMax, conditionTrial, validTrial, plotInfo);
    plotAlignedAll(trialTime, moveOnset, motorCurrentCom, moveMax, conditionTrial, validTrial, plotInfo);
    %     
%     figure()
%     set(gcf, 'OuterPosition', [10, 10, 1290, 1290]);
%     
%     ax1 = subplot(2,1,1); hold('on');
%     
%     subplot(2,1,1); 
%     
%     plot(trialTime{i}, zeros(size(trialTime{i})),'--', 'LineWidth', 2, 'Color', [0, 0, 1, 0.4]);
%     for i = 1:numel(allTrials)
%         %if (allTrials(i).flagFail == failFlag && failFlag ~= 0)allTrials(i).flagFail
%         t_offset = trialTime{i}(moveOnset{i});
%         if length(t_offset)>0 && ismember(i,allCatchIdx) % failFlag == 255 % this allows plotting ALL fail flags if set to 255
%             if (allTrials(i).flagFail == 0)
%                 plot(trialTime{i}(1:moveMax{i})-t_offset, position{i}(1:moveMax{i}), 'LineWidth', 2, 'Color', [0, 0, 0, 0.4]);
%             else
%                 plot(trialTime{i}(1:moveMax{i})-t_offset, position{i}(1:moveMax{i}), 'LineWidth', 1, 'Color', [.5, 0, 0, 0.4]);
%             end
%         end    
%     end
% 
%     xlabel('Time (ms)');
%     ylabel('Angle (degrees)');
%     title(strcat("(Catch trials) Position for ", ratName, " for Session ", sessionDateTimeAndSaveTag, " - HR: ", string(HR_c)));
%     %line([minHoldTime minHoldTime], [-holdPosMax-1 holdPosMax+1], 'LineWidth', 4, 'Color',[1,0,0,.8]);
%     %line([0 minHoldTime], [-holdPosMax -holdPosMax], 'LineWidth', 4, 'Color', [.8, .6, 0, 0.4]);
%     %line([0 minHoldTime], [holdPosMax holdPosMax], 'LineWidth', 4, 'Color', [.8, .6, 0, 0.4], 'HandleVisibility', 'off');
% 
%     % fix nasty legend
%     L(1) = plot(nan, nan, 'LineWidth', 2, 'Color', [0, 0, 0, 0.4]);
%     L(2) = plot(nan, nan, 'LineWidth', 1, 'Color', [.5, 0, 0, 0.4]);
%     legend(L, {'Successful Kinematics', char(strcat("failFlag",string(failFlag), " Kinematics"))}); %, 'motorCurrentStart');
%        
%     
%     ax2 = subplot(2,1,2); hold('on');
%     
%     plot(trialTime{i}, zeros(size(trialTime{i})),'--', 'LineWidth', 2, 'Color', [0, 0, 1, 0.4]);
%     for i = 1:numel(allTrials)
%         %if (allTrials(i).flagFail == failFlag && failFlag ~= 0)allTrials(i).flagFail
%         t_offset = trialTime{i}(moveOnset{i});
%         if length(t_offset)>0 && ~ismember(i,allCatchIdx) % failFlag == 255 % this allows plotting ALL fail flags if set to 255
%             if (allTrials(i).flagFail == 0)
%                 plot(trialTime{i}(1:moveMax{i})-t_offset, position{i}(1:moveMax{i}), 'LineWidth', 2, 'Color', [0, 0, 0, 0.4]);
%             else
%                 plot(trialTime{i}(1:moveMax{i})-t_offset, position{i}(1:moveMax{i}), 'LineWidth', 1, 'Color', [.5, 0, 0, 0.4]);
%             end
%             %plot(trialTime{i}(1:moveMax{i})-t_offset, 180/pi*position_filt{i}(1:moveMax{i}), 'LineWidth', 1, 'Color', [0, 0.5, 0, 0.4]);
%         end    
%     end
%     
%     xlabel('Time (ms)');
%     ylabel('Angle (degrees)');
%     title(strcat("(Non-catch trials) Position for ", ratName, " for Session ", sessionDateTimeAndSaveTag, " - HR: ", string(HR_nc)));
%     %line([minHoldTime minHoldTime], [-holdPosMax-1 holdPosMax+1], 'LineWidth', 4, 'Color',[1,0,0,.8]);
%     %line([0 minHoldTime], [-holdPosMax -holdPosMax], 'LineWidth', 4, 'Color', [.8, .6, 0, 0.4]);
%     %line([0 minHoldTime], [holdPosMax holdPosMax], 'LineWidth', 4, 'Color', [.8, .6, 0, 0.4], 'HandleVisibility', 'off'); 
% 
%     % fix nasty legend
%     L(1) = plot(nan, nan, 'LineWidth', 2, 'Color', [0, 0, 0, 0.4]);
%     L(2) = plot(nan, nan, 'LineWidth', 1, 'Color', [.5, 0, 0, 0.4]);
%     legend(L, {'Successful Kinematics', char(strcat("failFlag",string(failFlag), " Kinematics"))}); %, 'motorCurrentStart');
%      
%     
%     linkaxes([ax1,ax2],'xy')
    
    %% plot data current

%     figure()
%     set(gcf, 'OuterPosition', [10, 10, 1290, 1290]);
%     
%     ax1 = subplot(2,1,1); hold('on');
%     
%     subplot(2,1,1); 
%     
%     for i = 1:numel(allTrials)
%         %if (allTrials(i).flagFail == failFlag && failFlag ~= 0)allTrials(i).flagFail
%         t_offset = trialTime{i}(moveOnset{i});
%         if length(t_offset)>0 && ismember(i,allCatchIdx) % failFlag == 255 % this allows plotting ALL fail flags if set to 255
%             if (allTrials(i).flagFail == 0)
%                 plot(trialTime{i}(1:moveMax{i})-t_offset, -motorCurrent{i}(1:moveMax{i}), 'LineWidth', 2, 'Color', [0, 0, 0, 0.4]);
%             else
%                 plot(trialTime{i}(1:moveMax{i})-t_offset, -motorCurrent{i}(1:moveMax{i}), 'LineWidth', 1, 'Color', [.5, 0, 0, 0.4]);
%             end
%         end    
%     end
% 
%     xlabel('Time (ms)');
%     ylabel('Current (A)');
%     title(strcat("(Catch trials) Current for ", ratName, " for Session ", sessionDateTimeAndSaveTag, " - HR: ", string(HR_c)));
%     %line([minHoldTime minHoldTime], [-holdPosMax-1 holdPosMax+1], 'LineWidth', 4, 'Color',[1,0,0,.8]);
%     %line([0 minHoldTime], [-holdPosMax -holdPosMax], 'LineWidth', 4, 'Color', [.8, .6, 0, 0.4]);
%     %line([0 minHoldTime], [holdPosMax holdPosMax], 'LineWidth', 4, 'Color', [.8, .6, 0, 0.4], 'HandleVisibility', 'off');
% 
%     % fix nasty legend
%     L(1) = plot(nan, nan, 'LineWidth', 4, 'Color',[1,0,0,.8]);
%     L(2) = plot(nan, nan, 'LineWidth', 4, 'Color',[.8, .6, 0, 0.4]);
%     L(3) = plot(nan, nan, 'LineWidth', 2, 'Color', [0, 0, 0, 0.4]);
%     L(4) = plot(nan, nan, 'LineWidth', 1, 'Color', [.5, 0, 0, 0.4]);
%     legend(L, {'End of Hold Period', 'Max Allowed Angle During Hold', 'Successful Kinematics', char(strcat("failFlag",string(failFlag), " Kinematics"))}); %, 'motorCurrentStart');
%        
%     
%     ax2 = subplot(2,1,2); hold('on');
%     
%     for i = 1:numel(allTrials)
%         %if (allTrials(i).flagFail == failFlag && failFlag ~= 0)allTrials(i).flagFail
%         t_offset = trialTime{i}(moveOnset{i});
%         if length(t_offset)>0 && ~ismember(i,allCatchIdx) % failFlag == 255 % this allows plotting ALL fail flags if set to 255
%             if (allTrials(i).flagFail == 0)
%                 plot(trialTime{i}(1:moveMax{i})-t_offset, -motorCurrent{i}(1:moveMax{i}), 'LineWidth', 2, 'Color', [0, 0, 0, 0.4]);
%             else
%                 plot(trialTime{i}(1:moveMax{i})-t_offset, -motorCurrent{i}(1:moveMax{i}), 'LineWidth', 1, 'Color', [.5, 0, 0, 0.4]);
%             end
%         end    
%     end
%     
%     xlabel('Time (ms)');
%     ylabel('Current (A)');
%     title(strcat("(Non-catch trials) Current for ", ratName, " for Session ", sessionDateTimeAndSaveTag, " - HR: ", string(HR_nc)));
%     %line([minHoldTime minHoldTime], [-holdPosMax-1 holdPosMax+1], 'LineWidth', 4, 'Color',[1,0,0,.8]);
%     %line([0 minHoldTime], [-holdPosMax -holdPosMax], 'LineWidth', 4, 'Color', [.8, .6, 0, 0.4]);
%     %line([0 minHoldTime], [holdPosMax holdPosMax], 'LineWidth', 4, 'Color', [.8, .6, 0, 0.4], 'HandleVisibility', 'off'); 
% 
%     % fix nasty legend
%     L(1) = plot(nan, nan, 'LineWidth', 4, 'Color',[1,0,0,.8]);
%     L(2) = plot(nan, nan, 'LineWidth', 4, 'Color',[.8, .6, 0, 0.4]);
%     L(3) = plot(nan, nan, 'LineWidth', 2, 'Color', [0, 0, 0, 0.4]);
%     L(4) = plot(nan, nan, 'LineWidth', 1, 'Color', [.5, 0, 0, 0.4]);
%     legend(L, {'End of Hold Period', 'Max Allowed Angle During Hold', 'Successful Kinematics', char(strcat("failFlag",string(failFlag), " Kinematics"))}); %, 'motorCurrentStart');
% 
%     
%     linkaxes([ax1,ax2],'xy')

        %% plot data current

%     figure()
%     set(gcf, 'OuterPosition', [10, 10, 1290, 1290]);
%     
%     ax1 = subplot(2,1,1); hold('on');
%     
%     subplot(2,1,1); 
%     
%     for i = 1:numel(allTrials)
%         %if (allTrials(i).flagFail == failFlag && failFlag ~= 0)allTrials(i).flagFail
%         t_offset = trialTime{i}(moveOnset{i});
%         if length(t_offset)>0 && ismember(i,allCatchIdx) % failFlag == 255 % this allows plotting ALL fail flags if set to 255
%             if (allTrials(i).flagFail == 0)
%                 plot(trialTime{i}(1:moveMax{i})-t_offset, -torque{i}(1:moveMax{i}), 'LineWidth', 2, 'Color', [0, 0, 0, 0.4]);
%             else
%                 plot(trialTime{i}(1:moveMax{i})-t_offset, -torque{i}(1:moveMax{i}), 'LineWidth', 1, 'Color', [.5, 0, 0, 0.4]);
%             end
%         end    
%     end
% 
%     xlabel('Time (ms)');
%     ylabel('Torque (mNm)');
%     title(strcat("(Catch trials) Torque for ", ratName, " for Session ", sessionDateTimeAndSaveTag, " - HR: ", string(HR_c)));
%     %line([minHoldTime minHoldTime], [-holdPosMax-1 holdPosMax+1], 'LineWidth', 4, 'Color',[1,0,0,.8]);
%     %line([0 minHoldTime], [-holdPosMax -holdPosMax], 'LineWidth', 4, 'Color', [.8, .6, 0, 0.4]);
%     %line([0 minHoldTime], [holdPosMax holdPosMax], 'LineWidth', 4, 'Color', [.8, .6, 0, 0.4], 'HandleVisibility', 'off');
% 
%     % fix nasty legend
%     L(1) = plot(nan, nan, 'LineWidth', 4, 'Color',[1,0,0,.8]);
%     L(2) = plot(nan, nan, 'LineWidth', 4, 'Color',[.8, .6, 0, 0.4]);
%     L(3) = plot(nan, nan, 'LineWidth', 2, 'Color', [0, 0, 0, 0.4]);
%     L(4) = plot(nan, nan, 'LineWidth', 1, 'Color', [.5, 0, 0, 0.4]);
%     legend(L, {'End of Hold Period', 'Max Allowed Angle During Hold', 'Successful Kinematics', char(strcat("failFlag",string(failFlag), " Kinematics"))}); %, 'motorCurrentStart');
%        
%     
%     ax2 = subplot(2,1,2); hold('on');
%     
%     for i = 1:numel(allTrials)
%         %if (allTrials(i).flagFail == failFlag && failFlag ~= 0)allTrials(i).flagFail
%         t_offset = trialTime{i}(moveOnset{i});
%         if length(t_offset)>0 && ~ismember(i,allCatchIdx) % failFlag == 255 % this allows plotting ALL fail flags if set to 255
%             if (allTrials(i).flagFail == 0)
%                 plot(trialTime{i}(1:moveMax{i})-t_offset, -torque{i}(1:moveMax{i}), 'LineWidth', 2, 'Color', [0, 0, 0, 0.4]);
%             else
%                 plot(trialTime{i}(1:moveMax{i})-t_offset, -torque{i}(1:moveMax{i}), 'LineWidth', 1, 'Color', [.5, 0, 0, 0.4]);
%             end
%         end    
%     end
%     
%     xlabel('Time (ms)');
%     ylabel('Angle (degrees)');
%     title(strcat("(Non-catch trials) Torque for ", ratName, " for Session ", sessionDateTimeAndSaveTag, " - HR: ", string(HR_nc)));
%     %line([minHoldTime minHoldTime], [-holdPosMax-1 holdPosMax+1], 'LineWidth', 4, 'Color',[1,0,0,.8]);
%     %line([0 minHoldTime], [-holdPosMax -holdPosMax], 'LineWidth', 4, 'Color', [.8, .6, 0, 0.4]);
%     %line([0 minHoldTime], [holdPosMax holdPosMax], 'LineWidth', 4, 'Color', [.8, .6, 0, 0.4], 'HandleVisibility', 'off'); 
% 
%     % fix nasty legend
%     L(1) = plot(nan, nan, 'LineWidth', 4, 'Color',[1,0,0,.8]);
%     L(2) = plot(nan, nan, 'LineWidth', 4, 'Color',[.8, .6, 0, 0.4]);
%     L(3) = plot(nan, nan, 'LineWidth', 2, 'Color', [0, 0, 0, 0.4]);
%     L(4) = plot(nan, nan, 'LineWidth', 1, 'Color', [.5, 0, 0, 0.4]);
%     legend(L, {'End of Hold Period', 'Max Allowed Angle During Hold', 'Successful Kinematics', char(strcat("failFlag",string(failFlag), " Kinematics"))}); %, 'motorCurrentStart');
% 
%     
%     linkaxes([ax1,ax2],'xy')
    

    
    %% save figures

%     if ~strcmp(pngFlag,'nopng')
%         sessionTimeStamp = char(string(in.trials(1).dateTimeTag));
%         fileName = char(strcat(ratName(1), "_kine_failFlag", string(failFlag),"_", sessionTimeStamp,".png"));
%         fname = char(pngPath);
%         saveas(f,fullfile(fname, fileName),'png')
%         close(f)
%     end
    
end