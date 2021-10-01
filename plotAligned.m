%function plotAlLigned
function plotAligned(trialTime, moveOnset, var, moveMax, cond1, cond2, plotInfo)

    
    allCatchIdx = cond1;

    figure()
    set(gcf, 'OuterPosition', [10, 10, 1290, 1290]);
    
    ax1 = subplot(2,1,1); hold('on');
    
    subplot(2,1,1); 
    
    plot(trialTime{1}, zeros(size(trialTime{1})),'--', 'LineWidth', 2, 'Color', [0, 0, 1, 0.4]);
    for i = 1:numel(trialTime)
        t_offset = trialTime{i}(moveOnset{i});
        %if (allTrials(i).flagFail == failFlag && failFlag ~= 0)allTrials(i).flagFail
        if length(t_offset)>0 && ismember(i,allCatchIdx) % failFlag == 255 % this allows plotting ALL fail flags if set to 255
            if (cond2{i} == 0)
                plot(trialTime{i}(1:moveMax{i})-t_offset, var{i}(1:moveMax{i}), 'LineWidth', 2, 'Color', [0, 0, 0, 0.4]);
            else
                plot(trialTime{i}(1:moveMax{i})-t_offset, var{i}(1:moveMax{i}), 'LineWidth', 1, 'Color', [.5, 0, 0, 0.4]);
            end
        end    
    end

    xlabel('Time (ms)');
    ylabel('Angular velocity (rad/s)');
    title(strcat("(Catch trials) ", plotInfo.varName," for ", plotInfo.ratName, " for Session ", plotInfo.sessionDateTimeAndSaveTag, " - HR: ", plotInfo.HRstr1));
    %line([minHoldTime minHoldTime], [-holdPosMax-1 holdPosMax+1], 'LineWidth', 4, 'Color',[1,0,0,.8]);
    %line([0 minHoldTime], [-holdPosMax -holdPosMax], 'LineWidth', 4, 'Color', [.8, .6, 0, 0.4]);
    %line([0 minHoldTime], [holdPosMax holdPosMax], 'LineWidth', 4, 'Color', [.8, .6, 0, 0.4], 'HandleVisibility', 'off');

    % fix nasty legend
    L(1) = plot(nan, nan, 'LineWidth', 2, 'Color', [0, 0, 0, 0.4]);
    L(2) = plot(nan, nan, 'LineWidth', 1, 'Color', [.5, 0, 0, 0.4]);
    legend(L, {'Successful Kinematics', 'Fail'}); %, 'motorCurrentStart');
       
    
    ax2 = subplot(2,1,2); hold('on');
    
    plot(trialTime{i}, zeros(size(trialTime{i})),'--', 'LineWidth', 2, 'Color', [0, 0, 1, 0.4]);
    for i = 1:numel(trialTime)
        %if (allTrials(i).flagFail == failFlag && failFlag ~= 0)allTrials(i).flagFail
        t_offset = trialTime{i}(moveOnset{i});
        if length(t_offset)>0 && ~ismember(i,allCatchIdx) % failFlag == 255 % this allows plotting ALL fail flags if set to 255
            if (cond2{i} == 0)
                plot(trialTime{i}(1:moveMax{i})-t_offset, var{i}(1:moveMax{i}), 'LineWidth', 2, 'Color', [0, 0, 0, 0.4]);
            else
                plot(trialTime{i}(1:moveMax{i})-t_offset, var{i}(1:moveMax{i}), 'LineWidth', 1, 'Color', [.5, 0, 0, 0.4]);
            end
        end    
    end
    
    xlabel('Time (ms)');
    ylabel('Angular velocity (rad/s)');
    title(strcat("(Non-catch trials) ", plotInfo.varName," for ", plotInfo.ratName, " for Session ", plotInfo.sessionDateTimeAndSaveTag, " - HR: ", plotInfo.HRstr2));
    %line([minHoldTime minHoldTime], [-holdPosMax-1 holdPosMax+1], 'LineWidth', 4, 'Color',[1,0,0,.8]);
    %line([0 minHoldTime], [-holdPosMax -holdPosMax], 'LineWidth', 4, 'Color', [.8, .6, 0, 0.4]);
    %line([0 minHoldTime], [holdPosMax holdPosMax], 'LineWidth', 4, 'Color', [.8, .6, 0, 0.4], 'HandleVisibility', 'off'); 

    % fix nasty legend
    L(1) = plot(nan, nan, 'LineWidth', 2, 'Color', [0, 0, 0, 0.4]);
    L(2) = plot(nan, nan, 'LineWidth', 1, 'Color', [.5, 0, 0, 0.4]);
    legend(L, {'Successful Kinematics', 'Fail'}); %, 'motorCurrentStart');
     
    
    linkaxes([ax1,ax2],'xy')
    
    end