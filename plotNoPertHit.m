function plotNoPertHit(extractData, time_of_interest)
for i = 1 : length(extractData.posHitNoPert) % plot all hit trials
    subplot(2,2,1)
    q = plot([0:extractData.sampleTime:(extractData.sampleTime*length(extractData.posHitNoPert{i})-extractData.sampleTime)], extractData.posHitNoPert{i}, 'b');
    q.Color(4) = 0.2;
    xlim([0 time_of_interest])
    xlabel('Time (ms)')
    ylabel('Angle (deg)')
    hold on
    
    subplot(2,2,2)
    q = plot([0:extractData.sampleTime:(extractData.sampleTime*length(extractData.velHitNoPert{i})-extractData.sampleTime)], extractData.velHitNoPert{i}, 'b');
    q.Color(4) = 0.2;
    xlabel('Time (ms)')
    ylabel('Velocity (deg / s)')
    xlim([0 time_of_interest])
    hold on
    subplot(2,2,3)
    if length(extractData.velHitNoPert{i}) > 1
        q = plot([0:extractData.sampleTime:(extractData.sampleTime*length(extractData.velHitNoPert{i})-2*extractData.sampleTime)],diff(extractData.velHitNoPert{i}) / (extractData.sampleTime * 1e-3), 'b');
        q.Color(4) = 0.2;
        xlabel('Time (ms)')
        ylabel('Acceleration (deg / s^2)')
        xlim([0 time_of_interest])
        hold on
    end
    
end