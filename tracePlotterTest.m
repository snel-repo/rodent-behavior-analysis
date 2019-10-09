function [attemptTrial] = tracePlotterTest(trials, attempts, session, dataPrior)
close all
sampleTime = trials(attempts(1).trialNum).sampleTime / 1e-3;
plotType = 2; % 1 = fast turns plotting, 2 = pert vs unpert; changes plot colors
dataPrior = 50; % how many indices prior to plot
h = figure; % initialize h, the figure where successful turns and current are plotted
%g = figure; % initialize g, the figure where failed turns and current are plotted
figure(h)
for i = 1:length(attempts)
    if attempts(i).hit
        subplot(3,2,1)
        if trials(attempts(i).trialNum).protocolVersion >= 4
            if trials(attempts(i).trialNum).pertEnableTrial % if the trial is perturbed
                h5 = plot((0: sampleTime : sampleTime *(attempts(i).endIdx - attempts(i).startIdx + dataPrior)) - dataPrior * sampleTime, trials(attempts(i).trialNum).pos(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'g', 'lineWidth', 1.5); % plot position trace for turn
                h5.Color(4) = 0.1;
            else % if the trial is unperturbed
                h6 = plot((0:sampleTime:sampleTime*(attempts(i).endIdx - attempts(i).startIdx + dataPrior)) - dataPrior * sampleTime, trials(attempts(i).trialNum).pos(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'b', 'lineWidth', 1.5); % plot position trace for turn
                h6.Color(4) = 0.1;
            end
        else % protocols before v4 treated stiffness as a pseudo perturbation and are plotted as unperturbed
            h6 = plot((0:sampleTime:sampleTime*(attempts(i).endIdx - attempts(i).startIdx + dataPrior)) - dataPrior * sampleTime, trials(attempts(i).trialNum).pos(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'b', 'lineWidth', 1.5); % plot position trace for turn
            h6.Color(4) = 0.1;
        end
        %---PLOT INDIVIDUAL TURN ATTEMPTS---%
        
        figure(h)
        %---PLOT POSITION FOR HIT ATTEMPT----%
        subplot(3,2,1)
        if trials(attempts(i).trialNum).protocolVersion >= 4
            if trials(attempts(i).trialNum).pertEnableTrial % if the trial is perturbed
                h5 = plot((0: sampleTime : sampleTime *(attempts(i).endIdx - attempts(i).startIdx + dataPrior)) - dataPrior * sampleTime, trials(attempts(i).trialNum).pos(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'g', 'lineWidth', 1.5); % plot position trace for turn
                h5.Color(4) = 0.1;
            else % if the trial is unperturbed
                h6 = plot((0:sampleTime:sampleTime*(attempts(i).endIdx - attempts(i).startIdx + dataPrior)) - dataPrior * sampleTime, trials(attempts(i).trialNum).pos(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'b', 'lineWidth', 1.5); % plot position trace for turn
                h6.Color(4) = 0.1;
            end
        else % protocols before v4 treated stiffness as a pseudo perturbation and are plotted as unperturbed
            h6 = plot((0:sampleTime:sampleTime*(attempts(i).endIdx - attempts(i).startIdx + dataPrior)) - dataPrior * sampleTime, trials(attempts(i).trialNum).pos(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'b', 'lineWidth', 1.5); % plot position trace for turn
            h6.Color(4) = 0.1;
        end
        hold on
        
        if trials(attempts(i).trialNum).protocolVersion >= 4
            if trials(attempts(i).trialNum).pertEnableTrial
                scatter(sampleTime * (attempts(i).hitIdx - attempts(i).startIdx), trials(attempts(i).trialNum).pos(attempts(i).hitIdx), 'g', 'filled')
            else
                scatter(sampleTime * (attempts(i).hitIdx - attempts(i).startIdx), trials(attempts(i).trialNum).pos(attempts(i).hitIdx), 'b', 'filled')
            end
        else % protocols before v4 treated stiffness as a pseudo perturbation and are plotted as unperturbed
            scatter(sampleTime * (attempts(i).hitIdx - attempts(i).startIdx), trials(attempts(i).trialNum).pos(attempts(i).hitIdx), 'b', 'filled')
        end
        %---PLOT VELOCITY FOR HIT ATTEMPT----%
        subplot(3,2,3)
        if trials(attempts(i).trialNum).protocolVersion >= 4
            if trials(attempts(i).trialNum).pertEnableTrial
                h3 = plot((0:sampleTime:sampleTime*(attempts(i).endIdx - attempts(i).startIdx + dataPrior)) - dataPrior * sampleTime, trials(attempts(i).trialNum).vel(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'g', 'lineWidth', 1.5);
                h3.Color(4) = 0.1;
            else
                h4 = plot((0:sampleTime:sampleTime*(attempts(i).endIdx - attempts(i).startIdx + dataPrior)) - dataPrior * sampleTime, trials(attempts(i).trialNum).vel(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'b', 'lineWidth', 1.5);
                h4.Color(4) = 0.1;
            end
        else % protocols before v4 treated stiffness as a pseudo perturbation and are plotted as unperturbed
            h4 = plot((0:sampleTime:sampleTime*(attempts(i).endIdx - attempts(i).startIdx + dataPrior)) - dataPrior * sampleTime, trials(attempts(i).trialNum).vel(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'b', 'lineWidth', 1.5);
            h4.Color(4) = 0.1;
        end
        hold on
        
        if trials(attempts(i).trialNum).protocolVersion >= 4
            if trials(attempts(i).trialNum).pertEnableTrial
                scatter(sampleTime * (attempts(i).hitIdx - attempts(i).startIdx), 0, 'g', 'filled')
            else
                scatter(sampleTime * (attempts(i).hitIdx - attempts(i).startIdx), 0, 'b', 'filled')
            end
        else % protocols before v4 treated stiffness as a pseudo perturbation and are plotted as unperturbed
            scatter(sampleTime * (attempts(i).hitIdx - attempts(i).startIdx), 0, 'b', 'filled')
        end
        %---PLOT CURRENTFOR HIT ATTEMPT----%
        subplot(3,2,5)
        if isfield(trials(attempts(i).trialNum), 'actualCurrent')
            h1 = plot((0:sampleTime:sampleTime*(attempts(i).endIdx - attempts(i).startIdx + dataPrior)) - dataPrior * sampleTime, trials(attempts(i).trialNum).actualCurrent(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'k', 'lineWidth', 1.5);
            h1.Color(4) = 0.1;
        end
        hold on
        h2 = plot((0:sampleTime:sampleTime*(attempts(i).endIdx - attempts(i).startIdx + dataPrior)) - dataPrior * sampleTime, trials(attempts(i).trialNum).motorCurrent(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'r', 'lineWidth', 1.5);
        h2.Color(4) = 0.1;
    else
        %---PLOT POSITION FOR MISSED ATTEMPT---%
        subplot(3,2,2)
        if trials(attempts(i).trialNum).protocolVersion >= 4
            if trials(attempts(i).trialNum).pertEnableTrial
                g1 = plot((0:sampleTime:sampleTime*(attempts(i).endIdx - attempts(i).startIdx + dataPrior)) - dataPrior * sampleTime, trials(attempts(i).trialNum).pos(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'r', 'lineWidth', 1.5);
                g1.Color(4) = 0.1;
            else
                g2 = plot((0:sampleTime:sampleTime*(attempts(i).endIdx - attempts(i).startIdx + dataPrior)) - dataPrior * sampleTime, trials(attempts(i).trialNum).pos(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'c', 'lineWidth', 1.5);
                g2.Color(4) = 0.1;
            end
        else % protocols before v4 treated stiffness as a pseudo perturbation and are plotted as unperturbed
            g2 = plot((0:sampleTime:sampleTime*(attempts(i).endIdx - attempts(i).startIdx + dataPrior)) - dataPrior * sampleTime, trials(attempts(i).trialNum).pos(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'c', 'lineWidth', 1.5);
            g2.Color(4) = 0.1;
        end
        hold on
        if trials(attempts(i).trialNum).protocolVersion >= 4
            if trials(attempts(i).trialNum).pertEnableTrial
                scatter(sampleTime * (attempts(i).endIdx - attempts(i).startIdx), trials(attempts(i).trialNum).pos(attempts(i).endIdx), 'r', 'filled')
            else
                scatter(sampleTime * (attempts(i).endIdx - attempts(i).startIdx), trials(attempts(i).trialNum).pos(attempts(i).endIdx), 'c', 'filled')
            end
        else % protocols before v4 treated stiffness as a pseudo perturbation and are plotted as unperturbed
            scatter(sampleTime * (attempts(i).endIdx - attempts(i).startIdx), trials(attempts(i).trialNum).pos(attempts(i).endIdx), 'c', 'filled')
        end
        %---PLOT VELOCITY FOR MISSED ATTEMPT---%
        subplot(3,2,4)
        if trials(attempts(i).trialNum).protocolVersion >= 4
            if trials(attempts(i).trialNum).pertEnableTrial
                g3 = plot((0:sampleTime:sampleTime*(attempts(i).endIdx - attempts(i).startIdx + dataPrior)) - dataPrior * sampleTime, trials(attempts(i).trialNum).vel(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'r', 'lineWidth', 1.5);
                g3.Color(4) = 0.1;
            else
                g4 = plot((0:sampleTime:sampleTime*(attempts(i).endIdx - attempts(i).startIdx + dataPrior)) - dataPrior * sampleTime, trials(attempts(i).trialNum).vel(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'c', 'lineWidth', 1.5);
                g4.Color(4) = 0.1;
            end
        else % protocols before v4 treated stiffness as a pseudo perturbation and are plotted as unperturbed
            g4 = plot((0:sampleTime:sampleTime*(attempts(i).endIdx - attempts(i).startIdx + dataPrior)) - dataPrior * sampleTime, trials(attempts(i).trialNum).vel(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'c', 'lineWidth', 1.5);
            g4.Color(4) = 0.1;
        end
        hold on
        if trials(attempts(i).trialNum).protocolVersion >= 4
            if trials(attempts(i).trialNum).pertEnableTrial
                scatter(sampleTime * (attempts(i).endIdx - attempts(i).startIdx), 0, 'r', 'filled')
            else
                scatter(sampleTime * (attempts(i).endIdx - attempts(i).startIdx), 0, 'c', 'filled')
            end
        else % protocols before v4 treated stiffness as a pseudo perturbation and are plotted as unperturbed
            scatter(sampleTime * (attempts(i).endIdx - attempts(i).startIdx), 0, 'c', 'filled')
        end
        %---PLOT CURRENT FOR MISSED ATTEMPT---%
        subplot(3,2,6)
        if isfield(trials, 'actualCurrent')
            g5 = plot((0:sampleTime:sampleTime*(attempts(i).endIdx - attempts(i).startIdx + dataPrior)) - dataPrior * sampleTime, trials(attempts(i).trialNum).actualCurrent(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'k', 'lineWidth', 1.5);
            g5.Color(4) = 0.1;
        end
        hold on
        g6 = plot((0:sampleTime:sampleTime*(attempts(i).endIdx - attempts(i).startIdx + dataPrior)) - dataPrior * sampleTime, trials(attempts(i).trialNum).motorCurrent(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'r', 'lineWidth', 1.5);
        g6.Color(4) = 0.1;
    end
end

%---POST PLOTTING ANALYSIS---%
figure(h)
subplot(3,2,1)
h5 = plot(0,0, 'g');
h6 = plot(0,0, 'b');
subplot(3,2,3)
h3 = plot(0,0, 'g');
h4 = plot(0,0, 'b');
subplot(3,2,5)
h2 = plot(0,0, 'r');
h1 = plot(0,0, 'k');
subplot(3,2,2)
g1 = plot(0,0, 'r');
g2 = plot(0,0, 'c');
subplot(3,2,4)
g3 = plot(0,0, 'r');
g4 = plot(0,0, 'c');
subplot(3,2,6)
g5 = plot(0,0, 'k');
g6 = plot(0,0, 'r');
figure(h)
subplot(3,2,1) % SUCCESSFUL ATTEMPTS (POS)
axis([-inf inf -inf inf])
title([trials(1).subject ' virtual stiffness position trajectories'])
xlabel('Time (ms)')
ylabel('Position (deg)')
plot([-100 400], [trials(attempts(i).trialNum).maxWindow trials(attempts(i).trialNum).maxWindow], 'k--', 'lineWidth', 2)
plot([0 0], [-20 100], 'k--', 'lineWidth', 2)
hold on
plot([-100 400], [trials(attempts(i).trialNum).minWindow trials(attempts(i).trialNum).minWindow], 'k--', 'lineWidth', 2)

if plotType == 1
    legend([h5 h6], {'<120ms success', '>120ms success'})
elseif plotType == 2% FAILED ATTEMPTS (POS)
    legend([h5 h6], {'Perturbed Hit', 'Unperturbed Hit'})
end

subplot(3,2,3) % SUCCESSFUL ATTEMPTS (VEL)
title([trials(1).subject ' virtual stiffness velocity trajectories'])
xlabel('Time (ms)')
ylabel('Velocity (deg/s)')
plot([-100 400], [75 75], 'k--','lineWidth', 2)
hold on
scatter(session.meanHitAttemptTime, -250, 'k', 'filled')
plot([session.meanHitAttemptTime - session.stdHitAttemptTime, session.meanHitAttemptTime  + session.stdHitAttemptTime], [-250 -250], 'k', 'lineWidth', 1.5)
plot([0 0], [min([attempts(:).minVel]) max([attempts(:).maxVel])], 'k--', 'lineWidth', 2)
xlim([-100 400])
ylim([-inf inf])
%ylim([-300 max(maxVelStore) + 100])
if plotType == 1
    legend([h3 h4], {'<120ms success', '>120ms success'})
elseif plotType == 2
    legend([h3 h4], {'Perturbed Hit', 'Unperturbed Hit'})
end

subplot(3,2,5) % SUCCESSFUL ATTEMPTS (CURRENT)
title([trials(1).subject ' virtual stiffness motor current'])
xlabel('Time (ms)')
xlim([-100 400])
ylim([0 55])
plot([0 0], [0 55], 'k--', 'lineWidth', 2)
xlim([-100 400])
if isfield(trials, 'actualCurrent')
    legend([h1 h2], {'Actual', 'Desired'})
else
    legend([h2], 'Desired')
end
ylabel('Current to motor (mA)')

%figure(g)
subplot(3,2,2) % FAILED ATTEMPTS (POS)
axis([-inf inf -inf inf])
title([trials(1).subject ' virtual stiffness position trajectories FAILED'])
xlabel('Time (ms)')
ylabel('Position (deg)')
plot([-100 400], [trials(attempts(i).trialNum).maxWindow trials(attempts(i).trialNum).maxWindow], 'k--', 'lineWidth', 2)
plot([0 0], [min([attempts(:).maxPos]) max([attempts(:).maxPos])], 'k--', 'lineWidth', 2)
hold on
plot([-100 400], [trials(attempts(i).trialNum).minWindow trials(attempts(i).trialNum).minWindow], 'k--', 'lineWidth', 2)
scatter(-15, session.meanLow, 'k', 'filled')
plot( [-15 -15],[session.meanLow - session.stdLow, session.meanLow + session.stdLow], 'k', 'lineWidth', 1.5)
scatter(-15, session.meanHigh, 'k', 'filled')
plot([-15 -15],[session.meanHigh - session.stdHigh, session.meanHigh + session.stdHigh],  'k', 'lineWidth', 1.5)
text(0, 0.95, ['Frac. above window: ' num2str(round(session.rateMissAbove ,2))], 'units', 'normalized')
text(0, 0.89, ['Frac. below window: ' num2str(round(session.rateMissBelow ,2))], 'units', 'normalized')

%ylim([0 trials(attempts(i).trialNum).maxWindow])
if plotType == 1
    legend([g1 g2], {'<120ms success', '>120ms success'})
elseif plotType == 2
    legend([g1 g2], {'Perturbed Miss', 'Unperturbed Miss'})
end

subplot(3,2,4) % FAILED ATTEMPTS (VEL)
title([trials(1).subject ' virtual stiffness velocity trajectories FAILED'])
xlabel('Time (ms)')
ylabel('Velocity (deg/s)')
plot([-100 400], [75 75], 'k--','lineWidth', 2)
plot([0 0], [min([attempts(:).minVel]) max([attempts(:).maxVel])], 'k--', 'lineWidth', 2)
xlim([-100 400])
missTrialIdx = find(~[attempts(:).hit]);
ylim([-inf max([attempts(missTrialIdx).maxVel]) + 100])
if plotType == 1
    legend([g3 g4], {'<120ms success', '>120ms success'})
elseif plotType == 2
    legend([g3 g4], {'Perturbed Miss', 'Unperturbed Miss'})
end

subplot(3,2,6) % FAILED ATTEMPTS (CURRENT)
title([trials(1).subject ' virtual stiffness motor current FAILED'])
xlabel('Time (ms)')
xlim([-100 400])
ylim([0 55])
plot([0 0], [0 55], 'k--', 'lineWidth', 2)
xlim([-100 400])
if isfield(trials, 'actualCurrent')
    legend([g5 g6], {'Actual', 'Desired'})
else
    legend([g6], 'Desired')
end
ylabel('Current to motor (mA)')

