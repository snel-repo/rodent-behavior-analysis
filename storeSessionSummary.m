close all
clear all
saveFig = 0;
%basedir = 'C:\Users\acors\Documents\trialLogger\RatKnobTask\';
basesave = 'Z:\SimulinkCode\sldrt-code\training_figures\';
basedir = ['/trialLogger/RATKNOBTASK/'];
% first select subject
ratNameDirAll = dir(basedir);
ratNames = {ratNameDirAll.name};
ratNames= ratNames(3:end); % trim . and .. from filenames
[ratInput_idx,~] = listdlg('PromptString', 'Select a rat to create session summaries', 'SelectionMode', 'single', 'ListString', ratNames);
subjdir = [basedir ratNames{ratInput_idx} '/'];
sessionDatesDirAll = dir(subjdir);
sessionDates = {sessionDatesDirAll.name};
sessionDates = sessionDates(3:end); % trim . and .. from filenames
totalSessions = 1;
summary.overallDateSession = [];
summary.windowTotal = [];
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
        if ~isempty(trials)
%             summary.hitTotalOverall(totalSessions) = sum([trials.wasHit]);
%             summary.hitRateOverall(totalSessions) = summary.hitTotalOverall(totalSessions) / numel([trials.wasHit]);
%             if sum([trials.pertSession]) ~= 0 
%                 summary.hitTotalPert(totalSessions) = sum([trials.pertHit]);
%                 summary.hitRatePert(totalSessions) = summary.hitTotalPert(totalSessions) / sum([trials.pertEnableTrial]);
%                 summary.hitTotalNonPert(totalSessions) = sum([trials.nonPertHit]);
%                 summary.hitRateNonPert(totalSessions) = summary.hitTotalNonPert(totalSessions) / sum(~[trials.pertEnableTrial]);
%             else
%                 summary.hitTotalPert(totalSessions) = nan;
%                 summary.hitRatePert(totalSessions) = nan;
%                 summary.hitTotalNonPert(totalSessions) = nan;
%                 summary.hitRateNonPert(totalSessions) = nan;
%             end
%             
%             if ~(sum([trials.hitMode])) && isfield(trials, 'maxWindow') % upper + lower window
%                summary.meanWindow(totalSessions) = mean([trials.maxWindow]);
%                summary.windowTotal = [summary.windowTotal [trials.maxWindow]]; 
%             else
%                 summary.meanWindow(totalSessions) = nan;
%                 summary.windowTotal = [summary.windowTotal nan(1,length(trials))];
%             end
            summary.dateSession{totalSessions} = num2str(trials(1).dateTimeTag);
            summary.overallDateSession = [summary.overallDateSession [trials.dateTimeTag]];
            totalSessions = totalSessions + 1;
        end
    end
end

for i = 1:length(summary.dateSession)
    dn{i} = datenum(summary.dateSession, 'yyyymmddHHMMSS');
end
dnOverall = cell(length(summary.overallDateSession),1);
for i = 1:length(summary.overallDateSession)
    dnOverall{i} = datenum(num2str(summary.overallDateSession), 'yyyymmddHHMMSS');
end
filename = [trials(1).subject '_' date];

numFigs = 3; % make this programmatically determined later
% for i = 1:numFigs
%     figName{i} = [basesave num2str(i) '.pdf'];
% end

% make figures 
figure('units','normalized','outerposition',[0 0 1 1])
subplot(2,1,1)
plot(cell2mat(dn), summary.hitTotalOverall, 'lineWidth', 2)
hold on
%plot(cell2mat(dn), summary.hitTotalPert, 'lineWidth', 2, 'color', 'r')
%plot(cell2mat(dn), summary.hitTotalNonPert, 'lineWidth', 2, 'color', 'g')
datetick('x', 'keepticks', 'keeplimits');
xlim([-inf inf])
title('Total hits over sessions')
xlabel('Date')
ylabel('Hits')
set(gca, 'FontSize', 20)
subplot(2,1,2)
plot(cell2mat(dn), summary.hitRateOverall, 'lineWidth', 2)
hold on
%plot(cell2mat(dn), summary.hitRatePert, 'lineWidth', 2, 'color', 'r')
%plot(cell2mat(dn), summary.hitRateNonPert, 'lineWidth', 2, 'color', 'g')
xlim([-inf inf])
datetick('x', 'keepticks', 'keeplimits');
title('Total hit rate over sessions')
xlabel('Date')
ylabel('Hit rate')
set(gca, 'FontSize', 20)
if saveFig
    export_fig([basesave filename], '-append', '-pdf')
end

figure('units','normalized','outerposition',[0 0 1 1])
subplot(2,1,1)
nonNanWindow = find(~isnan(summary.windowTotal), 1);
plot(1:numel(summary.windowTotal(nonNanWindow:end)), summary.windowTotal(nonNanWindow:end), 'lineWidth', 2)
xlim([-inf inf])
ylim([-inf inf])
%datetick('x', 'dd/yy HH:MM', 'keepticks');
xlabel('Trial #')
ylabel('Upper window value (deg)')
title('Trial-by-trial upper window value')
set(gca, 'FontSize', 20)

subplot(2,1,2)
plot(cell2mat(dn), summary.meanWindow, 'lineWidth', 2)
xlim([-inf inf])
datetick('x', 'dd/yy HH:MM', 'keepticks');
title('Mean upper window value over sessions')
xlabel('Date')
ylabel('Mean upper window (deg)')
set(gca, 'FontSize', 20)
if saveFig
    export_fig([basesave filename], '-append', '-pdf')
end


figure('units','normalized','outerposition',[0 0 1 1])
subplot(2,1,1)
p1 = plot(cell2mat(dn), summary.hitTotalPert, 'lineWidth', 2, 'color', 'g');
hold on
p2 = plot(cell2mat(dn), summary.hitTotalNonPert, 'lineWidth', 2, 'color', 'b');
datetick('x', 'dd/yy HH:MM', 'keepticks');
%legend([p1 p2], 'Perturbed', 'Unperturbed')
xlim([-inf inf])
title('Total hits for perturbed sessions only')
xlabel('Date')
ylabel('Hits')
set(gca, 'FontSize', 20)
subplot(2,1,2)
p1 = plot(cell2mat(dn), summary.hitRatePert, 'lineWidth', 2, 'color', 'g');
hold on
p2 = plot(cell2mat(dn), summary.hitRateNonPert, 'lineWidth', 2, 'color', 'b');
%legend([p1 p2], 'Perturbed', 'Unperturbed')
datetick('x', 'dd/yy HH:MM', 'keepticks');
xlim([-inf inf])
title('Total hit rate for perturbed sessions only')
xlabel('Date')
ylabel('Hit rate')
set(gca, 'FontSize', 20)
if saveFig
    export_fig([basesave filename], '-append', '-pdf')
end


% now, append figures
%append_pdfs([basesave filename], figName{:});