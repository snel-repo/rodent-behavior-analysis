%function plotAlLigned
function plotAlignedAll(trialTime, moveOnset, var, moveMax, cond1, cond2, plotInfo, scale, N)

    
    conditionTrial = cell2mat(cond1);
    cmax = double(max(conditionTrial));

    validTrial = cell2mat(cond2);
    
    
    %% combined plot
    
    figure()
    set(gcf, 'OuterPosition', [10, 10, 1290, 1290]);
    hold on;
    
    n = 0;
    for i = 1:numel(trialTime)
        if n>=N
            break
        end
        t_offset = trialTime{i}(moveOnset{i});
        %if (allTrials(i).flagFail == failFlag && failFlag ~= 0)allTrials(i).flagFail
        if length(t_offset)>0 && validTrial(i)==1 % failFlag == 255 % this allows plotting ALL fail flags if set to 255
            
            n = n+1;
            c = double(conditionTrial(i))/cmax;
            
            plot(trialTime{i}(1:moveMax{i})-t_offset, scale*var{i}(1:moveMax{i}), 'LineWidth', 2, 'Color', [0, c, 1-c, 0.5]);
        end    
    end

    xlabel('Time (ms)');
    ylabel('Angular velocity (rad/s)');
    title(strcat("(Catch trials) ", plotInfo.varName," for ", plotInfo.ratName, " for Session ", plotInfo.sessionDateTimeAndSaveTag))%, " - HR: ", plotInfo.HRstr1));

    xlim([0 500])

    end