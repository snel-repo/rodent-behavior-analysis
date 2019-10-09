function plotPertHitSmooth(extractData, time_of_interest)
for i = 1 : length(extractData.posHitPert) % plot all hit trials
    subplot(2,2,1)
    q = plot([0:extractData.sampleTime:(extractData.sampleTime*length(extractData.posHitPert{i})-extractData.sampleTime)], extractData.posHitPert{i}, 'g');
    q.Color(4) = 0.4;
    xlim([0 time_of_interest])
    plotTitle = sprintf('%s knob angle trajectories, %s, %s, pert = %s%%', extractData.subject, extractData.date, extractData.session, extractData.pertMagnitude);
    title(plotTitle)
    xlabel('Time (ms)')
    ylabel('Angle (deg)')
    hold on
    
    subplot(2,2,2)
          smoothVel = cellfun(@smooth, extractData.velHitPert, 'UniformOutput', 0);
    q = plot([0:extractData.sampleTime:(extractData.sampleTime*length(extractData.velHitPert{i})-extractData.sampleTime)], smoothVel{i}, 'g');
    q.Color(4) = 0.4;
    xlim([0 time_of_interest])
    plotTitle = sprintf('%s knob velocity trajectories, %s, %s, pert = %s%%', extractData.subject, extractData.date, extractData.session, extractData.pertMagnitude);
    title(plotTitle)
    xlabel('Time (ms)')
    ylabel('Velocity (deg / s)')
    hold on
    subplot(2,2,3)
    if length(extractData.velHitPert{i}) > 1
        q = plot([0:extractData.sampleTime:(extractData.sampleTime*length(extractData.velHitPert{i})-2*extractData.sampleTime)],  diff(smoothVel{i}) / (extractData.sampleTime * 1e-3), 'g');
        q.Color(4) = 0.4;
        xlim([0 time_of_interest])
        plotTitle = sprintf('%s knob acceleration trajectories, %s, %s, pert = %s%%', extractData.subject, extractData.date, extractData.session, extractData.pertMagnitude);
        title(plotTitle)
        xlabel('Time (ms)')
        ylabel('Acceleration (deg / s^2)')
        hold on
    end
    subplot(2,2,4)
    
    plot([0:extractData.sampleTime:(extractData.sampleTime*length(extractData.pertCurrent{i})-extractData.sampleTime)],extractData.pertCurrent{i}, 'k')
    xlim([0 time_of_interest])
    hold on
    
    title('Perturbation current for successful perturbed trials')
    xlabel('Time (ms)')
    ylabel('% of max Amp * 10V (output)')
end