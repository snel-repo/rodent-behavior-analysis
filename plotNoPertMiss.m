function plotNoPertMiss(extractData, time_of_interest)
for i = 1 : length(extractData.posMissNoPert) % plot all hit trials
    subplot(2,2,1)
    q = plot([0:extractData.sampleTime:(extractData.sampleTime*length(extractData.posMissNoPert{i})-extractData.sampleTime)], extractData.posMissNoPert{i}, 'r');
    q.Color(4) = 0.3;
    xlim([0 time_of_interest])
    hold on
    subplot(2,2,2)
    q = plot([0:extractData.sampleTime:(extractData.sampleTime*length(extractData.velMissNoPert{i})-extractData.sampleTime)], extractData.velMissNoPert{i}, 'r');
    q.Color(4) = 0.3;
    xlim([0 time_of_interest])
    hold on
    subplot(2,2,3)
    if length(extractData.velMissNoPert{i}) > 1
    q = plot([0:extractData.sampleTime:(extractData.sampleTime*length(extractData.velMissNoPert{i})-2*extractData.sampleTime)],diff(extractData.velMissNoPert{i}) / (extractData.sampleTime * 1e-3), 'r');
    q.Color(4) = 0.3;
    xlim([0 time_of_interest])
    hold on
    end
end