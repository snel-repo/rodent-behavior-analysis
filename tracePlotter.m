function tracePlotter(trials, attempts, session, dataPrior)
close all
sampleTime = trials(attempts(1).trialNum).sampleTime / 1e-3;
plotType = 2; % 1 = fast turns plotting, 2 = pert vs unpert; changes plot colors
h = figure; % initialize h, the figure where successful turns and current are plotted
figure(h)
switch plotType
    case 1
        for i = 1:length(attempts)
            timeAxis = (0: sampleTime : sampleTime *(attempts(i).endIdx - attempts(i).startIdx + dataPrior)) - dataPrior * sampleTime;
            timeAxisScatter = sampleTime * (attempts(i).hitIdx - attempts(i).startIdx);
            if attempts(i).hit
                subplot(3,2,1)
                if trials(attempts(i).trialNum).protocolVersion >= 4
                    if trials(attempts(i).trialNum).pertEnableTrial % if the trial is perturbed
                        pertHitPosPlot = plot(timeAxis, trials(attempts(i).trialNum).pos(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'g', 'lineWidth', 1.5); % plot position trace for turn
                        pertHitPosPlot.Color(4) = 0.1;
                    else % if the trial is unperturbed
                        unpertHitPosPlot = plot(timeAxis, trials(attempts(i).trialNum).pos(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'b', 'lineWidth', 1.5); % plot position trace for turn
                        unpertHitPosPlot.Color(4) = 0.1;
                    end
                else % protocols before v4 treated stiffness as a pseudo perturbation and are plotted as unperturbed
                    unpertHitPosPlot = plot(timeAxis, trials(attempts(i).trialNum).pos(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'b', 'lineWidth', 1.5); % plot position trace for turn
                    unpertHitPosPlot.Color(4) = 0.1;
                end
                hold on
                if trials(attempts(i).trialNum).protocolVersion >= 4
                    if trials(attempts(i).trialNum).pertEnableTrial
                        scatter(timeAxisScatter, trials(attempts(i).trialNum).pos(attempts(i).hitIdx), 'g', 'filled')
                    else
                        scatter(timeAxisScatter, trials(attempts(i).trialNum).pos(attempts(i).hitIdx), 'b', 'filled')
                    end
                else % protocols before v4 treated stiffness as a pseudo perturbation and are plotted as unperturbed
                    scatter(timeAxisScatter, trials(attempts(i).trialNum).pos(attempts(i).hitIdx), 'b', 'filled')
                end
                %---PLOT VELOCITY FOR HIT ATTEMPT----%
                subplot(3,2,3)
                if trials(attempts(i).trialNum).protocolVersion >= 4
                    if trials(attempts(i).trialNum).pertEnableTrial
                        pertHitVelPlot = plot(timeAxis, trials(attempts(i).trialNum).vel(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'g', 'lineWidth', 1.5);
                        pertHitVelPlot.Color(4) = 0.1;
                    else
                        unpertHitVelPlot = plot(timeAxis, trials(attempts(i).trialNum).vel(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'b', 'lineWidth', 1.5);
                        unpertHitVelPlot.Color(4) = 0.1;
                    end
                else % protocols before v4 treated stiffness as a pseudo perturbation and are plotted as unperturbed
                    unpertHitVelPlot = plot(timeAxis, trials(attempts(i).trialNum).vel(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'b', 'lineWidth', 1.5);
                    unpertHitVelPlot.Color(4) = 0.1;
                end
                hold on
                
                if trials(attempts(i).trialNum).protocolVersion >= 4
                    if trials(attempts(i).trialNum).pertEnableTrial
                        scatter(timeAxisScatter, 0, 'g', 'filled')
                    else
                        scatter(timeAxisScatter, 0, 'b', 'filled')
                    end
                else % protocols before v4 treated stiffness as a pseudo perturbation and are plotted as unperturbed
                    scatter(sampleTime * (attempts(i).hitIdx - attempts(i).startIdx), 0, 'b', 'filled')
                end
                %---PLOT CURRENTFOR HIT ATTEMPT----%
                subplot(3,2,5)
                hapticWallCurrent = trials(attempts(i).trialNum).hapticWallCurrent(attempts(i).startIdx - dataPrior : attempts(i).endIdx);
                stiffnessCurrent = trials(attempts(i).trialNum).stiffnessCurrent(attempts(i).startIdx - dataPrior : attempts(i).endIdx);
                perturbationCurrent = trials(attempts(i).trialNum).perturbationCurrent(attempts(i).startIdx - dataPrior : attempts(i).endIdx);
                if isfield(trials(attempts(i).trialNum), 'actualCurrent')
                    h1 = plot(timeAxis, hapticWallCurrent + stiffnessCurrent + perturbationCurrent, 'k', 'lineWidth', 1.5);
                    h1.Color(4) = 0.1;
                end
                hold on
                h2 = plot(timeAxis, trials(attempts(i).trialNum).motorCurrent(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'r', 'lineWidth', 1.5);
                h2.Color(4) = 0.1;
            else
                %---PLOT POSITION FOR MISSED ATTEMPT---%
                subplot(3,2,2)
                if trials(attempts(i).trialNum).protocolVersion >= 4
                    if trials(attempts(i).trialNum).pertEnableTrial
                        pertMissPosPlot = plot(timeAxis, trials(attempts(i).trialNum).pos(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'r', 'lineWidth', 1.5);
                        pertMissPosPlot.Color(4) = 0.1;
                    else
                        unpertMissPosPlot = plot(timeAxis, trials(attempts(i).trialNum).pos(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'c', 'lineWidth', 1.5);
                        unpertMissPosPlot.Color(4) = 0.1;
                    end
                else % protocols before v4 treated stiffness as a pseudo perturbation and are plotted as unperturbed
                    unpertMissPosPlot = plot(timeAxis, trials(attempts(i).trialNum).pos(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'c', 'lineWidth', 1.5);
                    unpertMissPosPlot.Color(4) = 0.1;
                end
                hold on
                if trials(attempts(i).trialNum).protocolVersion >= 4
                    if trials(attempts(i).trialNum).pertEnableTrial
                        scatter(timeAxisScatter, trials(attempts(i).trialNum).pos(attempts(i).endIdx), 'r', 'filled')
                    else
                        scatter(timeAxisScatter, trials(attempts(i).trialNum).pos(attempts(i).endIdx), 'c', 'filled')
                    end
                else % protocols before v4 treated stiffness as a pseudo perturbation and are plotted as unperturbed
                    scatter(timeAxisScatter, trials(attempts(i).trialNum).pos(attempts(i).endIdx), 'c', 'filled')
                end
                %---PLOT VELOCITY FOR MISSED ATTEMPT---%
                subplot(3,2,4)
                if trials(attempts(i).trialNum).protocolVersion >= 4
                    if trials(attempts(i).trialNum).pertEnableTrial
                        pertMissVelPlot = plot(timeAxis, trials(attempts(i).trialNum).vel(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'r', 'lineWidth', 1.5);
                        pertMissVelPlot.Color(4) = 0.1;
                    else
                        unpertMissVelPlot = plot(timeAxis, trials(attempts(i).trialNum).vel(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'c', 'lineWidth', 1.5);
                        unpertMissVelPlot.Color(4) = 0.1;
                    end
                else % protocols before v4 treated stiffness as a pseudo perturbation and are plotted as unperturbed
                    unpertMissVelPlot = plot(timeAxis, trials(attempts(i).trialNum).vel(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'c', 'lineWidth', 1.5);
                    unpertMissVelPlot.Color(4) = 0.1;
                end
                hold on
                if trials(attempts(i).trialNum).protocolVersion >= 4
                    if trials(attempts(i).trialNum).pertEnableTrial
                        scatter(timeAxisScatter, 0, 'r', 'filled')
                    else
                        scatter(timeAxisScatter, 0, 'c', 'filled')
                    end
                else % protocols before v4 treated stiffness as a pseudo perturbation and are plotted as unperturbed
                    scatter(timeAxisScatter, 0, 'c', 'filled')
                end
                %---PLOT CURRENT FOR MISSED ATTEMPT---%
                subplot(3,2,6)
                if isfield(trials, 'actualCurrent')
                    g5 = plot(timeAxis, trials(attempts(i).trialNum).actualCurrent(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'k', 'lineWidth', 1.5);
                    g5.Color(4) = 0.1;
                end
                hold on
                g6 = plot(timeAxis, trials(attempts(i).trialNum).motorCurrent(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'r', 'lineWidth', 1.5);
                g6.Color(4) = 0.1;
            end
        end
    case 2
        %-----PLOT PERTURBATIONS SAME PLOT------%
        for i = 1:length(attempts)
            timeAxis = (0: sampleTime : sampleTime *(attempts(i).endIdx - attempts(i).startIdx + dataPrior)) - dataPrior * sampleTime;
            timeAxisScatter = sampleTime * (attempts(i).endIdx - attempts(i).startIdx);
            if attempts(i).hit
                if trials(attempts(i).trialNum).protocolVersion >= 4
                    if trials(attempts(i).trialNum).pertEnableTrial % if the trial is perturbed
                        subplot(3,2,1)
                        pertHitPosPlot = plot(timeAxis, trials(attempts(i).trialNum).pos(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'g', 'lineWidth', 1.5); % plot position trace for turn
                        pertHitPosPlot.Color(4) = 0.1;
                    else % if the trial is unperturbed
                        subplot(3,2,2)
                        unpertHitPosPlot = plot(timeAxis, trials(attempts(i).trialNum).pos(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'b', 'lineWidth', 1.5); % plot position trace for turn
                        unpertHitPosPlot.Color(4) = 0.1;
                    end
                else % protocols before v4 treated stiffness as a pseudo perturbation and are plotted as unperturbed
                    subplot(3,2,1)
                    unpertHitPosPlot = plot(timeAxis, trials(attempts(i).trialNum).pos(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'b', 'lineWidth', 1.5); % plot position trace for turn
                    unpertHitPosPlot.Color(4) = 0.1;
                end
                hold on
                if trials(attempts(i).trialNum).protocolVersion >= 4
                    if trials(attempts(i).trialNum).pertEnableTrial
                        subplot(3,2,1)
                        scatter(timeAxisScatter, trials(attempts(i).trialNum).pos(attempts(i).hitIdx), 'g', 'filled')
                    else
                        subplot(3,2,2)
                        scatter(timeAxisScatter, trials(attempts(i).trialNum).pos(attempts(i).hitIdx), 'b', 'filled')
                    end
                else % protocols before v4 treated stiffness as a pseudo perturbation and are plotted as unperturbed
                    subplot(3,2,1)
                    scatter(timeAxisScatter, trials(attempts(i).trialNum).pos(attempts(i).hitIdx), 'b', 'filled')
                end
                %---PLOT VELOCITY FOR HIT ATTEMPT----%
                if trials(attempts(i).trialNum).protocolVersion >= 4
                    if trials(attempts(i).trialNum).pertEnableTrial
                        subplot(3,2,3)
                        pertHitVelPlot = plot(timeAxis, trials(attempts(i).trialNum).vel(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'g', 'lineWidth', 1.5);
                        pertHitVelPlot.Color(4) = 0.1;
                    else
                        subplot(3,2,4)
                        unpertHitVelPlot = plot(timeAxis, trials(attempts(i).trialNum).vel(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'b', 'lineWidth', 1.5);
                        unpertHitVelPlot.Color(4) = 0.1;
                    end
                else % protocols before v4 treated stiffness as a pseudo perturbation and are plotted as unperturbed
                    subplot(3,2,4)
                    unpertHitVelPlot = plot(timeAxis, trials(attempts(i).trialNum).vel(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'b', 'lineWidth', 1.5);
                    unpertHitVelPlot.Color(4) = 0.1;
                end
                hold on
                
                if trials(attempts(i).trialNum).protocolVersion >= 4
                    if trials(attempts(i).trialNum).pertEnableTrial
                        subplot(3,2,3)
                        scatter(timeAxisScatter, 0, 'g', 'filled')
                    else
                        subplot(3,2,4)
                        scatter(timeAxisScatter, 0, 'b', 'filled')
                    end
                else % protocols before v4 treated stiffness as a pseudo perturbation and are plotted as unperturbed
                    subplot(3,2,4)
                    scatter(sampleTime * (attempts(i).hitIdx - attempts(i).startIdx), 0, 'b', 'filled')
                end
                %---PLOT CURRENTFOR HIT ATTEMPT----%
                hapticWallCurrent = trials(attempts(i).trialNum).hapticWallCurrent(attempts(i).startIdx - dataPrior : attempts(i).endIdx);
                stiffnessCurrent = trials(attempts(i).trialNum).stiffnessCurrent(attempts(i).startIdx - dataPrior : attempts(i).endIdx);
                perturbationCurrent = trials(attempts(i).trialNum).pertCurrent(attempts(i).startIdx - dataPrior : attempts(i).endIdx);
                if isfield(trials(attempts(i).trialNum), 'actualCurrent') && trials(attempts(i).trialNum).protocolVersion >= 4 && trials(attempts(i).trialNum).pertEnableTrial
                    subplot(3,2,5)
                    pertHitCurrentPlot =  plot(timeAxis,hapticWallCurrent + stiffnessCurrent + perturbationCurrent, 'r', 'lineWidth', 1.5);
                    pertHitCurrentPlot.Color(4) = 0.1;
                    hold on
                else
                    subplot(3,2,6)
                    unpertHitCurrentPlot =  plot(timeAxis,hapticWallCurrent + stiffnessCurrent + perturbationCurrent, 'r', 'lineWidth', 1.5);
                    unpertHitCurrentPlot.Color(4) = 0.1;
                    hold on
                end
%                     h1 = plot(timeAxis, trials(attempts(i).trialNum).actualCurrent(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'k', 'lineWidth', 1.5);
%                     h1.Color(4) = 0.1;
%                 hold on
%                 h2 = plot(timeAxis, trials(attempts(i).trialNum).motorCurrent(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'r', 'lineWidth', 1.5);
%                 h2.Color(4) = 0.1;
            else
                %---PLOT POSITION FOR MISSED ATTEMPT---%
                if trials(attempts(i).trialNum).protocolVersion >= 4
                    if trials(attempts(i).trialNum).pertEnableTrial
                        subplot(3,2,1)
                        pertMissPosPlot = plot(timeAxis, trials(attempts(i).trialNum).pos(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'r', 'lineWidth', 1.5);
                        pertMissPosPlot.Color(4) = 0.1;
                    else
                        subplot(3,2,2)
                        unpertMissPosPlot = plot(timeAxis, trials(attempts(i).trialNum).pos(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'c', 'lineWidth', 1.5);
                        unpertMissPosPlot.Color(4) = 0.1;
                    end
                else % protocols before v4 treated stiffness as a pseudo perturbation and are plotted as unperturbed
                    subplot(3,2,2)
                    unpertMissPosPlot = plot(timeAxis, trials(attempts(i).trialNum).pos(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'c', 'lineWidth', 1.5);
                    unpertMissPosPlot.Color(4) = 0.1;
                end
                hold on
                if trials(attempts(i).trialNum).protocolVersion >= 4
                    if trials(attempts(i).trialNum).pertEnableTrial
                        subplot(3,2,1)
                        scatter(timeAxisScatter, trials(attempts(i).trialNum).pos(attempts(i).endIdx), 'r', 'filled')
                    else
                        subplot(3,2,2)
                        scatter(timeAxisScatter, trials(attempts(i).trialNum).pos(attempts(i).endIdx), 'c', 'filled')
                    end
                else % protocols before v4 treated stiffness as a pseudo perturbation and are plotted as unperturbed
                    subplot(3,2,2)
                    scatter(timeAxisScatter, trials(attempts(i).trialNum).pos(attempts(i).endIdx), 'c', 'filled')
                end
                %---PLOT VELOCITY FOR MISSED ATTEMPT---%
                if trials(attempts(i).trialNum).protocolVersion >= 4
                    if trials(attempts(i).trialNum).pertEnableTrial
                        subplot(3,2,3)
                        pertMissVelPlot = plot(timeAxis, trials(attempts(i).trialNum).vel(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'r', 'lineWidth', 1.5);
                        pertMissVelPlot.Color(4) = 0.1;
                    else
                        subplot(3,2,4)
                        unpertMissVelPlot = plot(timeAxis, trials(attempts(i).trialNum).vel(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'c', 'lineWidth', 1.5);
                        unpertMissVelPlot.Color(4) = 0.1;
                    end
                else % protocols before v4 treated stiffness as a pseudo perturbation and are plotted as unperturbed
                    subplot(3,2,4)
                    unpertMissVelPlot = plot(timeAxis, trials(attempts(i).trialNum).vel(attempts(i).startIdx - dataPrior : attempts(i).endIdx), 'c', 'lineWidth', 1.5);
                    unpertMissVelPlot.Color(4) = 0.1;
                end
                hold on
                if trials(attempts(i).trialNum).protocolVersion >= 4
                    if trials(attempts(i).trialNum).pertEnableTrial
                        subplot(3,2,3)
                        scatter(timeAxisScatter, 0, 'r', 'filled')
                    else
                        subplot(3,2,4)
                        scatter(timeAxisScatter, 0, 'c', 'filled')
                    end
                else % protocols before v4 treated stiffness as a pseudo perturbation and are plotted as unperturbed
                    subplot(3,2,4)
                    scatter(timeAxisScatter, 0, 'c', 'filled')
                end
                %---PLOT CURRENT FOR MISSED ATTEMPT---%
                hapticWallCurrent = trials(attempts(i).trialNum).hapticWallCurrent(attempts(i).startIdx - dataPrior : attempts(i).endIdx);
                stiffnessCurrent = trials(attempts(i).trialNum).stiffnessCurrent(attempts(i).startIdx - dataPrior : attempts(i).endIdx);
                perturbationCurrent = trials(attempts(i).trialNum).pertCurrent(attempts(i).startIdx - dataPrior : attempts(i).endIdx);
                if isfield(trials(attempts(i).trialNum), 'actualCurrent') && trials(attempts(i).trialNum).protocolVersion >= 4 && trials(attempts(i).trialNum).pertEnableTrial
                    
                    subplot(3,2,5)
                    pertMissCurrentPlot =  plot(timeAxis, hapticWallCurrent + stiffnessCurrent + perturbationCurrent, 'r', 'lineWidth', 1.5);
                    pertMissCurrentPlot.Color(4) = 0.1;
                    hold on
                else
                    subplot(3,2,6)
                    unpertMissCurrentPlot =  plot(timeAxis, hapticWallCurrent + stiffnessCurrent + perturbationCurrent, 'r', 'lineWidth', 1.5);
                    unpertMissCurrentPlot.Color(4) = 0.1;
                    hold on
                end
            end
        end
end
%---POST PLOTTING ANALYSIS---%
if plotType == 1
    subplot(3,2,1)
    pertHitPosPlot = plot(0,0, 'g');
    unpertHitPosPlot = plot(0,0, 'b');
    subplot(3,2,3)
    pertHitVelPlot = plot(0,0, 'g');
    unpertHitVelPlot = plot(0,0, 'b');
    subplot(3,2,5)
    pertHitCurrentPlot = plot(0,0, 'r');
    unpertHitCurrentPlot = plot(0,0, 'r');
    subplot(3,2,2)
    pertMissPosPlot = plot(0,0, 'r');
    unpertMissPosPlot = plot(0,0, 'c');
    subplot(3,2,4)
    pertMissVelPlot = plot(0,0, 'r');
    unpertMissVelPlot = plot(0,0, 'c');
    subplot(3,2,6)
    pertMissCurrentPlot = plot(0,0, 'r');
    unpertMissCurrentPlot = plot(0,0, 'r');
elseif plotType == 2
    subplot(3,2,1)
    pertHitPosPlot = plot(0,0, 'g');
    pertMissPosPlot = plot(0,0, 'r');
    subplot(3,2,3)
    pertHitVelPlot = plot(0,0, 'g');
    pertMissVelPlot = plot(0,0, 'r');
    subplot(3,2,5)
    pertHitCurrentPlot = plot(0,0, 'r');
    pertMissCurrentPlot = plot(0,0, 'r');
    subplot(3,2,2)
    unpertHitPosPlot = plot(0,0, 'b');
    unpertMissPosPlot = plot(0,0, 'c');
    subplot(3,2,4)
    unpertHitVelPlot = plot(0,0, 'b');
    unpertMissVelPlot = plot(0,0,'c');
    subplot(3,2,6)
    unpertHitCurrentPlot = plot(0,0,'r');
    unpertMissCurrentPlot = plot(0,0, 'r');
end

subplot(3,2,1) % SUCCESSFUL ATTEMPTS (POS)
axis([-inf inf -inf inf])
xlabel('Time (ms)')
ylabel('Position (deg)')
plot([-100 400], [trials(attempts(i).trialNum).maxWindow trials(attempts(i).trialNum).maxWindow], 'k--', 'lineWidth', 2)
plot([0 0], [-20 100], 'k--', 'lineWidth', 2)
hold on
plot([-100 400], [trials(attempts(i).trialNum).minWindow trials(attempts(i).trialNum).minWindow], 'k--', 'lineWidth', 2)

if plotType == 1
    title([trials(1).subject ' position traces (hit)'])
    legend([pertHitPosPlot unpertHitPosPlot], {'Perturbed Hit', 'Unperturbed Hit'})
elseif plotType == 2% FAILED ATTEMPTS (POS)
    title([trials(1).subject ' position traces (perturbed)'])
    legend([pertHitPosPlot pertMissPosPlot], {'Perturbed Hit', 'Perturbed Miss'})
end

subplot(3,2,3) % SUCCESSFUL ATTEMPTS (VEL)
xlabel('Time (ms)')
ylabel('Velocity (deg/s)')
plot([-100 400], [75 75], 'k--','lineWidth', 2)
hold on
%scatter(session.meanHitAttemptTime, -250, 'k', 'filled')
%plot([session.meanHitAttemptTime - session.stdHitAttemptTime, session.meanHitAttemptTime  + session.stdHitAttemptTime], [-250 -250], 'k', 'lineWidth', 1.5)
plot([0 0], [min([attempts(:).minVel]) max([attempts(:).maxVel])], 'k--', 'lineWidth', 2)
xlim([-100 400])
ylim([-inf inf])
%ylim([-300 max(maxVelStore) + 100])
if plotType == 1
    title([trials(1).subject ' velocity traces (hit)'])
    legend([pertHitVelPlot unpertHitVelPlot], {'Perturbed Hit', 'Unperturbed Hit'})
elseif plotType == 2
    title([trials(1).subject ' velocity traces (perturbed)'])
    legend([pertHitVelPlot pertMissVelPlot], {'Perturbed Hit', 'Perturbed Miss'})
end

subplot(3,2,5) % SUCCESSFUL ATTEMPTS (CURRENT)
xlabel('Time (ms)')
xlim([-100 400])
ylim([0 55])
plot([0 0], [0 55], 'k--', 'lineWidth', 2)
xlim([-100 400])
% if isfield(trials, 'actualCurrent')
%     legend([h1 h2], {'Actual', 'Desired'})
% else
%     legend([h2], 'Desired')
% end
legend([pertHitCurrentPlot], 'Desired current')
ylabel('Current to motor (mA)')
if plotType == 1
   title([trials(1).subject ' motor current traces (hit)']) 
elseif plotType == 2
    title([trials(1).subject ' motor current traces (perturbed)'])
end

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
% scatter(-15, session.meanLow, 'k', 'filled')
% plot( [-15 -15],[session.meanLow - session.stdLow, session.meanLow + session.stdLow], 'k', 'lineWidth', 1.5)
% scatter(-15, session.meanHigh, 'k', 'filled')
% plot([-15 -15],[session.meanHigh - session.stdHigh, session.meanHigh + session.stdHigh],  'k', 'lineWidth', 1.5)
%text(0, 0.95, ['Frac. above window: ' num2str(round(session.rateMissAbove ,2))], 'units', 'normalized')
%text(0, 0.89, ['Frac. below window: ' num2str(round(session.rateMissBelow ,2))], 'units', 'normalized')

%ylim([0 trials(attempts(i).trialNum).maxWindow])
if plotType == 1
    title([trials(1).subject ' position traces (miss)'])
    legend([pertMissPosPlot unpertMissPosPlot], {'Perturbed Miss', 'Unperturbed Miss'})
elseif plotType == 2
    title([trials(1).subject ' position traces (unperturbed)'])
    legend([unpertHitPosPlot unpertMissPosPlot], {'Unperturbed Hit', 'Unperturbed Miss'})
end

subplot(3,2,4) % FAILED ATTEMPTS (VEL)
xlabel('Time (ms)')
ylabel('Velocity (deg/s)')
plot([-100 400], [75 75], 'k--','lineWidth', 2)
plot([0 0], [min([attempts(:).minVel]) max([attempts(:).maxVel])], 'k--', 'lineWidth', 2)
xlim([-100 400])
missTrialIdx = find(~[attempts(:).hit]);
ylim([-inf max([attempts(missTrialIdx).maxVel]) + 100])
if plotType == 1
    title([trials(1).subject ' velocity traces (miss)'])
    legend([pertMissVelPlot unpertMissVelPlot], {'Perturbed Miss', 'Unperturbed Miss'})
elseif plotType == 2
    title([trials(1).subject ' velocity traces (unperturbed)'])
    legend([unpertHitVelPlot unpertMissVelPlot], {'Unperturbed Hit', 'Unperturbed Miss'})
end

subplot(3,2,6) % FAILED ATTEMPTS (CURRENT)
if plotType == 1
   title([trials(1).subject ' motor current traces (hit)']) 
elseif plotType == 2
    title([trials(1).subject ' motor current traces (unperturbed)'])
end
xlabel('Time (ms)')
xlim([-100 400])
ylim([0 55])
q = plot([0 0], [0 55], 'k--', 'lineWidth', 2);
legend([unpertHitCurrentPlot], 'Desired current')
xlim([-100 400])
% if isfield(trials, 'actualCurrent')
%     legend([g5 g6], {'Actual', 'Desired'})
% else
%     legend([g6], 'Desired')
% end
ylabel('Current to motor (mA)')

