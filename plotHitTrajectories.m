function plotHitTrajectories(extractData, time_of_interest)
for i = 1 : length(extractData.posHit) % plot all hit trials
    subplot(3,1,1)
    q = plot([0:extractData.sampleTime:(extractData.sampleTime*length(extractData.posHit{i})-extractData.sampleTime)], extractData.posHit{i}, 'b');
    q.Color(4) = 0.3;
    plotTitle = sprintf('%s knob angle trajectories, %s, %s', extractData.subject, extractData.date, extractData.session);
    title(plotTitle)
    xlabel('Time (ms)')
    ylabel('Angle (deg)')
    hold on
    set(gca, 'FontSize', 20)
    xlim([0 time_of_interest])
    ylim([-inf inf])
    subplot(3,1,2)
    q = plot([0:extractData.sampleTime:(extractData.sampleTime*length(extractData.velHit{i})-extractData.sampleTime)],extractData.velHit{i}, 'b');
    q.Color(4) = 0.3;
    plotTitle = sprintf('%s knob velocity trajectories, %s, %s', extractData.subject, extractData.date, extractData.session);
    title(plotTitle)
    xlabel('Time (ms)')
    ylabel('Velocity (deg / s)')
    xlim([0 time_of_interest])
    ylim([-inf inf])
    hold on
    set(gca, 'FontSize', 20)
    subplot(3,1,3)
    q = plot([0:extractData.sampleTime:(extractData.sampleTime*length(extractData.posHit{i})-2*extractData.sampleTime)], diff(extractData.velHit{i}) / (extractData.sampleTime * 1e-3), 'b');
    q.Color(4) = 0.3;
    xlim([0 time_of_interest])
    ylim([-inf inf])
    plotTitle = sprintf('%s knob acceleration trajectories, %s, %s', extractData.subject, extractData.date, extractData.session);
    title(plotTitle)
    xlabel('Time (ms)')
    ylabel('Acceleration (deg / s^2)')
    hold on
    set(gca, 'FontSize', 20)
end