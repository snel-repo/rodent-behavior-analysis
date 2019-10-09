function plotKnobHold(in, summary)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Tony Corsten, tony.corsten93@gmail.com
% Date: 9/11/2018
% Purpose: produce multi-session histograms and summary plots for the knob holding task
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
% for i = 1:row
%     scrollsubplot(q,1,i)
%     xlim([0 maxX])
%         text(0.9, 0.9, summary(i).sessionTag, 'Units', 'normalized')
% end

%%
% plt = Plot(NaN, NaN); % initialize a Plot library plot with non values
% hold on
% plt.BoxDim = [17 8]; % figure box size in inches
% plt.XMinorTick = 'off'; % turn off minor ticks on x axis because histogram
% xlabel('Hold Time Threshold (ms)') % mark xlabel with appropriate units
% ylabel('Probability') % histogram is in probability distribution
% 
% for i = 1:length(in)
%     tmp = in(i).trials; %
%     holdTime  = [tmp(:).timeHoldMax];
%     h = histogram(holdTime, 30);
%     h.LineWidth = 2;
%     h.FaceAlpha = 0.4;
%     h.Normalization = 'probability';
%     currentXLim = xlim;
%     currentYLim = ylim;
%     
%     plt.XLim = [currentXLim(1)-10, currentXLim(2)+10];
%     plt.YLim = [currentYLim(1), currentYLim(2)+0.1];
% end

% plt = Plot(NaN, NaN, NaN, NaN); % initialize a Plot library plot with non values
% plt.BoxDim = [17 8]; % figure box size in inches
% hold on
% yyaxis left
% plot(1:length(summary), [summary(:).hitRate], 'lineWidth', 2, 'marker', 'o')
% ylabel('Hit Rate')
% yyaxis right
% plot(1:length(summary), [summary(:).bottomHoldThresh], 'lineWidth', 2, 'marker', 'o')
% ylabel('Minimum Hold Threshold Time (ms)')
% xlabel('Session #')

%% Summary plot of median time hold threshold 
plt = Plot(NaN, NaN, NaN, NaN); % initialize a Plot library plot with non values
plt.BoxDim = [17 8]; % figure box size in inches
hold on
yyaxis left
plot(1:length(summary), [summary(:).hitRate], 'lineWidth', 2, 'marker', 'o')
ylabel('Hit Rate')
yyaxis right
plot(1:length(summary), [summary(:).medianTimeHoldThresh], 'lineWidth', 2, 'marker', 'o')
ylabel('Median Hold Threshold Time (ms)')
xlabel('Session #')

%% Summary plot of median time hold max 
plt = Plot(NaN, NaN, NaN, NaN); % initialize a Plot library plot with non values
plt.BoxDim = [17 8]; % figure box size in inches
hold on
yyaxis left
plot(1:length(summary), [summary(:).hitRate], 'lineWidth', 2, 'marker', 'o')
ylabel('Hit Rate')
yyaxis right
plot(1:length(summary), [summary(:).medianTimeHoldMax], 'lineWidth', 2, 'marker', 'o')
ylabel('Median Hold Time Max (ms)')
xlabel('Session #')

%% Summary plot of median time hold max 
plt = Plot(NaN, NaN, NaN, NaN, NaN, NaN); % initialize a Plot library plot with non values
plt.Colors = {[0.5 0.5 0.5], [0 0 0], [0.93 0 0]};
plt.LineWidth = [2 2 2];
plt.LineStyle = {'--', '-', '-'};
plt.BoxDim = [17 8]; % figure box size in inches
hold on
plot(1:length(summary), [summary(:).medianTimeHoldThresh], 'lineWidth', 2, 'marker', 'o', 'color', [0.5 0.5 0.5], 'lineStyle', '--')
plot(1:length(summary), [summary(:).medianTimeHoldMax], 'lineWidth', 2, 'marker', 'o', 'color', [0 0 0])
%plot(1:length(summary), [summary(:).bottomHoldThresh], 'lineWidth', 2, 'marker', 'o', 'color', [0.93 0 0 0.3])
ylabel('Hold Time (ms)')
xlabel('Session #')
%lege = legend({'Median of Hold Time Threshold', 'Median of Maximum Hold Time', 'Minimum Hold Time Threshold'});
lege = legend({'Median of Hold Time Threshold', 'Median of Maximum Hold Time'});
lege.Position = [0.13 0.8 0.2 0.07];
lege.Box = 'off';

% plt = Plot(NaN, NaN, NaN, NaN); % initialize a Plot library plot with non values
% plt.BoxDim = [17 8]; % figure box size in inches
% hold on
% yyaxis left
% plot(1:length(summary), [summary(:).meanTimeHoldThresh], 'lineWidth', 2, 'marker', 'o')
% currYLim = ylim;
% ylabel('Mean Hold Threshold Time (ms)')
% yyaxis right
% plot(1:length(summary), [summary(:).bottomHoldThresh], 'lineWidth', 2, 'marker', 'o')
% currYLim2 = ylim;
% ylim([min(currYLim(1), currYLim2(1)) max(currYLim(2), currYLim2(2))]);
% ylabel('Minimum Hold Threshold Time (ms)')
% xlabel('Session #')
% yyaxis left
% ylim([min(currYLim(1), currYLim2(1)) max(currYLim(2), currYLim2(2))]);

% plt = Plot(NaN, NaN, NaN, NaN); % initialize a Plot library plot with non values
% plt.BoxDim = [17 8]; % figure box size in inches
% plt.YGrid = 'on';
% plt.YMinorGrid = 'on';
% hold on
% yyaxis left
% plot(1:length(summary), [summary(:).meanTimeHoldThresh], 'lineWidth', 2, 'marker', 'o')
% currYLim = ylim;
% ylabel('Mean Hold Threshold Time (ms)')
% yyaxis right
% plot(1:length(summary), [summary(:).meanTimeHoldMax], 'lineWidth', 2, 'marker', 'o')
% currYLim2 = ylim;
% ylim([min(currYLim(1), currYLim2(1)) max(currYLim(2), currYLim2(2))]);
% ylabel('Mean Hold Time (ms)')
% xlabel('Session #')
% yyaxis left
% ylim([min(currYLim(1), currYLim2(1)) max(currYLim(2), currYLim2(2))]);

%% violin plot of time hold threshold 
thresh = [];
cate = [];
for i = 1:length(in)
    tmp = in(i).trials;
     [tmpName{1:length(tmp)}] = deal(char(i+96));
    tmpData = [tmp(:).timeHoldThresh];
    thresh = [thresh tmpData];
    cate = [cate tmpName];
    tmpName = [];
end
figure('units','normalized','outerposition',[0 0 1 1])
q = violinplot(thresh, cate, 'boxcolor', [0 0 0], 'width', 0.4, 'violincolor', [0 0.5 1]);
xlabel('Session #')
ylabel('Hold time threshold (ms)')
set(gca, 'FontSize', 24)
set(gca, 'YMinorTick', 'on')
set(gca, 'XTickLabel', num2str((1:length(in))'));
set(gca, 'TickLength', [0.025 0.4])
set(gcf, 'units', 'inches',  'Position', [0 0 12 12]);
set(gcf,'color','w');
box on
set(gca, 'LineWidth', 1.5)
xlim([0 length(in)+1])
%% violin plot of time hold max 
timehold = [];
cate = [];
for i = 1:length(in)
    tmp = in(i).trials;
    [tmpName{1:length(tmp)}] = deal(char(i+96));
    tmpData = [tmp(:).timeHoldMax];
    timehold = [timehold tmpData];
    cate = [cate tmpName];
    tmpName = [];
end
figure('units','normalized','outerposition',[0 0 1 1])
q2 = violinplot(timehold, cate, 'boxcolor', [0 0 0], 'violincolor', [0 0.5 1], 'width', 0.4);
xlabel('Session #')
ylabel('Maximum hold time (ms)')
set(gca, 'FontSize', 20)
set(gca, 'YMinorTick', 'on')
set(gca, 'XTickLabel', num2str((1:length(in))'));
set(gca, 'TickLength', [0.025 0.4])
set(gcf, 'units', 'inches',  'Position', [0 0 12 12]);
box on
set(gca, 'LineWidth', 1.5)
set(gcf,'color','w');
ylim([6 1300])
xlim([0 length(in)+1])
s = 1;
% figure('units','normalized','outerposition',[0 0 1 1])
% row = length(in);
% for i = 6:row
%     tmp = in(i).trials;
%     for j = 1:length(tmp)
%         scrollsubplot(4, 4, j)
%         holdIdx = find(tmp(j).state ==3 & tmp(j).touchStatus);
%         if tmp(j).hitTrial
%             extraHold = find(tmp(j).state == 5 & [0; diff(tmp(j).touchStatus) == -1],1);
%             holdIdx = [holdIdx(1) : extraHold];
%         end
%         if tmp(j).hitTrial
%             plot(tmp(j).baseline(holdIdx(1) - 200 : holdIdx(end) + 200), 'lineWidth', 2, 'color', 'b')
%         else
%             plot(tmp(j).baseline(holdIdx(1) - 200 : holdIdx(end) + 200), 'lineWidth', 2, 'color', 'r')
%         end
%         hold on
%         plot(tmp(j).filt(holdIdx(1) - 200 : holdIdx(end) + 200), 'lineWidth', 2)
%         if currentXLim(2) > maxX
%             maxX = currentXLim(2);
%         end
%     end
%     ylabel('Touch Sensor Value(ms)') % mark xlabel with appropriate units
%     xlabel('Time (ms)') % histogram is in probability distribution
%     
% end