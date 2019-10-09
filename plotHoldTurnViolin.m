function plotHoldTurnViolin(in, summary)
%% violin plot of time hold max 
timehold = [];
cate = [];
for i = 1:length(in)
    tmp = in(i).trials;
    [tmpName{1:length(tmp)}] = deal(char(i+96));
    tmpData = [tmp(:).definedHoldTime];
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
set(gcf, 'units', 'inches',  'Position', [0 0 15 10]);
box on
set(gca, 'LineWidth', 1.5)
set(gcf,'color','w');
%ylim([6 1300])
xlim([0 length(in)+1])
s = 1;