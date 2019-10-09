%function tracePlotterAllSessions
close all
clear failedAttemptsMax
plotType = 2; % 1 = fast turns plotting, 2 = pert vs unpert; changes plot colors
nonMoveTrial = 0; % counts the number of trials with no movement
sampleTime = 2e-3 * 1000; % turns the sample time into ms
timeFastTurnCutoff = 120; % the cutoff in ms for fast turns
dataPrior = 50; % how many indices prior to plot
velDelay = 4; % number of indices in delay due to filtering
maxVelStoreFailIdx = 1;
maxFailTurnNum = 0;
minFailTurnNum = 0;
totalFailedTurns = 0;
totalHitTurns = 0;
totalSessions = 1;
dataPrior = 50;
%basedir = ['/home/snel/mnt/turing/data/trialLogger/RATKNOBTASK/'];
basedir = ['X:\data\trialLogger\RATKNOBTASK\'];
% first select subject
ratNameDirAll = dir(basedir);
ratNames = {ratNameDirAll.name};
ratNames= ratNames(3:end); % trim . and .. from filenames
[ratInput_idx,~] = listdlg('PromptString', 'Select a rat to assess virtual stiffness consistency', 'SelectionMode', 'single', 'ListString', ratNames);
subjdir = [basedir ratNames{ratInput_idx} '/'];
sessionDatesDirAll = dir(subjdir);
sessionDates = {sessionDatesDirAll.name};
sessionDates = sessionDates(3:end); % trim . and .. from filenames
for dates = 1:length(sessionDates) % run through all session dates to create summaries
    sessiondir = [subjdir sessionDates{dates} '/1/'];
    sessionTimeDirAll = dir(sessiondir);
    sessionTime = {sessionTimeDirAll.name};
    sessionTime = sessionTime(3:end);
    for times = 1:length(sessionTime)
        clear trialCell
        dataDir = [sessiondir sessionTime{times} '/'];
        files = dir([dataDir '*.mat']);
        for iF = 1:length(files) % load files for summaries
            data = load([dataDir files(iF).name], 'trial');
            trialCell{iF} = data.trial;
        end
        trials = preprocessData(trialCell, files);
        timeStore = zeros(length(trials), 1);
        totalHitTurns = 0;
        totalFailedTurns = 0;
        nonMoveTrial = 0;
        if isfield(trials(1), 'trialResetType') && trials(1).trialResetType == 2
           
            [attempts, trials, session] = attemptPreprocess(trials);
                        %---POST PLOTTING ANALYSIS---%
            lowIdx = find(~[failedAttempts(:).aboveFail]); % computes the indices of failed attempts below window
            highIdx = find([failedAttempts(:).aboveFail]);  % computes the indices of failed attempts above window
            meanLow = mean([failedAttempts(lowIdx).maxPos]); % computes mean of below window position end of attempt
            meanHigh = mean([failedAttempts(highIdx).maxPos]); % computes mean of above window position end of attempt
            stdLow = std([failedAttempts(lowIdx).maxPos]); % computes std of below window position end of attempt
            stdHigh =  std([failedAttempts(highIdx).maxPos]); % computes std of above window position end of attempt
            
            %         totalMissAbove = maxFailTurnNum / totalFailedTurns;
            %         totalMissBelow = minFailTurnNum / totalFailedTurns;
            attemptTurnRate(totalSessions) = session.attemptHitRate;
            totalHitRate(totalSessions) = session.overallHitRateCorrected;
%             failedAttemptsMax(totalSessions) = trials(i).failedAttemptsMax;
            sessionDate{totalSessions} = trials(1).date;
            sessionSaveTag{totalSessions} = trials(1).saveTag;
            failedAttemptsMax(totalSessions) = trials(1).failedAttemptsMax;
            totalSessions = totalSessions + 1;
            
%             attemptArray(validSession) = attempts
%              validSession = valid
%             for i = 1:length(trials)
%                 %---DETERMINE VELOCITY TRANSITIONS---%
%                 postIdx = find(trials(i).state == 5, 1) - 1; % find the post trial index
%                  trialIdx = find(trials(i).state == 3);
%                 hitIdx = find(trials(i).eventData_time == trials(i).trialData_time) - 2; % find the index for when the hit occurred
%                 zeroStartIdx = find(diff(double(trials(i).zeroVelFlag)) == -1); % turn beginss
%                 zeroEndIdx = find(double(diff(trials(i).zeroVelFlag)) == 1); % turn ends
%                     zeroStartIdx(zeroStartIdx < trialIdx(1)) = [];
%     zeroEndIdx(zeroEndIdx < trialIdx(1)) = [];
%                 %---CHECK FOR NON-MOVEMENT TRIALS---%
%                 if isempty(zeroStartIdx) && isempty(zeroEndIdx) % check to see if trial had no movement
%                     nonMoveTrial = nonMoveTrial + 1; % increment total non-movement trials
%                 end
%                 % for i = 1:length(failedAttemptsMax)
% %     sessionVal(totalPlotVals) = i;
% %     if i < length(failedAttemptsMax) && failedAttemptsMax(i) ~= failedAttemptsMax(i+1)
% %         failedAttemptsMax = [failedAttemptsMax(1:i) failedAttemptsMax(i) failedAttemptsMax(i+1:end)];
% %          totalPlotVals = totalPlotVals + 1;
% %         sessionVal(totalPlotVals) = i;
% %        
% %     end
% %     totalPlotVals = totalPlotVals + 1;
% % end
% 
%                 %---PLOT INDIVIDUAL TURN ATTEMPTS---%
%                 for j = 1:min(length(zeroStartIdx), length(zeroEndIdx))
%                     if hitIdx > zeroStartIdx(j) && hitIdx <= zeroEndIdx(j) && trials(i).hitTrial % if the attempt is a hit
%                         totalHitTurns = totalHitTurns + 1;
%                         successAttempts(totalHitTurns).maxPos = max(trials(i).pos(zeroStartIdx(j) : zeroEndIdx(j)));
%                         successAttempts(totalHitTurns).maxVel = max(trials(i).vel(zeroStartIdx(j) : zeroEndIdx(j)));
%                         timeStore(i) =sampleTime * (hitIdx - zeroStartIdx(j)); % store successful relative hit time
%                         maxVelStore(i) = max(trials(i).vel(zeroStartIdx(j) - dataPrior : zeroEndIdx(j))); % store successful max velocity in turn
%                         
%                         
%                         
%                     elseif zeroEndIdx(j) <= postIdx && zeroStartIdx(j) < zeroEndIdx(j) && zeroStartIdx(j) > (1 + dataPrior) && abs(max(trials(i).pos(zeroStartIdx(j) : zeroEndIdx(j))))> 5 && trials(i).pos(zeroStartIdx(j)) == 0 %
%                         %figure(g)
%                         totalFailedTurns = totalFailedTurns + 1;
%                         failedAttempts(totalFailedTurns).pos = trials(i).pos(zeroStartIdx(j) - dataPrior : zeroEndIdx(j));
%                         failedAttempts(totalFailedTurns).vel = trials(i).vel(zeroStartIdx(j) - dataPrior : zeroEndIdx(j));
%                         failedAttempts(totalFailedTurns).maxPos = max(trials(i).pos(zeroStartIdx(j) : zeroEndIdx(j)));
%                         failedAttempts(totalFailedTurns).maxVel = max(trials(i).vel(zeroStartIdx(j) : zeroEndIdx(j)));
%                         failedAttempts(totalFailedTurns).minPos = min(trials(i).pos(zeroStartIdx(j) : zeroEndIdx(j)));
%                         failedAttempts(totalFailedTurns).minVel = min(trials(i).vel(zeroStartIdx(j) : zeroEndIdx(j)));
%                         if abs(max(trials(i).pos(zeroStartIdx(j) : zeroEndIdx(j)))) > trials(i).maxWindow
%                             failedAttempts(totalFailedTurns).aboveFail = 1;
%                         end
%                         if abs(max(trials(i).pos(zeroStartIdx(j) : zeroEndIdx(j)))) < trials(i).minWindow
%                             failedAttempts(totalFailedTurns).aboveFail = 0;
%                         end
%                     end
%                 end
%             end
%             %---POST PLOTTING ANALYSIS---%
%             lowIdx = find(~[failedAttempts(:).aboveFail]); % computes the indices of failed attempts below window
%             highIdx = find([failedAttempts(:).aboveFail]);  % computes the indices of failed attempts above window
%             meanLow = mean([failedAttempts(lowIdx).maxPos]); % computes mean of below window position end of attempt
%             meanHigh = mean([failedAttempts(highIdx).maxPos]); % computes mean of above window position end of attempt
%             stdLow = std([failedAttempts(lowIdx).maxPos]); % computes std of below window position end of attempt
%             stdHigh =  std([failedAttempts(highIdx).maxPos]); % computes std of above window position end of attempt
%             
%             %         totalMissAbove = maxFailTurnNum / totalFailedTurns;
%             %         totalMissBelow = minFailTurnNum / totalFailedTurns;
%             timeStore(timeStore == 0) = [];
%             attemptTurnRate(totalSessions) = length(timeStore) / (totalFailedTurns + length(timeStore));
%             totalHitRate(totalSessions) = length(timeStore) / (length(trials) - nonMoveTrial);
%             failedAttemptsMax(totalSessions) = trials(i).failedAttemptsMax;
%             sessionDate{totalSessions} = trials(i).date;
%             sessionSaveTag{totalSessions} = trials(i).saveTag;
%             totalSessions = totalSessions + 1;
        end
    end
end
ratName = trials(1).subject;
close all
yyaxis right
h = stairs(failedAttemptsMax);

yticks([1:1:max(failedAttemptsMax)])
ylabel('Number of maximum attempts (#)')
xlabel('Session #')
yyaxis left

plot(attemptTurnRate, 'lineWidth', 2)
hold on
yyaxis left
plot(totalHitRate, 'lineWidth', 2)
ylabel('Hit rate')
hold on
ylim([0 1])
plot(attemptTurnRate)
title(['Hit rates for' ratName ' at Various Max Attempt Levels'])
legend({'Attempt hit rate', 'Overall hit rate'})