%function tracePlotterAllSessions
close all
clear failedAttemptsMax
totalSessions = 1;
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
        if isfield(trials(1), 'trialResetType') && trials(1).trialResetType == 2
            [attempts, trials, session] = attemptPreprocess(trials);
            attemptTurnRate(totalSessions) = session.attemptHitRate;
            totalHitRate(totalSessions) = session.overallHitRateCorrected;
            sessionDate{totalSessions} = trials(1).date;
            sessionSaveTag{totalSessions} = trials(1).saveTag;
            failedAttemptsMax(totalSessions) = trials(1).failedAttemptsMax;
            attemptArray(totalSessions) = attempts;
            trialsArray(totalSessions) = trials;
            sessionArray(totalSessions) = session;
            totalSessions = totalSessions + 1;
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