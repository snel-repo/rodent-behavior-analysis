% raw data plotter
opacityPlot = 0.25;
subplotVal = 1;
close all
figure('units','normalized','outerposition',[0 0 1 1])
rectangleFactor = trials(1).sampleTime / 1e-3;
mode = 1; % 1 for all, 2 for individual
for i = 2:length(trials)
    timeTotalAdjusted = trials(i).touchBus_time - trials(i).touchBus_time(1);

    a = double(trials(i).touchRaw);
    velPos = abs(trials(i).velRaw) ~= 0;
    diffVelPos = [0 diff(velPos)'];
    velAreas = calcActiveRegions(diffVelPos, 3, 2);
    if (mode == 1 && subplotVal == 5 || i == length(trials))
        filename =  ['rawTouchPlotsWide_' sessionData.subject '_' regexprep(sessionData.date, '/', '')];
        eval(['export_fig '  filename ' -pdf -append'])
        close all
        figure('units','normalized','outerposition',[0 0 1 1])
        subplotVal = 1;
    elseif mode == 2
        close all
        figure('units','normalized','outerposition',[0 0 1 1])
    end
    if mode == 1
        subplot(2,2,subplotVal)
    end
    plot(timeTotalAdjusted, a, 'lineStyle', '-', 'lineWidth', 1.2)
    hold on
    currYlim = ylim;
    for j = 1:length(velAreas(:,1))
        velAreaPlot = rectangle('position', [(velAreas(j, 1)*rectangleFactor) currYlim(1) ((velAreas(j,2) - velAreas(j,1)) * rectangleFactor) (currYlim(2) - currYlim(1))], 'FaceColor', [1 0 0 opacityPlot], 'lineStyle', 'none');
    end
  %  xlim([(2*velAreas(1,1) - 300), (2*velAreas(1,2) + 300)])
    ylim(currYlim)
    title(['Raw touch data, trial #', num2str(i)])
    xlabel('Time (ms)')
    ylabel('Touch Sensor Data')
    velLine = line(NaN,NaN,'LineWidth',2,'LineStyle','-','Color',[1 0 0 opacityPlot]);
    legend({'Touch Sensor Raw', 'Non-zero Velocity'}, 'location', 'best')
    set(gca, 'FontSize', 18)
    if mode == 2
        filename = [' ''individualTouchPlots/rawTouchTrial'  num2str(i) ''' '];
        eval(['export_fig' filename '-png'])
    end
    subplotVal = subplotVal + 1;
end