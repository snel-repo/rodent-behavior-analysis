function plotPertMiss(extractData, time_of_interest)
for i = 1 : length(extractData.posMissPert) % plot all hit trials
    subplot(2,2,1)
    q = plot([0:extractData.sampleTime:(extractData.sampleTime*length(extractData.posMissPert{i})-extractData.sampleTime)], extractData.posMissPert{i}, 'm');
    q.Color(4) = 0.3;
    xlim([0 time_of_interest])
    xlabel('Time (ms)')
    ylabel('Angle (deg)')
    hold on
    
    subplot(2,2,2)
    q = plot([0:extractData.sampleTime:(extractData.sampleTime*length(extractData.velMissPert{i})-extractData.sampleTime)], extractData.velMissPert{i}, 'm');
    q.Color(4) = 0.3;
    xlim([0 time_of_interest])
    xlabel('Time (ms)')
    ylabel('Velocity (deg / s)')
    hold on
    subplot(2,2,3)
    if length(extractData.velMissPert{i}) > 1
        q = plot([0:extractData.sampleTime:(extractData.sampleTime*length(extractData.velMissPert{i})-2*extractData.sampleTime)],diff(extractData.velMissPert{i}) / (extractData.sampleTime * 1e-3), 'm');
        q.Color(4) = 0.3;
        xlim([0 time_of_interest])
        xlabel('Time (ms)')
        ylabel('Acceleration (deg / s)')
        hold on
    end
    %     subplot(2,2,4)
    %     plot([0:extractData.sampleTime:(extractData.sampleTime*length(extractData.pertCurrent{i})-extractData.sampleTime)],extractData.pertCurrent{i}, 'm')
    %     hold on
    %     title('Perturbation current for perturbed trials')
    %     xlabel('Time (ms)')
    %     ylabel('% of max Amp * 10V (output)')
end