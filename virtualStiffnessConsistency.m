close all
clear all
saveFig = 0;
velDelay = 4;
totalSessions = 1;
%basedir = 'C:\Users\acors\Documents\trialLogger\RatKnobTask\';
%basesave = 'Z:\SimulinkCode\sldrt-code\training_figures\';
basedir = ['/trialLogger/RATKNOBTASK/'];
% first select subject
ratNameDirAll = dir(basedir);
ratNames = {ratNameDirAll.name};
ratNames= ratNames(3:end); % trim . and .. from filenames
[ratInput_idx,~] = listdlg('PromptString', 'Select a rat to assess virtual stiffness consistency', 'SelectionMode', 'single', 'ListString', ratNames);
subjdir = [basedir ratNames{ratInput_idx} '/'];
sessionDatesDirAll = dir(subjdir);
sessionDates = {sessionDatesDirAll.name};
sessionDates = sessionDates(3:end); % trim . and .. from filenames
totalSessions = 1;
summary.overallDateSession = [];
summary.windowTotal = [];
choice = questdlg('Would you like to set constraints on selected data?', 'Analysis Selector', 'Yes', 'No', 'Cancel', 'Cancel');
if strcmp(choice, 'Yes')
    prompt = {'ThetaTarget', 'WindowSize', 'pertMagnitude (mA)'};
    answer = inputdlg(prompt, 'Enter constraints', 1, {'40', '30', '21'});
    thetaTarget = str2num(answer{1});
    windowSize = str2num(answer{2});
    pertMagnitude = str2num(answer{3});
    constraints = 1;
else
    constraints = 0;
end
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
        if constraints
            if trials(1).pertMagnitude == pertMagnitude && trials(1).thetaTarget == thetaTarget && trials(1).windowSize == windowSize
                proceedAnalysis = 1;
            else
                proceedAnalysis = 0;
            end
        else
            proceedAnalysis = 1;
        end
        if proceedAnalysis
            for i = 1:length(trials)
                
                if trials(i).hitTrial
                    zeroStartIdx = find(diff(double(trials(i).zeroVelFlag)) == -1); % turn beginss
                    zeroIdxEnd = find(double(diff(trials(i).zeroVelFlag)) == 1); % turn ends
                    postIdx = find(trials(i).state == 5, 1) - 1; % find the end of the trial phase idx (right before post-trial)
                    % get rid of all idx in zero past this
                    hitTurnIdx = zeroStartIdx(zeroStartIdx < postIdx);
                    % find the closest zeroidx to postidx
                    minVals = abs(hitTurnIdx - postIdx);
                    [~, idx] = min(minVals);
                    startIdx = zeroStartIdx(idx);
                    % find the idx of the ending of the turn
                    endIdx = zeroIdxEnd(zeroIdxEnd > startIdx);
                    minVals = abs(startIdx - endIdx);
                    [~, idx] = min(minVals);
                    endIdx = endIdx(idx);
                    hitIdx = find(trials(i).eventData_time == trials(i).trialData_time) - 1; % the hit actually occurs the previous index because the feed happens in posttrial
                    startTurnTime = trials(i).trialData_time(startIdx);
                    timeRelTurnStart = trials(i).eventData_time - startTurnTime - velDelay; % we have to account for the filtering delay when finding the relative turn start
                    timeStore(i) = timeRelTurnStart;
                end
            end
        end
        timeStore(timeStore == 0) = [];
        summary.dateSession{totalSessions} = num2str(trials(1).dateTimeTag);
        summary.overallDateSession = [summary.overallDateSession [trials.dateTimeTag]];
        summary.mean(totalSessions) = mean(timeStore);
        summary.std(totalSessions) = std(timeStore);
        totalSessions = totalSessions + 1;
    end
end

dn = datenum(summary.dateSession, 'yyyymmddHHMMSS');
% for i = 1:length(summary.dateSession)
%     dn{i} = datenum(summary.dateSession, 'yyyymmddHHMMSS');
% end
% dnOverall = cell(length(summary.overallDateSession),1);
% for i = 1:length(summary.overallDateSession)
%     dnOverall{i} = datenum(num2str(summary.overallDateSession), 'yyyymmddHHMMSS');
% end
summary.mean(isnan(summary.mean)) = [];
summary.std(isnan(summary.std)) = [];
errorbar(1:1:length(summary.mean), summary.mean, summary.std, 'LineWidth', 2)
% datetick('x', 'keepticks', 'keeplimits')
xlim([0, length(summary.mean) + 1])
xlabel('Session Number')
ylabel('Mean session time to hit (ms)')
title('BRIDGET Comparison of session hit latency')
set(gca, 'FontSize', 24)
