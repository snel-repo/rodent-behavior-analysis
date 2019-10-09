function [meanMat] = plotKnobTurn(in, summary)
resp = inputFlex('How many ms pre-turn attempt?: ', [-inf inf], [50]);
pl = inputFlex('Which plots do you want? (1 = summ, 2 = raw traces, 3 = violin, 4 = trial-by-trial', [1 5], [1 3 4]);
resp = resp / 2; % accomodate for sampling freq
I_knob = 9.66179E-07;
if any(pl == 2)
    figure('units','normalized','outerposition',[0 0 1 1])
    for i = 1 : length(in)
        tmp = in(i).trials;
        for j = 1 : length(tmp)
            if tmp(j).attemptType == 0
                plotTime = 0 : tmp(j).sampleTime : tmp(j).sampleTime * ((length(tmp(j).attemptIdx) + resp) - 1); % first, make a timespan equal to the length of the attempt and pre + post of the attempt
                plotTime = plotTime - resp * tmp(j).sampleTime; % then, timeshift plotTime by the pre-attempt
                if tmp(j).hitTrial
                    lineColor = [0 0 1 0.1];
                    subplot(2,2,1)
                    p1 = plot(plotTime, tmp(j).pos(tmp(j).attemptIdx(1)  : tmp(j).attemptIdx(end) + resp), 'lineWidth', 1, 'color', lineColor);
                    %p1.Color(4) = 0.2;
                    hold on
                    subplot(2,2,3)
                    p2 = plot(plotTime, tmp(j).velRaw(tmp(j).attemptIdx(1) : tmp(j).attemptIdx(end) + resp),  'lineWidth', 1, 'color', lineColor);
                    %p2.Color(4) = 0.2;
                    hold on
                else
                    lineColor = [1 0 0 0.1];
                    subplot(2,2,2)
                    p3 = plot(plotTime, tmp(j).pos(tmp(j).attemptIdx(1)  : tmp(j).attemptIdx(end) + resp), 'lineWidth', 1, 'color', lineColor);
                    %p3.Color(4) = 0.2;
                    hold on
                    subplot(2,2,4)
                    p4 = plot(plotTime, tmp(j).velRaw(tmp(j).attemptIdx(1)  : tmp(j).attemptIdx(end) + resp),  'lineWidth', 1, 'color', lineColor);
                    %p4.Color(4) = 0.2;
                    hold on
                end
                
            end
            if tmp(j).attemptType == 0
                
                %                 % scrollsubplot(2,2, 2 * (i - 1) + 1)
                %                 plot(plotTime, tmp(j).pos(tmp(j).attemptIdx(1) - resp : tmp(j).attemptIdx(end) + resp), 'lineWidth', 0.5, 'color', lineColor)
                %                 hold on
                %                 % scrollsubplot(2,2, 2 * (i - 1) + 2)
                %                 plot(plotTime, tmp(j).velRaw(tmp(j).attemptIdx(1) - resp : tmp(j).attemptIdx(end) + resp),  'lineWidth', 0.5, 'color', lineColor)
                %                 hold on
            end
        end
    end
    
    for i = 1 : length(in)
        tmp = in(i).trials;
        tmp([tmp(:).attemptType] == 1) = [];
        longestTurn = max([tmp(:).lengthAttempt]);
        posSucc = [];
        posFail = [];
        velSucc = [];
        velFail = [];
        maxFail = 0;
        plt = Plot(nan, nan, nan, nan, nan, nan, nan, nan);
        plt.LineWidth = [1.5 1.5 3 3];
        plt.Colors = {[229/255 229/255 1], [1 229/255 229/255], [0 0 1], [1 0 0]};
        
        plt.XLabel = 'Time (s)';
        plt.YLabel = 'Knob position (deg)';
        
        plt.BoxDim = [8 8];
        hold on;
        for j = 1 : length(tmp)
            if tmp(j).attemptType == 0
                plotTime = 0 : tmp(j).sampleTime : tmp(j).sampleTime * ((length(tmp(j).attemptIdx) + resp) - 1); % first, make a timespan equal to the length of the attempt and pre + post of the attempt
                plotTime = plotTime - resp * tmp(j).sampleTime; % then, timeshift plotTime by the pre-attempt
                tmpPos = [tmp(j).pos(tmp(j).attemptIdx(1)  : tmp(j).attemptIdx(end) + resp)' tmp(j).pos(tmp(j).attemptIdx(end))*ones(1, longestTurn - length(tmp(j).attemptIdx))];
                tmpVel = [tmp(j).velRaw(tmp(j).attemptIdx(1)  : tmp(j).attemptIdx(end) + resp)' zeros(1,longestTurn - length(tmp(j).attemptIdx))];
                tz = [0; diff(deg2rad(tmp(j).velRaw(tmp(j).attemptIdx(1) : tmp(j).attemptIdx(end) + resp)))] * ((I_knob * 1000) / 0.002);
                if tmp(j).hitTrial
                    lineColor = [0 0 1 0.1];
                    posSucc = [posSucc; tmpPos];
                    velSucc = [velSucc; tmpVel];
                    %p1 = plot(plotTime, tmp(j).pos(tmp(j).attemptIdx(1)  : tmp(j).attemptIdx(end) + resp), 'lineWidth', 1.5, 'color', lineColor);
                    %p2 = plot(plotTime, tmp(j).velRaw(tmp(j).attemptIdx(1) : tmp(j).attemptIdx(end) + resp),  'lineWidth', 1.5, 'color', lineColor);
                    p2 = plot(plotTime, tz,  'lineWidth', 1.5, 'color', lineColor);
                    %p2.Color(4) = 0.2;
                    hold on
                else
                    maxFail = max(maxFail, tmp(j).lengthAttempt);
                    posFail = [posFail; tmpPos];
                    velFail = [velFail; tmpVel];
                    lineColor = [1 0 0 0.1];
                    %p3 = plot(plotTime, tmp(j).pos(tmp(j).attemptIdx(1)  : tmp(j).attemptIdx(end) + resp), 'lineWidth', 1.5, 'color', lineColor);
                    %p4 = plot(plotTime, tmp(j).velRaw(tmp(j).attemptIdx(1)  : tmp(j).attemptIdx(end) + resp),  'lineWidth', 1.5, 'color', lineColor);
                    p4 = plot(plotTime, tz,  'lineWidth', 1.5, 'color', lineColor);
                    %p4.Color(4) = 0.2;
                end
                
            end
        end
        plotTime2 = 0 : tmp(j).sampleTime : tmp(j).sampleTime * (longestTurn - 1);
        plot(plotTime2, [0 diff(deg2rad(mean(velSucc))) /  0.002 * I_knob * 1000], 'lineWidth', 3, 'color', [0 0 1]);
        meanPosFail = [0 diff(deg2rad(mean(velFail))) /  0.002 * I_knob * 1000];
        plot(plotTime2(1:maxFail), meanPosFail(1:maxFail), 'lineWidth', 3, 'color', [1 0 0])
        lege = legend({'Successful Attempt', 'Failed Attempt', 'Mean Successful', 'Mean Failed'});
        lege.Box = 'off';
    end
end
if any(pl == 5) % compare means only
    stiffMat = [0.18 0.36 0.54 0.72 1.08 1.44];
    fric = 0.28;
    for i = 1 : length(in)
        tmp = in(i).trials;
        tmp([tmp(:).attemptType] == 1) = [];
        longestTurn = max([tmp(:).lengthAttempt]);
        posSucc = [];
        posMaxSucc = [];
        posMaxFail = [];
        posFail = [];
        velSucc = [];
        velFail = [];
        velMaxSucc = [];
        velMaxFail = [];
        maxFail = 0;
        for j = 1 : length(tmp)
            if tmp(j).attemptType == 0
                tmpPos = [tmp(j).pos(tmp(j).attemptIdx(1)  : tmp(j).attemptIdx(end) + resp)' tmp(j).pos(tmp(j).attemptIdx(end))*ones(1, longestTurn - length(tmp(j).attemptIdx))];
                tmpVel = [tmp(j).velRaw(tmp(j).attemptIdx(1)  : tmp(j).attemptIdx(end) + resp)' zeros(1,longestTurn - length(tmp(j).attemptIdx))];
                if tmp(j).hitTrial
                    posSucc = [posSucc; tmpPos];
                    velSucc = [velSucc; tmpVel];
                    posMaxSucc = [posMaxSucc max(tmpPos)];
                    velMaxSucc = [velMaxSucc max(tmpVel)];
                else
                    maxFail = max(maxFail, tmp(j).lengthAttempt);
                    posFail = [posFail; tmpPos];
                    velFail = [velFail; tmpVel];
                    posMaxFail = [posMaxFail max(tmpPos)];
                    velMaxFail = [velMaxFail max(tmpVel)];
                end
            end
        end
        meanMat(i).posSucc = mean(posSucc);
        meanMat(i).posSuccMax = mean(posMaxSucc);
        meanMat(i).stdPSM = std(posMaxSucc);
        
        meanMat(i).posFail = mean(posFail);
        meanMat(i).posFailMax = mean(posMaxFail);
        meanMat(i).stdPFM = std(posMaxFail);
        maxAll = [ max(posSucc, [], 2); max(posFail, [], 2)];
        meanMat(i).posMeanMax = mean(maxAll);
        meanMat(i).posMaxAll = maxAll;
        meanMat(i).posStdAll = std(maxAll);
        
        meanMat(i).velSucc = mean(velSucc);
        meanMat(i).velSuccMax = mean(velMaxSucc);
        meanMat(i).stdVSM = std(velMaxSucc);
        
        meanMat(i).velFail = mean(velFail);
        meanMat(i).velFailMax = mean(velMaxFail);
        meanMat(i).stdVFM = std(velMaxFail);
        
        maxAll = [ max(velSucc, [], 2); max(velFail, [], 2)];
        meanMat(i).velMaxAll = maxAll;
        meanMat(i).velMeanMax = mean(maxAll);
        meanMat(i).velStdAll = std(maxAll);
        
        TzSucc = [zeros(size(velSucc,1), 1) diff(deg2rad(velSucc), 1, 2)] .* (( I_knob * 1000) / 0.002);
        meanMat(i).TzSucc = TzSucc;
        meanMat(i).TzSuccMax = mean(max(TzSucc, [], 2));
        meanMat(i).stdTSM = std(max(TzSucc, [], 2));
        
        TzFail = [zeros(size(velFail,1), 1) diff(deg2rad(velFail), 1, 2)] .*  (( I_knob * 1000) / 0.002);
        meanMat(i).TzFail = TzFail;
        meanMat(i).TzFailMax = mean(max(TzFail, [], 2));
        meanMat(i).stdTFM = std(max(TzFail, [], 2));
        
        meanMat(i).TzMaxAll = [max(TzSucc, [], 2); max(TzFail, [], 2)];
        meanMat(i).TzMeanMax = mean([max(TzSucc, [], 2); max(TzFail, [], 2)]);
        meanMat(i).TzStdAll = std([max(TzSucc, [], 2); max(TzFail, [], 2)]);
        for j = 1 : size(meanMat(i).TzSucc,1)
            tmp2 = meanMat(i).TzSucc(j,:);
            tmp2(velSucc(j,:) > 15) = tmp2(velSucc(j,:) > 15) +  stiffMat(i) + fric;
            meanMat(i).TzSuccRatAll(j,:) = tmp2;
        end
        meanMat(i).TzSuccRatMax = max(meanMat(i).TzSuccRatAll, [], 2);
                for j = 1 : size(meanMat(i).TzFail,1)
            tmp2 = meanMat(i).TzFail(j,:);
            tmp2(velFail(j,:) > 15) = tmp2(velFail(j,:) > 15) +  stiffMat(i) + fric;
            meanMat(i).TzFailRatAll(j,:) = tmp2;
                end
        meanMat(i).TzFailRatMax = max(meanMat(i).TzFailRatAll, [], 2);
        meanMat(i).TzRatMaxAll = [meanMat(i).TzSuccRatMax; meanMat(i).TzFailRatMax];
        tmpTz = mean(meanMat(i).TzSucc);
        tmpTz(meanMat(i).velSucc > 15) = tmpTz(meanMat(i).velSucc > 15) + stiffMat(i) + fric;
        meanMat(i).TzSuccRat = tmpTz;
        tmpTz = mean(meanMat(i).TzFail);
        tmpTz(meanMat(i).velFail > 15) = tmpTz(meanMat(i).velFail > 15) + stiffMat(i) + fric;
        meanMat(i).TzFailRat = tmpTz;
        meanMat(i).longestTurn = longestTurn;
        meanMat(i).longestTurnFail = maxFail;
        meanMat(i).stiffness = tmp(end).stiffCurrentMax / 1000 * 36;
    end
    plt = Plot(nan,nan,nan,nan,nan,nan,nan,nan,nan,nan,nan,nan,nan,nan,nan,nan,nan,nan,nan,nan,nan,nan,nan,nan);
    plt.LineWidth = [3 3];
    x = distinguishable_colors(12);
    xCell = num2cell(x,2);
    %plt.Colors = {[0 0 1/6], [0 0 2/6], [0 0 3/6], [0 0 4/6],[0 0 5/6], [0 0 6/6],[1/6 0 0], [2/6 0 0],[3/6 0 0], [4/6 0 0],[5/6 0 0], [6/6 0 0]};
    %plt.Colors = xCell;
    pltColors = {convC([0 27 51]), convC([0 54 102]), convC([0 81 153]), convC([0 108 204]), convC([0 135 255]), convC([51 159 255]),...
        convC([49 2 11]), convC([98 4 22]), convC([147 6 33]), convC([196 8 44]), convC([245 10 55]), convC([247 59 95])};
    plt.Colors = pltColors(7:end);
    plt.XLabel = 'Time (s)';
    plt.YLabel = 'Knob net torque (mNm)';
    
    plt.BoxDim = [8 4];
    hold on;
    for i = 1 : length(meanMat)
        
        plotTime = 0 : tmp(j).sampleTime : tmp(j).sampleTime * (meanMat(i).longestTurn - 1);
        %      plot(plotTime, meanMat(i).TzSucc, 'lineWidth', 3, 'color', [0 0 i/length(meanMat)])
        %      plot(plotTime(1:meanMat(i).longestTurnFail), meanMat(i).posFail(1:meanMat(i).longestTurnFail), 'lineWidth', 3, 'color', [i/length(meanMat) 0 0])
%                 plot(plotTime, mean(meanMat(i).TzFail), 'lineWidth', 3, 'color', pltColors{i})
        plot(plotTime(1:meanMat(i).longestTurnFail), mean(meanMat(i).TzFail(:, 1:meanMat(i).longestTurnFail)), 'lineWidth', 3, 'color', pltColors{i+6})
    end
    %     lege = legend({'0.18mNm Success', '0.36mNm Success', '0.54mNm Success', '0.72mNm Success', '1.08mNm Success', '1.44mNm Success',...
    %          '0.18mNm Fail', '0.36mNm Fail', '0.54mNm Fail', '0.72mNm Fail', '1.08mNm Fail', '1.44mNm Fail'});
    lege=  legend({ '0.18mNm Fail', '0.36mNm Fail', '0.54mNm Fail', '0.72mNm Fail', '1.08mNm Fail', '1.44mNm Fail'});
%     lege=  legend({ '0.18mNm Success', '0.36mNm Success', '0.54mNm Success', '0.72mNm Success', '1.08mNm Success', '1.44mNm Success'});
    lege.Box = 'off';
    lege.Position = [0.7 0.8 0.2 0.07];
    %ylabel('Rat generated torque (mNm)')
    xlim([0 0.55])
    %ylim([-0.05 2.2])
    
    
        plt = Plot(nan,nan,nan,nan,nan,nan,nan,nan,nan,nan,nan,nan,nan,nan,nan,nan,nan,nan,nan,nan,nan,nan,nan,nan);
        hold on
    plt.LineWidth = [3 3];
    plt.BoxDim = [8 8];
    plt.Colors = pltColors(7:end);
    plt.XLabel = 'Knob position (deg)';
    plt.YLabel = 'Rat generated torque (mNm)';
    for i = 1 : length(meanMat)
        
      %  plotTime = 0 : tmp(j).sampleTime : tmp(j).sampleTime * (meanMat(i).longestTurn - 1);
        %      plot(plotTime, meanMat(i).TzSucc, 'lineWidth', 3, 'color', [0 0 i/length(meanMat)])
        %      plot(plotTime(1:meanMat(i).longestTurnFail), meanMat(i).posFail(1:meanMat(i).longestTurnFail), 'lineWidth', 3, 'color', [i/length(meanMat) 0 0])
        %        plot(plotTime, meanMat(i).TzSuccRat, 'lineWidth', 3, 'color', pltColors{i})
       plot(meanMat(i).posFail, meanMat(i).TzFailRat, 'lineWidth', 3, 'color', pltColors{i+6})
        %plot(plotTime(1:meanMat(i).longestTurnFail), meanMat(i).TzFailRat(1:meanMat(i).longestTurnFail), 'lineWidth', 3, 'color', pltColors{i+6})
    end
    %     lege = legend({'0.18mNm Success', '0.36mNm Success', '0.54mNm Success', '0.72mNm Success', '1.08mNm Success', '1.44mNm Success',...
    %          '0.18mNm Fail', '0.36mNm Fail', '0.54mNm Fail', '0.72mNm Fail', '1.08mNm Fail', '1.44mNm Fail'});
   lege=  legend({ '0.18mNm Fail', '0.36mNm Fail', '0.54mNm Fail', '0.72mNm Fail', '1.08mNm Fail', '1.44mNm Fail'});
%    lege=  legend({ '0.18mNm Success', '0.36mNm Success', '0.54mNm Success', '0.72mNm Success', '1.08mNm Success', '1.44mNm Success'});
    lege.Box = 'off';
      lege.Position = [0.67 0.8 0.2 0.07];
      xlim([0 100])
          ylim([-0.05 2.2])
end
if any(pl == 1)
    plt = Plot(nan, nan, nan, nan);
    hold on
    %plt = Plot([summary(:).torqueMax], [summary(:).medianMaxAngle]);
    plt.BoxDim = [17 8];
    plt.Colors = {[0 0 0], [0.5 0.5 0.5]};
    plt.LineStyle = {'-', '--'};
    plt.LineWidth = [2 2];
    plot([summary(:).torqueMax], [summary(:).medianMaxAngle], 'lineWidth', 2, 'marker', 'o', 'color', [0 0 0])
    plot([summary(:).torqueMax], [summary(:).medianThresh], 'lineWidth', 2, 'marker', 'o', 'color', [0.5 0.5 0.5], 'linestyle', '--')
    plt.XLabel = 'Command torque (mNm)';
    plt.YLabel = 'Turn angle (deg)';
    plt.BoxDim = [8 8];
    lege = legend({'Median \theta_f', 'Median \theta_{thresh}'});
    lege.Position = [0.7 0.8 0.2 0.07];
    lege.Box = 'off';
    %plt.Marker
end

stiffStr = {'0.18', '0.36', '0.54', '0.72', '1.08', '1.44'};
if any(pl == 3)
    thresh = [];
    cate = [];
    for i = 1:length(in)
        tmp = in(i).trials;
        [tmpName{1:length(tmp)}] = deal(stiffStr{i});
        tmpData = [tmp(:).maxAngleTrialOnly];
        thresh = [thresh tmpData];
        cate = [cate tmpName];
        tmpName = [];
    end
    figure('units','normalized','outerposition',[0 0 1 1])
    violinplot(thresh, cate, 'boxcolor', [0 0 0], 'violincolor', [0 0.5 1])
    set(gca, 'FontSize', 20)
    set(gca, 'YMinorTick', 'on')
    %set(gca, 'XTickLabel', num2str((1:length(in))'));
    set(gca, 'TickLength', [0.025 0.4])
    set(gcf, 'units', 'inches',  'Position', [0 0 12 12]);
    box on
    set(gca, 'LineWidth', 1.5)
    set(gcf,'color','w');
    xlabel('Command torque (mNm)')
    ylabel('Maximum turning angle, \theta_f (deg)')
    
    thresh = [];
    cate = [];
    for i = 1:length(in)
        tmp = in(i).trials;
        [tmpName{1:length(tmp)}] = deal(stiffStr{i});
        tmpData = [tmp(:).thresh];
        thresh = [thresh tmpData];
        cate = [cate tmpName];
        tmpName = [];
    end
    figure('units','normalized','outerposition',[0 0 1 1])
    violinplot(double(thresh), cate, 'boxcolor', [0 0 0], 'violincolor', [0 0.5 1])
    set(gca, 'FontSize', 20)
    set(gca, 'YMinorTick', 'on')
    %set(gca, 'XTickLabel', num2str((1:length(in))'));
    set(gca, 'TickLength', [0.025 0.4])
    set(gcf, 'units', 'inches',  'Position', [0 0 12 12]);
    box on
    set(gca, 'LineWidth', 1.5)
    set(gcf,'color','w');
    xlabel('Command torque (mNm)')
    ylabel('Minimum threshold, \theta_{thresh} (deg)')
end

if any(pl == 4)
    maxX = 0;
    figure('units','normalized','outerposition',[0 0 1 1])
    q = 4;
    row = length(in);
    for i = 1:row
        scrollsubplot(q, 1, i);
        tmp = in(i).trials; %
        plot([tmp(:).maxAngleTrialOnly], 'lineWidth', 2)
        hold on
        plot([tmp(:).thresh], 'lineWidth', 2)
        ylim([min([tmp(:).timeHoldThresh]) inf])
        ylabel('Angle (deg)') % mark xlabel with appropriate units
        xlabel('Trial #') % histogram is in probability distribution
        text(0.9, 0.9,[ summary(i).sessionTag ], 'Units', 'normalized')
        legend({'Max Turn Angle', 'Threshold'}, 'location', 'Northwest', 'box', 'off');
    end
end
end

function normColor = convC(x)
normColor = [x(1)/255 x(2)/255 x(3)/255];
end