%--first, find all instances where the turns begins and ends--%
close all
plotType = 2;
nonMoveTrial = 0;
sampleTime = trials(1).sampleTime * 1000;
timeFastTurnCutoff = 120;
dataPrior = 50;
velDelay = 4; % number of indices in delay due to filtering
timeStore = zeros(length(trials));
h = figure;
g = figure;
for i = 1:length(trials)
    zeroStartIdx = find(diff(double(trials(i).zeroVelFlag)) == -1); % turn beginss
    zeroIdxEnd = find(double(diff(trials(i).zeroVelFlag)) == 1); % turn ends
    if isempty(zeroStartIdx) && isempty(zeroIdxEnd) % check to see if no trial ad no movement
        nonMoveTrial = nonMoveTrial + 1;
    end
    
    % then find the last idx of trial
    figure(h);
    subplot(3,1,1)
    switch plotType
        case 1
            %---INITIALIZE PLOTS FOR LEGEND----%
           
            figure(h)
            h5 = plot(0,0, 'r');
            h3 = plot(0,0, 'r');
            figure(g)
            g1 = plot(0,0, 'r');
            g2 = plot(0,0, 'k');
            g3 = plot(0,0, 'r');
            g4 = plot(0,0, 'k');
            if trials(i).hitTrial
               
                postIdx = find(trials(i).state == 5, 1) - 1; % find the end of the trial phase idx (right before post-trial)
                % get rid of all idx in zero past this
                %zeroIdx(zeroIdx > postIdx) = [];
                hitTurnIdx = zeroStartIdx(zeroStartIdx < postIdx);
                % find the closest zeroidx to postidx
                minVals = abs(hitTurnIdx - postIdx);
                [~, idx] = min(minVals);
                startIdx = zeroStartIdx(idx);
                missAttemptsStartIdx = zeroStartIdx(zeroStartIdx < startIdx);
                
                % find the idx of the ending of the turn
                endIdx = zeroIdxEnd(zeroIdxEnd > startIdx);
                minVals = abs(startIdx - endIdx);
                [~, idx] = min(minVals);
                endIdx = endIdx(idx);
                % zeroIdxEnd(zeroIdxEnd < startIdx) = [];
                missAttemptsEndIdx = zeroIdxEnd(zeroIdxEnd < endIdx);
                hitIdx = find(trials(i).eventData_time == trials(i).trialData_time) - 1; % the hit actually occurs the previous index because the feed happens in posttrial
                startTurnTime = trials(i).trialData_time(startIdx);
                timeRelTurnStart = trials(i).eventData_time - startTurnTime - velDelay; % we have to account for the filtering delay when finding the relative turn start
                figure(h)
                subplot(3,1,1)
                if timeRelTurnStart < timeFastTurnCutoff
                    h5 = plot((0:2:2*length(trials(i).pos(startIdx - dataPrior: endIdx)) - 2) - dataPrior * 2, trials(i).pos(startIdx - dataPrior: endIdx), 'r', 'lineWidth', 1.5);
                    h5.Color(4) = 0.1;
                else
                    h6 = plot((0:2:2*length(trials(i).pos(startIdx - dataPrior: endIdx)) - 2) - dataPrior * 2, trials(i).pos(startIdx - dataPrior: endIdx), 'k', 'lineWidth', 1.5);
                    h6.Color(4) = 0.1;
                end
                hold on
                scatter(timeRelTurnStart, trials(i).pos(hitIdx), 'k', 'filled')
                subplot(3,1,2)
                if timeRelTurnStart < timeFastTurnCutoff
                    h3 = plot((0:2:2*length(trials(i).vel(startIdx - dataPrior: endIdx)) - 2) - dataPrior * 2, trials(i).vel(startIdx - dataPrior: endIdx), 'r', 'lineWidth', 1.5);
                    h3.Color(4) = 0.1;
                else
                    h4 = plot((0:2:2*length(trials(i).vel(startIdx - dataPrior: endIdx)) - 2) - dataPrior * 2, trials(i).vel(startIdx - dataPrior: endIdx), 'k', 'lineWidth', 1.5);
                    h4.Color(4) = 0.1;
                end
                hold on
                scatter(timeRelTurnStart, 0, 'k', 'filled')
                
                subplot(3,1,3)
                if isfield(trials, 'actualCurrent')
                    h1 = plot((0:2:2*length(trials(i).actualCurrent(startIdx - dataPrior: endIdx)) - 2) - dataPrior * 2, trials(i).actualCurrent(startIdx - dataPrior: endIdx) / 4 * double(trials(i).currentMax), 'k', 'lineWidth', 1.5);
                    h1.Color(4) = 0.1;
                end
                hold on
                h2 = plot((0:2:2*length(trials(i).motorCurrent(startIdx - dataPrior: endIdx)) - 2) - dataPrior * 2, trials(i).motorCurrent(startIdx - dataPrior: endIdx), 'r', 'lineWidth', 1.5);
                h2.Color(4) = 0.1;
                
                timeStore(i) = timeRelTurnStart;
            else
                postIdx = find(trials(i).state == 5, 1) - 1;
                missAttemptsStartIdx = zeroStartIdx(zeroStartIdx <= postIdx);
                if ~isempty(missAttemptsStartIdx)
                    missAttemptsStartIdx(end) = [];
                end
                missAttemptsEndIdx = zeroIdxEnd(zeroIdxEnd <= postIdx);
            end
            
            %--now plot failed turns--%
            %figure
            if ~isempty(missAttemptsStartIdx) && trials(i).flagFail ~= 1
                figure(g)
                for j = 1:length(missAttemptsStartIdx)
                    if missAttemptsStartIdx(j) < 50
                        dataPrior = missAttemptsStartIdx(j) - 1;
                    else
                        dataPrior = 50;
                    end
                    timeRelStart= missAttemptsEndIdx(j) * sampleTime - missAttemptsStartIdx(j) * sampleTime;
                    subplot(3,1,1)
                    if timeRelStart < timeFastTurnCutoff
                        g1 = plot((0:2:2*length(trials(i).pos(missAttemptsStartIdx(j) - dataPrior: missAttemptsEndIdx(j))) - 2) - dataPrior * 2, trials(i).pos(missAttemptsStartIdx(j) - dataPrior: missAttemptsEndIdx(j)), 'r', 'lineWidth', 1.5);
                        g1.Color(4) = 0.1;
                    else
                        g2 = plot((0:2:2*length(trials(i).pos(missAttemptsStartIdx(j) - dataPrior: missAttemptsEndIdx(j))) - 2) - dataPrior * 2, trials(i).pos(missAttemptsStartIdx(j) - dataPrior: missAttemptsEndIdx(j)), 'k', 'lineWidth', 1.5);
                        g2.Color(4) = 0.1;
                    end
                    hold on
                    if trials(i).pos(missAttemptsEndIdx(j)) > 10
                        scatter(timeRelStart, trials(i).pos(missAttemptsEndIdx(j)), 'k', 'filled')
                    end
                    
                    subplot(3,1,2)
                    if timeRelStart < timeFastTurnCutoff
                        g3 = plot((0:2:2*length(trials(i).vel(missAttemptsStartIdx(j) - dataPrior: missAttemptsEndIdx(j))) - 2) - dataPrior * 2, trials(i).vel(missAttemptsStartIdx(j) - dataPrior: missAttemptsEndIdx(j)), 'r', 'lineWidth', 1.5);
                        g3.Color(4) = 0.1;
                    else
                        g4 = plot((0:2:2*length(trials(i).vel(missAttemptsStartIdx(j) - dataPrior: missAttemptsEndIdx(j))) - 2) - dataPrior * 2, trials(i).vel(missAttemptsStartIdx(j) - dataPrior: missAttemptsEndIdx(j)), 'k', 'lineWidth', 1.5);
                        g4.Color(4) = 0.1;
                    end
                    hold on
                    if trials(i).pos(missAttemptsEndIdx(j)) > 10
                        scatter(timeRelStart, 0, 'k', 'filled')
                    end
                    subplot(3,1,3)
                    if isfield(trials, 'actualCurrent')
                        g5 = plot((0:2:2*length(trials(i).actualCurrent(missAttemptsStartIdx(j) - dataPrior: missAttemptsEndIdx(j))) - 2) - dataPrior * 2, trials(i).actualCurrent(missAttemptsStartIdx(j) - dataPrior: missAttemptsEndIdx(j)) / 4 * double(trials(i).currentMax), 'k', 'lineWidth', 1.5);
                        g5.Color(4) = 0.1;
                        hold on
                    end
                    g6 = plot((0:2:2*length(trials(i).motorCurrent(missAttemptsStartIdx(j) - dataPrior: missAttemptsEndIdx(j))) - 2) - dataPrior * 2, trials(i).motorCurrent(missAttemptsStartIdx(j) - dataPrior: missAttemptsEndIdx(j)), 'r', 'lineWidth', 1.5);
                    g6.Color(4) = 0.1;
                    hold on
                end
            end
        case 2
            %---INITIALIZE PLOTS FOR LEGEND----%

         
            if trials(i).hitTrial      
                postIdx = find(trials(i).state == 5, 1) - 1; % find the end of the trial phase idx (right before post-trial)
                % get rid of all idx in zero past this
                %zeroIdx(zeroIdx > postIdx) = [];
                hitTurnIdx = zeroStartIdx(zeroStartIdx < postIdx);
                % find the closest zeroidx to postidx
                minVals = abs(hitTurnIdx - postIdx);
                [~, idx] = min(minVals);
                startIdx = zeroStartIdx(idx);
                missAttemptsStartIdx = zeroStartIdx(zeroStartIdx < startIdx);
                
                % find the idx of the ending of the turn
                endIdx = zeroIdxEnd(zeroIdxEnd > startIdx);
                minVals = abs(startIdx - endIdx);
                [~, idx] = min(minVals);
                endIdx = endIdx(idx);
                % zeroIdxEnd(zeroIdxEnd < startIdx) = [];
                missAttemptsEndIdx = zeroIdxEnd(zeroIdxEnd < endIdx);
                hitIdx = find(trials(i).eventData_time == trials(i).trialData_time) - 1; % the hit actually occurs the previous index because the feed happens in posttrial
                startTurnTime = trials(i).trialData_time(startIdx);
                timeRelTurnStart = trials(i).eventData_time - startTurnTime - velDelay; % we have to account for the filtering delay when finding the relative turn start
                figure(h)
                subplot(3,1,1)
                if trials(i).pertEnableTrial
                    h5 = plot((0:2:2*length(trials(i).pos(startIdx - dataPrior: endIdx)) - 2) - dataPrior * 2, trials(i).pos(startIdx - dataPrior: endIdx), 'g', 'lineWidth', 1.5);
                    h5.Color(4) = 0.1;
                else
                    h6 = plot((0:2:2*length(trials(i).pos(startIdx - dataPrior: endIdx)) - 2) - dataPrior * 2, trials(i).pos(startIdx - dataPrior: endIdx), 'b', 'lineWidth', 1.5);
                    h6.Color(4) = 0.1;
                end
                hold on
                if trials(i).pertEnableTrial
                scatter(timeRelTurnStart, trials(i).pos(hitIdx), 'g', 'filled')
                else
                    scatter(timeRelTurnStart, trials(i).pos(hitIdx), 'b', 'filled')
                end
                subplot(3,1,2)
                if trials(i).pertEnableTrial
                    h3 = plot((0:2:2*length(trials(i).vel(startIdx - dataPrior: endIdx)) - 2) - dataPrior * 2, trials(i).vel(startIdx - dataPrior: endIdx), 'g', 'lineWidth', 1.5);
                    h3.Color(4) = 0.1;
                else
                    h4 = plot((0:2:2*length(trials(i).vel(startIdx - dataPrior: endIdx)) - 2) - dataPrior * 2, trials(i).vel(startIdx - dataPrior: endIdx), 'b', 'lineWidth', 1.5);
                    h4.Color(4) = 0.1;
                end
                hold on
                if trials(i).pertEnableTrial
                scatter(timeRelTurnStart, 0, 'g', 'filled')
                else
                    scatter(timeRelTurnStart, 0, 'b', 'filled')
                end
                subplot(3,1,3)
                if isfield(trials, 'actualCurrent')
                    h1 = plot((0:2:2*length(trials(i).actualCurrent(startIdx - dataPrior: endIdx)) - 2) - dataPrior * 2, trials(i).actualCurrent(startIdx - dataPrior: endIdx) / 4 * double(trials(i).currentMax), 'k', 'lineWidth', 1.5);
                    h1.Color(4) = 0.1;
                end
                hold on
                h2 = plot((0:2:2*length(trials(i).motorCurrent(startIdx - dataPrior: endIdx)) - 2) - dataPrior * 2, trials(i).motorCurrent(startIdx - dataPrior: endIdx), 'r', 'lineWidth', 1.5);
                h2.Color(4) = 0.1;
                
                timeStore(i) = timeRelTurnStart;
            else
                postIdx = find(trials(i).state == 5, 1) - 1;
                missAttemptsStartIdx = zeroStartIdx(zeroStartIdx <= postIdx);
                if ~isempty(missAttemptsStartIdx)
                    missAttemptsStartIdx(end) = [];
                end
                missAttemptsEndIdx = zeroIdxEnd(zeroIdxEnd <= postIdx);
            end
            
            %--now plot failed turns--%
            %figure
            if ~isempty(missAttemptsStartIdx) && trials(i).flagFail ~= 1
                figure(g)
                for j = 1:length(missAttemptsStartIdx)
                    if missAttemptsStartIdx(j) < 50
                        dataPrior = missAttemptsStartIdx(j) - 1;
                    else
                        dataPrior = 50;
                    end
                    timeRelStart= missAttemptsEndIdx(j) * sampleTime - missAttemptsStartIdx(j) * sampleTime;
                    subplot(3,1,1)
                    if trials(i).pertEnableTrial
                        g1 = plot((0:2:2*length(trials(i).pos(missAttemptsStartIdx(j) - dataPrior: missAttemptsEndIdx(j))) - 2) - dataPrior * 2, trials(i).pos(missAttemptsStartIdx(j) - dataPrior: missAttemptsEndIdx(j)), 'r', 'lineWidth', 1.5);
                        g1.Color(4) = 0.1;
                    else
                        g2 = plot((0:2:2*length(trials(i).pos(missAttemptsStartIdx(j) - dataPrior: missAttemptsEndIdx(j))) - 2) - dataPrior * 2, trials(i).pos(missAttemptsStartIdx(j) - dataPrior: missAttemptsEndIdx(j)), 'c', 'lineWidth', 1.5);
                        if ~isempty(g2)
                        g2.Color(4) = 0.1;
                        end
                    end
                    hold on
                    if trials(i).pos(missAttemptsEndIdx(j)) > 10
                        if trials(i).pertEnableTrial
                        scatter(timeRelStart, trials(i).pos(missAttemptsEndIdx(j)), 'r', 'filled')
                        else
                            scatter(timeRelStart, trials(i).pos(missAttemptsEndIdx(j)), 'c', 'filled')
                        end
                    end
                    
                    subplot(3,1,2)
                    if trials(i).pertEnableTrial
                        g3 = plot((0:2:2*length(trials(i).vel(missAttemptsStartIdx(j) - dataPrior: missAttemptsEndIdx(j))) - 2) - dataPrior * 2, trials(i).vel(missAttemptsStartIdx(j) - dataPrior: missAttemptsEndIdx(j)), 'r', 'lineWidth', 1.5);
                        g3.Color(4) = 0.1;
                    else
                        g4 = plot((0:2:2*length(trials(i).vel(missAttemptsStartIdx(j) - dataPrior: missAttemptsEndIdx(j))) - 2) - dataPrior * 2, trials(i).vel(missAttemptsStartIdx(j) - dataPrior: missAttemptsEndIdx(j)), 'c', 'lineWidth', 1.5);
                        if ~isempty(g4)
                        g4.Color(4) = 0.1;
                        end
                    end
                    hold on
                    if trials(i).pos(missAttemptsEndIdx(j)) > 10
                        if trials(i).pertEnableTrial
                        scatter(timeRelStart, 0, 'r', 'filled')
                        else
                            scatter(timeRelStart, 0, 'c', 'filled')
                        end
                    end
                    subplot(3,1,3)
                    if isfield(trials, 'actualCurrent')
                        g5 = plot((0:2:2*length(trials(i).actualCurrent(missAttemptsStartIdx(j) - dataPrior: missAttemptsEndIdx(j))) - 2) - dataPrior * 2, trials(i).actualCurrent(missAttemptsStartIdx(j) - dataPrior: missAttemptsEndIdx(j)) / 4 * double(trials(i).currentMax), 'k', 'lineWidth', 1.5);
                        if ~isempty(g5)
                        g5.Color(4) = 0.1;
                        end
                        hold on
                    end
                    g6 = plot((0:2:2*length(trials(i).motorCurrent(missAttemptsStartIdx(j) - dataPrior: missAttemptsEndIdx(j))) - 2) - dataPrior * 2, trials(i).motorCurrent(missAttemptsStartIdx(j) - dataPrior: missAttemptsEndIdx(j)), 'r', 'lineWidth', 1.5);
                    if ~isempty(g6)
                    g6.Color(4) = 0.1;
                    end
                    hold on
                end
            end
    end
end
timeStore(timeStore == 0) = [];
            figure(h)
            h5 = plot(0,0, 'g');
            h6 = plot(0,0, 'b');
            h3 = plot(0,0, 'g');
            h4 = plot(0,0, 'b');
            figure(g)
            g1 = plot(0,0, 'r');
            g2 = plot(0,0, 'c');
            g3 = plot(0,0, 'r');
            g4 = plot(0,0, 'c');
            g5 = plot(0,0, 'k');
            g6 = plot(0,0, 'r');
figure(h)
subplot(3,1,1)
title([trials(i).subject ' virtual stiffness position trajectories'])
xlabel('Time (ms)')
ylabel('Position (deg)')
plot([-100 400], [trials(i).maxWindow trials(i).maxWindow], 'k--', 'lineWidth', 2)
plot([0 0], [-20 100], 'k--', 'lineWidth', 2)
hold on
plot([-100 400], [trials(i).minWindow trials(i).minWindow], 'k--', 'lineWidth', 2)
xlim([-100 400])
ylim([-10 trials(i).maxWindow])
if plotType == 1
    legend([h5 h6], {'<120ms success', '>120ms success'})
elseif plotType == 2
    legend([h5 h6], {'Perturbed Hit', 'Unperturbed Hit'})
end

subplot(3,1,2)
title([trials(i).subject ' virtual stiffness velocity trajectories'])
xlabel('Time (ms)')
ylabel('Velocity (deg/s)')
plot([-100 400], [75 75], 'k--','lineWidth', 2)
plot([0 0], [-500 2000], 'k--', 'lineWidth', 2)
xlim([-100 400])
if plotType == 1
    legend([h3 h4], {'<120ms success', '>120ms success'})
elseif plotType == 2
    legend([h3 h4], {'Perturbed Hit', 'Unperturbed Hit'})
end

subplot(3,1,3)
title([trials(i).subject ' virtual stiffness motor current'])
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

figure(g)
subplot(3,1,1)
title([trials(i).subject ' virtual stiffness position trajectories FAILED'])
xlabel('Time (ms)')
ylabel('Position (deg)')
plot([-100 400], [trials(i).maxWindow trials(i).maxWindow], 'k--', 'lineWidth', 2)
plot([0 0], [-20 100], 'k--', 'lineWidth', 2)
hold on
plot([-100 400], [trials(i).minWindow trials(i).minWindow], 'k--', 'lineWidth', 2)
xlim([-100 400])
%ylim([0 trials(i).maxWindow])
if plotType == 1
    legend([g1 g2], {'<120ms success', '>120ms success'})
elseif plotType == 2
    legend([g1 g2], {'Perturbed Miss', 'Unperturbed Miss'})
end

subplot(3,1,2)
title([trials(i).subject ' virtual stiffness velocity trajectories FAILED'])
xlabel('Time (ms)')
ylabel('Velocity (deg/s)')
plot([-100 400], [75 75], 'k--','lineWidth', 2)
plot([0 0], [-500 2000], 'k--', 'lineWidth', 2)
xlim([-100 400])
if plotType == 1
    legend([g3 g4], {'<120ms success', '>120ms success'})
elseif plotType == 2
    legend([g3 g4], {'Perturbed Miss', 'Unperturbed Miss'})
end

subplot(3,1,3)
title([trials(i).subject ' virtual stiffness motor current FAILED'])
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
