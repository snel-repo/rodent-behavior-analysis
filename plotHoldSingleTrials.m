function plotHoldSingleTrials(in, summary)

q = input('Number of subplots per scroll section: ');
%% Plot overlapped histogram
% plt = Plot(NaN, NaN); % initialize a Plot library plot with non values
% hold on
% plt.BoxDim = [17 8]; % figure box size in inches
% plt.XMinorTick = 'off'; % turn off minor ticks on x axis because histogram
% xlabel('Hold Time Threshold (ms)') % mark xlabel with appropriate units
% ylabel('Probability') % histogram is in probability distribution
% maxY = 0;
% for i = 1:length(in)
%     tmp = in(i).trials; %
%     holdThresh  = [tmp(:).timeHoldThresh];
%     
%     h = histogram(holdThresh, 20);
%     h.LineWidth = 2;
%     h.FaceAlpha = 0.8;
%     h.Normalization = 'probability';
%     currentXLim = xlim;
%     currentYLim = ylim;
%     if currentYLim(2) > maxY
%         maxY = currentYLim(2);
%     end
%     plt.XLim = [currentXLim(1)-10, currentXLim(2)+10];
%     %q(i) = get(gca, 'children');
% end
% 
% plt.YLim = [0 maxY+0.05];
% r = get(gca, 'children');
% set(gca, 'children', [r(end); r(1:end-1)])
% legend({summary(:).sessionTag})

%% Plot Subplotted histograms
maxX = 0;
figure('units','normalized','outerposition',[0 0 1 1])
row = length(in);
for i = 1:row
    scrollsubplot(q, 1, i);
    tmp = in(i).trials; %
    holdThresh  = [tmp(:).timeHoldThresh];
    h = histogram(holdThresh, 30);
    h.LineWidth = 2;
    h.FaceAlpha = 0.4;
    h.Normalization = 'probability';
    currentXLim = xlim;
    currentYLim = ylim;
    hold on
    plot([summary(i).bottomHoldThresh summary(i).bottomHoldThresh], [0 1], 'color', 'r', 'lineWidth', 2)
    plot([summary(i).meanTimeHoldThresh summary(i).meanTimeHoldThresh], [0 1], 'color', 'b', 'lineWidth', 2)
    
    ylim([currentYLim]);
    if currentXLim(2) > maxX
        maxX = currentXLim(2);
    end
    %     xlim([0 currentXLim(2)])
    xlabel('Hold Time Threshold (ms)') % mark xlabel with appropriate units
    ylabel('Probability') % histogram is in probability distribution
end
for i = 1:row
    scrollsubplot(q,1,i)
    xlim([0 maxX])
    text(0.9, 0.9, summary(i).sessionTag, 'Units', 'normalized')
end

%% Plot Subplotted trial organized hold time thresh
maxX = 0;
figure('units','normalized','outerposition',[0 0 1 1])
row = length(in);
for i = 1:row
    scrollsubplot(q, 1, i);
    tmp = in(i).trials; %
    plot([tmp(:).timeHoldThresh], 'lineWidth', 2)
    hold on
    plot([tmp(:).timeHoldMax], 'lineWidth', 2)
    %plot([tmp(:).medianTrialTouchTimes], 'lineWidth', 2)
%     if currentXLim(2) > maxX
%         maxX = currentXLim(2);
%     end
    ylim([min([tmp(:).timeHoldThresh]) inf])
    ylabel('Hold Time (ms)') % mark xlabel with appropriate units
    xlabel('Trial #') % histogram is in probability distribution
    text(0.9, 0.9,[ summary(i).sessionTag ], 'Units', 'normalized')
    legend({'Hold Time Threshold', 'Trial Hold Time'}, 'location', 'Northwest', 'box', 'off');
end