close all
plotType = 2; % 1 = fast turns plotting, 2 = pert vs unpert; changes plot colors
nonMoveTrial = 0; % counts the number of trials with no movement
sampleTime = trials(1).sampleTime * 1000; % turns the sample time into ms
timeFastTurnCutoff = 120; % the cutoff in ms for fast turns
dataPrior = 50; % how many indices prior to plot 
%velDelay = 4; % number of indices in delay due to filtering
timeStore = zeros(length(trials), 1); % initialize storing the end turn time
maxVelStore = zeros(length(trials), 1); % initialize storing the max velocity of a successful turn
maxVelStoreFailIdx = 1;
maxFailTurnNum = 0;
minFailTurnNum = 0;
totalFailedTurns = 0;
totalHitTurns = 0;
h = figure; % initialize h, the figure where successful turns and current are plotted
%g = figure; % initialize g, the figure where failed turns and current are plotted

for i = 1:length(trials)
    %---DETERMINE VELOCITY TRANSITIONS---%
    postIdx = find(trials(i).state == 5, 1) - 1; % find the post trial index
    hitIdx = find(trials(i).eventData_time == trials(i).trialData_time) - 2; % find the index for when the hit occurred
    zeroStartIdx = find(diff(double(trials(i).zeroVelFlag)) == -1); % turn beginss
    zeroEndIdx = find(double(diff(trials(i).zeroVelFlag)) == 1); % turn ends
    
    %---CHECK FOR NON-MOVEMENT TRIALS---%
    if isempty(zeroStartIdx) && isempty(zeroEndIdx) % check to see if trial had no movement
        nonMoveTrial = nonMoveTrial + 1; % increment total non-movement trials
    end
    
    %---PLOT INDIVIDUAL TURN ATTEMPTS---%
    for j = 1:min(length(zeroStartIdx), length(zeroEndIdx))
        if hitIdx > zeroStartIdx(j) && hitIdx <= zeroEndIdx(j) && trials(i).hitTrial % if the attempt is a hit
            totalHitTurns = totalHitTurns + 1;
             successAttempts(totalHitTurns).maxPos = max(trials(i).pos(zeroStartIdx(j) : zeroEndIdx(j))); 
             successAttempts(totalHitTurns).maxVel = max(trials(i).vel(zeroStartIdx(j) : zeroEndIdx(j))); 
            timeStore(i) =sampleTime * (hitIdx - zeroStartIdx(j)); % store successful relative hit time 
            maxVelStore(i) = max(trials(i).vel(zeroStartIdx(j) - dataPrior : zeroEndIdx(j))); % store successful max velocity in turn
            figure(h)
            %---PLOT POSITION FOR HIT ATTEMPT----%
            subplot(3,2,1)
            if trials(i).protocolVersion >= 4 
                if trials(i).pertEnableTrial % if the trial is perturbed
                    h5 = plot((0: sampleTime : sampleTime *(zeroEndIdx(j) - zeroStartIdx(j) + dataPrior)) - dataPrior * sampleTime, trials(i).pos(zeroStartIdx(j) - dataPrior : zeroEndIdx(j)), 'g', 'lineWidth', 1.5); % plot position trace for turn 
                    h5.Color(4) = 0.1;
                else % if the trial is unperturbed
                    h6 = plot((0:2:2*(zeroEndIdx(j) - zeroStartIdx(j) + dataPrior)) - dataPrior * 2, trials(i).pos(zeroStartIdx(j) - dataPrior : zeroEndIdx(j)), 'b', 'lineWidth', 1.5); % plot position trace for turn
                    h6.Color(4) = 0.1;
                end
            else % protocols before v4 treated stiffness as a pseudo perturbation and are plotted as unperturbed
                h6 = plot((0:2:2*(zeroEndIdx(j) - zeroStartIdx(j) + dataPrior)) - dataPrior * 2, trials(i).pos(zeroStartIdx(j) - dataPrior : zeroEndIdx(j)), 'b', 'lineWidth', 1.5); % plot position trace for turn
                h6.Color(4) = 0.1;
            end
            hold on
            
            if trials(i).protocolVersion >= 4
                if trials(i).pertEnableTrial
                    scatter(sampleTime * (hitIdx - zeroStartIdx(j)), trials(i).pos(hitIdx), 'g', 'filled')
                else
                    scatter(sampleTime * (hitIdx - zeroStartIdx(j)), trials(i).pos(hitIdx), 'b', 'filled')
                end
            else % protocols before v4 treated stiffness as a pseudo perturbation and are plotted as unperturbed
                scatter(sampleTime * (hitIdx - zeroStartIdx(j)), trials(i).pos(hitIdx), 'b', 'filled')
            end
            %---PLOT VELOCITY FOR HIT ATTEMPT----%
            subplot(3,2,3)
            if trials(i).protocolVersion >= 4
                if trials(i).pertEnableTrial
                    h3 = plot((0:2:2*(zeroEndIdx(j) - zeroStartIdx(j) + dataPrior)) - dataPrior * 2, trials(i).vel(zeroStartIdx(j) - dataPrior : zeroEndIdx(j)), 'g', 'lineWidth', 1.5);
                    h3.Color(4) = 0.1;
                else
                    h4 = plot((0:2:2*(zeroEndIdx(j) - zeroStartIdx(j) + dataPrior)) - dataPrior * 2, trials(i).vel(zeroStartIdx(j) - dataPrior : zeroEndIdx(j)), 'b', 'lineWidth', 1.5);
                    h4.Color(4) = 0.1;
                end
            else % protocols before v4 treated stiffness as a pseudo perturbation and are plotted as unperturbed
                h4 = plot((0:2:2*(zeroEndIdx(j) - zeroStartIdx(j) + dataPrior)) - dataPrior * 2, trials(i).vel(zeroStartIdx(j) - dataPrior : zeroEndIdx(j)), 'b', 'lineWidth', 1.5);
                h4.Color(4) = 0.1;
            end
            hold on
           
            if trials(i).protocolVersion >= 4
                if trials(i).pertEnableTrial
                    scatter(sampleTime * (hitIdx - zeroStartIdx(j)), 0, 'g', 'filled')
                else
                    scatter(sampleTime * (hitIdx - zeroStartIdx(j)), 0, 'b', 'filled')
                end
            else % protocols before v4 treated stiffness as a pseudo perturbation and are plotted as unperturbed
                scatter(sampleTime * (hitIdx - zeroStartIdx(j)), 0, 'b', 'filled')
            end
             %---PLOT CURRENTFOR HIT ATTEMPT----%
            subplot(3,2,5)
            if isfield(trials, 'actualCurrent')
                h1 = plot((0:2:2*(zeroEndIdx(j) - zeroStartIdx(j) + dataPrior)) - dataPrior * 2, trials(i).actualCurrent(zeroStartIdx(j) - dataPrior : zeroEndIdx(j)), 'k', 'lineWidth', 1.5);
                h1.Color(4) = 0.1;
            end
            hold on
            h2 = plot((0:2:2*(zeroEndIdx(j) - zeroStartIdx(j) + dataPrior)) - dataPrior * 2, trials(i).motorCurrent(zeroStartIdx(j) - dataPrior : zeroEndIdx(j)), 'r', 'lineWidth', 1.5);
            h2.Color(4) = 0.1;
            
            
        elseif zeroEndIdx(j) <= postIdx && zeroStartIdx(j) < zeroEndIdx(j) && zeroStartIdx(j) > (1 + dataPrior) &&  (abs(max(trials(i).pos(zeroStartIdx(j) : zeroEndIdx(j))))> 5 ||  abs(min(trials(i).pos(zeroStartIdx(j) : zeroEndIdx(j))))> 5)  && trials(i).pos(zeroStartIdx(j)) == 0 %&&
            %figure(g)
            totalFailedTurns = totalFailedTurns + 1;
            failedAttempts(totalFailedTurns).pos = trials(i).pos(zeroStartIdx(j) - dataPrior : zeroEndIdx(j));
            failedAttempts(totalFailedTurns).vel = trials(i).vel(zeroStartIdx(j) - dataPrior : zeroEndIdx(j));
            failedAttempts(totalFailedTurns).maxPos = max(trials(i).pos(zeroStartIdx(j) : zeroEndIdx(j))); 
            failedAttempts(totalFailedTurns).maxVel = max(trials(i).vel(zeroStartIdx(j) : zeroEndIdx(j))); 
            if abs(max(trials(i).pos(zeroStartIdx(j) : zeroEndIdx(j)))) > trials(i).maxWindow
                failedAttempts(totalFailedTurns).aboveFail = 1;
            end
            if abs(max(trials(i).pos(zeroStartIdx(j) : zeroEndIdx(j)))) < trials(i).minWindow
                failedAttempts(totalFailedTurns).aboveFail = 0;
            end
            %---PLOT POSITION FOR MISSED ATTEMPT---%
            subplot(3,2,2)
            maxVelStoreFail(maxVelStoreFailIdx) = max(trials(i).vel(zeroStartIdx(j) : zeroEndIdx(j))); 
            maxVelStoreFailIdx = maxVelStoreFailIdx + 1;
            if trials(i).protocolVersion >= 4
                if trials(i).pertEnableTrial
                    g1 = plot((0:2:2*(zeroEndIdx(j) - zeroStartIdx(j) + dataPrior)) - dataPrior * 2, trials(i).pos(zeroStartIdx(j) - dataPrior : zeroEndIdx(j)), 'r', 'lineWidth', 1.5);
                    g1.Color(4) = 0.1;
                else
                    g2 = plot((0:2:2*(zeroEndIdx(j) - zeroStartIdx(j) + dataPrior)) - dataPrior * 2, trials(i).pos(zeroStartIdx(j) - dataPrior : zeroEndIdx(j)), 'c', 'lineWidth', 1.5);
                    g2.Color(4) = 0.1;
                end
            else % protocols before v4 treated stiffness as a pseudo perturbation and are plotted as unperturbed
                g2 = plot((0:2:2*(zeroEndIdx(j) - zeroStartIdx(j) + dataPrior)) - dataPrior * 2, trials(i).pos(zeroStartIdx(j) - dataPrior : zeroEndIdx(j)), 'c', 'lineWidth', 1.5);
                g2.Color(4) = 0.1;
            end
            hold on
            if trials(i).protocolVersion >= 4
                if trials(i).pertEnableTrial
                    scatter(sampleTime * (zeroEndIdx(j) - zeroStartIdx(j)), trials(i).pos(zeroEndIdx(j)), 'r', 'filled')
                else
                    scatter(sampleTime * (zeroEndIdx(j) - zeroStartIdx(j)), trials(i).pos(zeroEndIdx(j)), 'c', 'filled')
                end
            else % protocols before v4 treated stiffness as a pseudo perturbation and are plotted as unperturbed
                scatter(sampleTime * (zeroEndIdx(j) - zeroStartIdx(j)), trials(i).pos(zeroEndIdx(j)), 'c', 'filled')
            end
            %---PLOT VELOCITY FOR MISSED ATTEMPT---%
            subplot(3,2,4)
            if trials(i).protocolVersion >= 4
                if trials(i).pertEnableTrial
                    g3 = plot((0:2:2*(zeroEndIdx(j) - zeroStartIdx(j) + dataPrior)) - dataPrior * 2, trials(i).vel(zeroStartIdx(j) - dataPrior : zeroEndIdx(j)), 'r', 'lineWidth', 1.5); 
                    g3.Color(4) = 0.1;
                else
                    g4 = plot((0:2:2*(zeroEndIdx(j) - zeroStartIdx(j) + dataPrior)) - dataPrior * 2, trials(i).vel(zeroStartIdx(j) - dataPrior : zeroEndIdx(j)), 'c', 'lineWidth', 1.5);
                    g4.Color(4) = 0.1;
                end
            else % protocols before v4 treated stiffness as a pseudo perturbation and are plotted as unperturbed
                g4 = plot((0:2:2*(zeroEndIdx(j) - zeroStartIdx(j) + dataPrior)) - dataPrior * 2, trials(i).vel(zeroStartIdx(j) - dataPrior : zeroEndIdx(j)), 'c', 'lineWidth', 1.5);
                g4.Color(4) = 0.1;
            end
            hold on
            if trials(i).protocolVersion >= 4
                if trials(i).pertEnableTrial
                    scatter(sampleTime * (zeroEndIdx(j) - zeroStartIdx(j)), 0, 'r', 'filled')
                else
                    scatter(sampleTime * (zeroEndIdx(j) - zeroStartIdx(j)), 0, 'c', 'filled')
                end
            else % protocols before v4 treated stiffness as a pseudo perturbation and are plotted as unperturbed
                scatter(sampleTime * (zeroEndIdx(j) - zeroStartIdx(j)), 0, 'c', 'filled')
            end
            %---PLOT CURRENT FOR MISSED ATTEMPT---%
            subplot(3,2,6)
            if isfield(trials, 'actualCurrent')
                g5 = plot((0:2:2*(zeroEndIdx(j) - zeroStartIdx(j) + dataPrior)) - dataPrior * 2, trials(i).actualCurrent(zeroStartIdx(j) - dataPrior : zeroEndIdx(j)), 'k', 'lineWidth', 1.5);
                g5.Color(4) = 0.1;
            end
            hold on
            g6 = plot((0:2:2*(zeroEndIdx(j) - zeroStartIdx(j) + dataPrior)) - dataPrior * 2, trials(i).motorCurrent(zeroStartIdx(j) - dataPrior : zeroEndIdx(j)), 'r', 'lineWidth', 1.5);
            g6.Color(4) = 0.1;
        end
    end
end
%---POST PLOTTING ANALYSIS---%
lowIdx = find(~[failedAttempts(:).aboveFail]); % computes the indices of failed attempts below window
highIdx = find([failedAttempts(:).aboveFail]);  % computes the indices of failed attempts above window
meanLow = mean([failedAttempts(lowIdx).maxPos]); % computes mean of below window position end of attempt
meanHigh = mean([failedAttempts(highIdx).maxPos]); % computes mean of above window position end of attempt
stdLow = std([failedAttempts(lowIdx).maxPos]); % computes std of below window position end of attempt
stdHigh =  std([failedAttempts(highIdx).maxPos]); % computes std of above window position end of attempt

totalMissAbove = maxFailTurnNum / totalFailedTurns;
totalMissBelow = minFailTurnNum / totalFailedTurns;
timeStore(timeStore == 0) = [];
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
plot([-100 400], [trials(i).maxWindow trials(i).maxWindow], 'k--', 'lineWidth', 2)
plot([0 0], [-20 100], 'k--', 'lineWidth', 2)
hold on
plot([-100 400], [trials(i).minWindow trials(i).minWindow], 'k--', 'lineWidth', 2)

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
scatter(mean(timeStore), -250, 'k', 'filled')
plot([mean(timeStore) - std(timeStore), mean(timeStore) + std(timeStore)], [-250 -250], 'k', 'lineWidth', 1.5)
plot([0 0], [-500 2000], 'k--', 'lineWidth', 2)
xlim([-100 400])
ylim([-300 max(maxVelStore) + 100])
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
plot([-100 400], [trials(i).maxWindow trials(i).maxWindow], 'k--', 'lineWidth', 2)
plot([0 0], [min([failedAttempts(:).maxPos]) max([failedAttempts(:).maxPos])], 'k--', 'lineWidth', 2)
hold on
plot([-100 400], [trials(i).minWindow trials(i).minWindow], 'k--', 'lineWidth', 2)
scatter(-15, meanLow, 'k', 'filled')
plot( [-15 -15],[meanLow - stdLow, meanLow + stdLow], 'k', 'lineWidth', 1.5)
scatter(-15, meanHigh, 'k', 'filled')
plot([-15 -15],[meanHigh - stdHigh, meanHigh + stdHigh],  'k', 'lineWidth', 1.5)
text(0, 0.95, ['Frac. above window: ' num2str(round(sum([failedAttempts(:).aboveFail] / length(failedAttempts)),2))], 'units', 'normalized')
text(0, 0.89, ['Frac. below window: ' num2str(round(sum(~[failedAttempts(:).aboveFail] / length(failedAttempts)),2))], 'units', 'normalized')

%ylim([0 trials(i).maxWindow])
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
plot([0 0], [-500 2000], 'k--', 'lineWidth', 2)
xlim([-100 400])
ylim([-300 max(maxVelStoreFail) + 100])
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
% use this to plot excursions
attemptTurnRate = length(timeStore) / (totalFailedTurns + length(timeStore))
totalHitRate = length(timeStore) / (length(trials) - nonMoveTrial)
