function plotMissTrajectories(extractData, time_of_interest)
for i = 1 : length(extractData.posMiss) % plot all hit trials
    subplot(3,1,1)
    xlim([0 time_of_interest])
    ylim([-inf inf])
    q = plot([0:extractData.sampleTime:(extractData.sampleTime*length(extractData.posMiss{i})-extractData.sampleTime)],extractData.posMiss{i}, 'r');
    q.Color(4) = 0.3;
    hold on
    set(gca, 'FontSize', 20)
    subplot(3,1,2)
    xlim([0 time_of_interest])
    ylim([-inf inf])
    q = plot([0:extractData.sampleTime:(extractData.sampleTime*length(extractData.posMiss{i})-extractData.sampleTime)],extractData.velMiss{i}, 'r');
    q.Color(4) = 0.3;
    hold on
    set(gca, 'FontSize', 20)
    subplot(3,1,3)
    xlim([0 time_of_interest])
    ylim([-inf inf])
    q = plot([0:extractData.sampleTime:(extractData.sampleTime*length(extractData.posMiss{i})-2*extractData.sampleTime)],diff(extractData.velMiss{i}) / (extractData.sampleTime * 1e-3), 'r');
    q.Color(4) = 0.3;
    hold on
    set(gca, 'FontSize', 20)
end
