function tracePlotterAttemptsSeparated(trials, velDelay)

close all
plotType = 2; % 1 = fast turns plotting, 2 = pert vs unpert; changes plot colors
nonMoveTrial = 0; % counts the number of trials with no movement
sampleTime = trials(1).sampleTime * 1000; % turns the sample time into ms
timeFastTurnCutoff = 120; % the cutoff in ms for fast turns
timeStore = zeros(length(trials), 1); % initialize storing the end turn time
maxVelStore = zeros(length(trials), 1); % initialize storing the max velocity of a successful turn
maxVelStoreFailIdx = 1;
maxFailTurnNum = 0;
minFailTurnNum = 0;
totalFailedTurns = 0;
totalHitTurns = 0;
timeShiftIncrement = 400;
maxAttemptNumSupination = 0;
maxAttemptNumPronation = 0;

h = figure; % initialize h, the figure where successful turns and current are plotted
g = figure; % initialize g, the figure where failed turns and current are plotted

for i = 1:length(trials)
    %---DETERMINE VELOCITY TRANSITIONS---%
    postIdx = find(trials(i).state == 5, 1) - 1; % find the post trial index
    hitIdx = find(trials(i).eventData_time == trials(i).trialData_time) - 2; % find the index for when the hit occurred
    zeroStartIdx = find(diff(double(trials(i).zeroVelFlag)) == -1); % turn begins
    zeroEndIdx = find(double(diff(trials(i).zeroVelFlag)) == 1); % turn ends
    attemptTotalTrial = 0;
    timeShift = 0;
    %---CHECK FOR NON-MOVEMENT TRIALS---%
    if isempty(zeroStartIdx) && isempty(zeroEndIdx) % check to see if trial had no movement
        nonMoveTrial = nonMoveTrial + 1; % increment total non-movement trials
    end
    switch trials(i).dirTask
        case 0
            figure(h);
        case 1
            figure(g);
    end
    %---PLOT INDIVIDUAL TURN ATTEMPTS---%
    for j = 1:min(length(zeroStartIdx), length(zeroEndIdx))
        if zeroEndIdx(j) <= postIdx && zeroStartIdx(j) < zeroEndIdx(j)  && (trials(i).pos(zeroEndIdx(j))>trials(i).trialStartTheta ||  trials(i).pos(zeroEndIdx(j))<-double(trials(i).trialStartTheta)) && trials(i).pos(zeroStartIdx(j)) == 0 && (max(abs(trials(i).pos(zeroStartIdx(j) : zeroEndIdx(j)))))< 250%&&
            %figure(g)
            
            totalFailedTurns = totalFailedTurns + 1;
            failedAttempts(totalFailedTurns).pos = trials(i).pos(zeroStartIdx(j)  : zeroEndIdx(j));
            failedAttempts(totalFailedTurns).vel = trials(i).vel(zeroStartIdx(j)  : zeroEndIdx(j));
            failedAttempts(totalFailedTurns).maxPos = max(trials(i).pos(zeroStartIdx(j) : zeroEndIdx(j)));
            failedAttempts(totalFailedTurns).maxVel = max(trials(i).vel(zeroStartIdx(j) : zeroEndIdx(j)));
            failedAttempts(totalFailedTurns).minPos = min(trials(i).pos(zeroStartIdx(j) : zeroEndIdx(j)));
            failedAttempts(totalFailedTurns).minVel = min(trials(i).vel(zeroStartIdx(j) : zeroEndIdx(j)));
            if abs(max(trials(i).pos(zeroStartIdx(j) : zeroEndIdx(j)))) > trials(i).maxWindow
                failedAttempts(totalFailedTurns).aboveFail = 1;
            end
            if abs(max(trials(i).pos(zeroStartIdx(j) : zeroEndIdx(j)))) < trials(i).minWindow
                failedAttempts(totalFailedTurns).aboveFail = 0;
            end
            %---PLOT POSITION FOR MISSED ATTEMPT---%
            subplot(3,1,1)
            maxVelStoreFail(maxVelStoreFailIdx) = max(trials(i).vel(zeroStartIdx(j) : zeroEndIdx(j)));
            maxVelStoreFailIdx = maxVelStoreFailIdx + 1;
            if trials(i).protocolVersion >= 4
                if trials(i).pertEnableTrial
                    g1 = plot((0: sampleTime : sampleTime *(zeroEndIdx(j) - zeroStartIdx(j))) + timeShift, trials(i).pos(zeroStartIdx(j)  : zeroEndIdx(j)), 'r', 'lineWidth', 1.5);
                else
                    if hitIdx > zeroStartIdx(j) && hitIdx <= zeroEndIdx(j) && trials(i).hitTrial
                        g2 = plot((0: sampleTime : sampleTime *(zeroEndIdx(j) - zeroStartIdx(j)))+ timeShift, trials(i).pos(zeroStartIdx(j)  : zeroEndIdx(j)), 'c', 'lineWidth', 1.5);
                    else
                        g2 = plot((0: sampleTime : sampleTime *(zeroEndIdx(j) - zeroStartIdx(j)))+ timeShift, trials(i).pos(zeroStartIdx(j)  : zeroEndIdx(j)), 'r', 'lineWidth', 1.5);
                        
                    end
                    hold on
                end
            else % protocols before v4 treated stiffness as a pseudo perturbation and are plotted as unperturbed
                g2 = plot((0: sampleTime : sampleTime *(zeroEndIdx(j) - zeroStartIdx(j))) + timeShift, trials(i).pos(zeroStartIdx(j)  : zeroEndIdx(j)), 'c', 'lineWidth', 1.5);
                g2.Color(4) = 0.1;
            end
            hold on
            if trials(i).protocolVersion >= 4
                if trials(i).pertEnableTrial
                    scatter((sampleTime * (zeroEndIdx(j) - zeroStartIdx(j))) + timeShift, trials(i).pos(zeroEndIdx(j)), 'r', 'filled')
                else
                    if hitIdx > zeroStartIdx(j) && hitIdx <= zeroEndIdx(j) && trials(i).hitTrial
                        scatter((sampleTime * (zeroEndIdx(j) - zeroStartIdx(j))) + timeShift,  trials(i).pos(zeroEndIdx(j)), 'c', 'filled')
                    else
                        scatter((sampleTime * (zeroEndIdx(j) - zeroStartIdx(j))) + timeShift,  trials(i).pos(zeroEndIdx(j)), 'r', 'filled')
                    end
                end
            else % protocols before v4 treated stiffness as a pseudo perturbation and are plotted as unperturbed
                scatter((sampleTime * (zeroEndIdx(j) - zeroStartIdx(j))) + timeShift, trials(i).pos(zeroEndIdx(j)), 'c', 'filled')
            end
            %---PLOT VELOCITY FOR MISSED ATTEMPT---%
            subplot(3,1,2)
            if trials(i).protocolVersion >= 4
                if trials(i).pertEnableTrial
                    g3 = plot((0: sampleTime : sampleTime *(zeroEndIdx(j) - zeroStartIdx(j))) + timeShift, trials(i).vel(zeroStartIdx(j)  : zeroEndIdx(j)), 'r', 'lineWidth', 1.5);
                else
                    if hitIdx > zeroStartIdx(j) && hitIdx <= zeroEndIdx(j) && trials(i).hitTrial
                        g4 = plot((0: sampleTime : sampleTime *(zeroEndIdx(j) - zeroStartIdx(j))) + timeShift, trials(i).vel(zeroStartIdx(j)  : zeroEndIdx(j)), 'c', 'lineWidth', 1.5);
                    else
                        g2 = plot((0: sampleTime : sampleTime *(zeroEndIdx(j) - zeroStartIdx(j)))+ timeShift, trials(i).vel(zeroStartIdx(j)  : zeroEndIdx(j)), 'r', 'lineWidth', 1.5);
                        
                    end
                    hold on
                end
            else % protocols before v4 treated stiffness as a pseudo perturbation and are plotted as unperturbed
                g4 = plot((0: sampleTime : sampleTime *(zeroEndIdx(j) - zeroStartIdx(j))) + timeShift, trials(i).vel(zeroStartIdx(j)  : zeroEndIdx(j)), 'c', 'lineWidth', 1.5);
            end
            hold on
            if trials(i).protocolVersion >= 4
                if trials(i).pertEnableTrial
                    scatter((sampleTime * (zeroEndIdx(j) - zeroStartIdx(j))) + timeShift, 0, 'r', 'filled')
                else
                    if hitIdx > zeroStartIdx(j) && hitIdx <= zeroEndIdx(j) && trials(i).hitTrial
                        scatter((sampleTime * (zeroEndIdx(j) - zeroStartIdx(j))) + timeShift, 0, 'c', 'filled')
                    else
                        scatter((sampleTime * (zeroEndIdx(j) - zeroStartIdx(j))) + timeShift, 0, 'r', 'filled')
                    end
                end
            else % protocols before v4 treated stiffness as a pseudo perturbation and are plotted as unperturbed
                scatter((sampleTime * (zeroEndIdx(j) - zeroStartIdx(j))) + timeShift, 0, 'c', 'filled')
            end
            %---PLOT CURRENT FOR MISSED ATTEMPT---%
            subplot(3,1,3)
            if isfield(trials, 'actualCurrent')
                g5 = plot((0: sampleTime : sampleTime *(zeroEndIdx(j) - zeroStartIdx(j))) + timeShift, trials(i).actualCurrent(zeroStartIdx(j)  : zeroEndIdx(j)), 'k', 'lineWidth', 1.5);
                hold on
                
            end
            hold on
            g6 = plot((0: sampleTime : sampleTime *(zeroEndIdx(j) - zeroStartIdx(j))) + timeShift, trials(i).motorCurrent(zeroStartIdx(j)  : zeroEndIdx(j)), 'r', 'lineWidth', 1.5);
            
            if trials(i).protocolVersion < 6 && trials(i).pos(zeroEndIdx(j)) < 0 && trials(i).taskMode == 0
                % there was a bug before v6 where negative turns were not
                % counted towards the attempt total
            else
                attemptTotalTrial = attemptTotalTrial + 1;
                timeShift = timeShift + timeShiftIncrement;
            end
            if attemptTotalTrial > maxAttemptNumSupination && trials(i).dirTask == 0
                maxAttemptNumSupination = attemptTotalTrial;
            elseif attemptTotalTrial > maxAttemptNumPronation && trials(i).dirTask == 1
                maxAttemptNumPronation = attemptTotalTrial;
            end
            
        end
    end
    attemptTotal(i) = attemptTotalTrial;
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
subplot(3,1,1)
h5 = plot(0,0, 'g');
h6 = plot(0,0, 'b');
subplot(3,1,2)
h3 = plot(0,0, 'g');
h4 = plot(0,0, 'b');
subplot(3,1,3)
h2 = plot(0,0, 'r');
h1 = plot(0,0, 'k');
figure(g)
subplot(3,1,1)
g1 = plot(0,0, 'r');
g2 = plot(0,0, 'c');
subplot(3,1,2)
g3 = plot(0,0, 'r');
g4 = plot(0,0, 'c');
subplot(3,1,3)
g5 = plot(0,0, 'k');
g6 = plot(0,0, 'r');
figure(h)
subplot(3,1,1) % SUCCESSFUL ATTEMPTS (POS)
% axis([-inf inf -inf inf])
title([trials(1).subject ' supination attempt position'])
xlabel('Attempt #')
ylabel('Position (deg)')
xlim([0 maxAttemptNumSupination * timeShiftIncrement])
xticks([0:timeShiftIncrement:timeShiftIncrement*maxAttemptNumSupination])
xticklabels([1:1:maxAttemptNumSupination])
ylim([-inf inf])
storedYlim = ylim;
% for i = 1:maxAttemptNumSupination
%     plot([(i-1)*timeShiftIncrement (i-1)*timeShiftIncrement], [storedYlim(1) storedYlim(2)])
% end
% plot([-100 400], [trials(i).maxWindow trials(i).maxWindow], 'k--', 'lineWidth', 2)
% plot([0 0], [-20 100], 'k--', 'lineWidth', 2)
% hold on
% plot([-100 400], [trials(i).minWindow trials(i).minWindow], 'k--', 'lineWidth', 2)

% if plotType == 1
%     legend([h5 h6], {'<120ms success', '>120ms success'})
% elseif plotType == 2% FAILED ATTEMPTS (POS)
%     legend([h5 h6], {'Perturbed Hit', 'Unperturbed Hit'})
% end

subplot(3,1,2) % SUCCESSFUL ATTEMPTS (VEL)
title([trials(1).subject ' supination attempt velocity'])
xlabel('Attempt #')
ylabel('Velocity (deg/s)')
xlim([0 maxAttemptNumSupination * timeShiftIncrement])
xticks([0:timeShiftIncrement:timeShiftIncrement*maxAttemptNumSupination])
xticklabels([1:1:maxAttemptNumSupination])
ylim([-inf inf])
% plot([-100 400], [75 75], 'k--','lineWidth', 2)
hold on
% scatter(mean(timeStore), -250, 'k', 'filled')
% plot([mean(timeStore) - std(timeStore), mean(timeStore) + std(timeStore)], [-250 -250], 'k', 'lineWidth', 1.5)
% % plot([0 0], [min([successAttempts(:).minVel]) max([successAttempts(:).maxVel])], 'k--', 'lineWidth', 2)
% xlim([-100 400])
% ylim([-inf inf])
%ylim([-300 max(maxVelStore) + 100])
% if plotType == 1
%     legend([h3 h4], {'<120ms success', '>120ms success'})
% elseif plotType == 2
%     legend([h3 h4], {'Perturbed Hit', 'Unperturbed Hit'})
% end

subplot(3,1,3) % SUCCESSFUL ATTEMPTS (CURRENT)
title([trials(1).subject ' supination attempt current'])
xlabel('Attempt #')
ylabel('Current to motor (mA)')
xlim([0 maxAttemptNumSupination * timeShiftIncrement])
xticks([0:timeShiftIncrement:timeShiftIncrement*maxAttemptNumSupination])
xticklabels([1:1:maxAttemptNumSupination])
figure(g)
subplot(3,1,1) % FAILED ATTEMPTS (POS)
% axis([-inf inf -inf inf])
title([trials(1).subject ' pronation attempts position'])
xlabel('Attempt #')
ylabel('Position (deg)')
xlim([0 maxAttemptNumPronation * timeShiftIncrement])
xticks([0:timeShiftIncrement:timeShiftIncrement*maxAttemptNumPronation])
xticklabels([1:1:maxAttemptNumPronation])
ylim([-inf inf])
% plot([-100 400], [trials(i).maxWindow trials(i).maxWindow], 'k--', 'lineWidth', 2)
% plot([0 0], [min([failedAttempts(:).maxPos]) max([failedAttempts(:).maxPos])], 'k--', 'lineWidth', 2)
% hold on
% plot([-100 400], [trials(i).minWindow trials(i).minWindow], 'k--', 'lineWidth', 2)
% scatter(-15, meanLow, 'k', 'filled')
% plot( [-15 -15],[meanLow - stdLow, meanLow + stdLow], 'k', 'lineWidth', 1.5)
% scatter(-15, meanHigh, 'k', 'filled')
% plot([-15 -15],[meanHigh - stdHigh, meanHigh + stdHigh],  'k', 'lineWidth', 1.5)
% text(0, 0.95, ['Frac. above window: ' num2str(round(sum([failedAttempts(:).aboveFail] / length(failedAttempts)),2))], 'units', 'normalized')
% text(0, 0.89, ['Frac. below window: ' num2str(round(sum(~[failedAttempts(:).aboveFail] / length(failedAttempts)),2))], 'units', 'normalized')

%ylim([0 trials(i).maxWindow])
% if plotType == 1
%     legend([g1 g2], {'<120ms success', '>120ms success'})
% elseif plotType == 2
%     legend([g1 g2], {'Perturbed Miss', 'Unperturbed Miss'})
% end

subplot(3,1,2) % FAILED ATTEMPTS (VEL)
title([trials(1).subject ' pronation attempts velocity'])
xlabel('Attempt #')
ylabel('Velocity (deg/s)')
xlim([0 maxAttemptNumPronation * timeShiftIncrement])
xticks([0:timeShiftIncrement:timeShiftIncrement*maxAttemptNumPronation])
xticklabels([1:1:maxAttemptNumPronation])
ylim([-inf inf])
% plot([-100 400], [75 75], 'k--','lineWidth', 2)
% plot([0 0], [min([failedAttempts(:).minVel]) max([failedAttempts(:).maxVel])], 'k--', 'lineWidth', 2)
% xlim([-100 400])
% ylim([-inf max(maxVelStoreFail) + 100])
% if plotType == 1
%     legend([g3 g4], {'<120ms success', '>120ms success'})
% elseif plotType == 2
%     legend([g3 g4], {'Perturbed Miss', 'Unperturbed Miss'})
% end

subplot(3,1,3) % FAILED ATTEMPTS (CURRENT)
title([trials(1).subject ' pronation attempts current'])
xlabel('Attempt #')
% xlim([-100 400])
% ylim([0 55])
% plot([0 0], [0 55], 'k--', 'lineWidth', 2)
% xlim([-100 400])
% if isfield(trials, 'actualCurrent')
%     legend([g5 g6], {'Actual', 'Desired'})
% else
%     legend([g6], 'Desired')
% end
ylabel('Current to motor (mA)')
xlim([0 maxAttemptNumPronation * timeShiftIncrement])
xticks([0:timeShiftIncrement:timeShiftIncrement*maxAttemptNumPronation])
xticklabels([1:1:maxAttemptNumPronation])
% use this to plot excursions
% attemptTurnRate = length(timeStore) / nansum([attemptTrial(:).totalAttempts]);
% totalHitRate = length(timeStore) / (length(trials) - length(find(isnan([attemptTrial(:).totalAttempts]))));
%
% fprintf('Turn attempt hit rate: %s\n', num2str(round(attemptTurnRate,2)))
% fprintf('Corrected overall hit rate (removed non-move trials): %s\n' ,num2str(round(totalHitRate,2)))
