% change basedir to the directory right before the subject name folder
basedir = ['/trialLogger/RatKnobTask/'];
% first select subject
ratNameDirAll = dir(basedir);
ratNames = {ratNameDirAll.name};
ratNames= ratNames(3:end); % trim . and .. from filenames
[ratInput_idx,~] = listdlg('PromptString', 'Select a rat', 'SelectionMode', 'single', 'ListString', ratNames);
subjdir = [basedir ratNames{ratInput_idx} '/'];
% next select session date
sessionDatesDirAll = dir(subjdir);
sessionDates = {sessionDatesDirAll.name};
sessionDates = sessionDates(3:end); % trim . and .. from filenames
[dateInput_idx,~] = listdlg('PromptString', 'Select a date', 'SelectionMode', 'single', 'ListString', sessionDates);
sessiondir = [subjdir sessionDates{dateInput_idx} '/1/'];
% next select session time (morning or afternoon)
sessionTimeDirAll = dir(sessiondir);
sessionTime = {sessionTimeDirAll.name};
sessionTime = sessionTime(3:end); % trim . and .. from filenames
convSessionTime = regexprep(sessionTime, 'saveTag001', 'Morning');
convSessionTime = regexprep(convSessionTime, 'saveTag002', 'Afternoon');
[timeInput_idx,~] = listdlg('PromptString', 'Select a session time', 'SelectionMode', 'single', 'ListString', convSessionTime);
dataDir = [sessiondir sessionTime{timeInput_idx} '/'];
% next ask if trajectories should be plotted for the session
plotTrajDlg = questdlg('Would you like to plot trajectories?');
%basedir = ['/trialLogger/RatKnobTask/BRIDGET/2017-06-20/1/saveTag002/'];
%basedir = [pwd '\dataStore\TESTDATALINUX\'];
files = dir([dataDir '*.mat']);
trialCell = cell(length(files), 1);
for iF = 1:length(files)
    data = load([dataDir files(iF).name], 'trial');
    trialCell{iF} = data.trial;
end

%R = structcat(trialCell{:});
hitTotal = 0;
for i = 1:length(trialCell)
    hitTrialExist = isfield(trialCell{i}, 'hitTrial');
    if hitTrialExist == 1 && ~isempty(trialCell{i}.hitTrial) && trialCell{i}.hitTrial == 1
        hitTotal = hitTotal + 1;
    end
end
fprintf('\n++++++++SESSION SUMMARY+++++++\n');
fprintf('Rat name: %s\n', ratNames{ratInput_idx});
fprintf('Session date: %s\n', sessionDates{dateInput_idx});
fprintf('Session time: %s\n', convSessionTime{timeInput_idx});
fprintf('Total pellets dispensed: %d\n', hitTotal);
fprintf('Total trials: %d\n', length(trialCell));
fprintf('Hit rate: %0.2f\n', hitTotal / length(trialCell));
fprintf('Plot trajectories: %s\n', plotTrajDlg);
% first extract data for hits and misses

if strcmp(plotTrajDlg, 'Yes')
    posHit_idx = 1;
    velHit_idx = 1;
    feedTraj_idx = 1;
    posMiss_idx = 1;
    velMiss_idx = 1;
    for i = 2:length(trialCell)
        pretrial_idx = find(trialCell{i}.state == state.TRIAL ,1); % find time index that trial first enters PRETRIAL (movement of knob)
        feedTime_idx = find(trialCell{i}.feederOut == 0); % a 0 is a feed
        if trialCell{i}.hitTrial == 1 % trial is a hit
            extractData.posHit{posHit_idx} = trialCell{i}.pos(pretrial_idx : end - 3);
            extractData.velHit{velHit_idx} = trialCell{i}.vel(pretrial_idx : end - 3);
            % find when the feed occurred relative to trial init
            feedTimeRelative = trialCell{i}.eventData_time(feedTime_idx) - trialCell{i}.trialData_time(pretrial_idx);
            % find idx of feed time in trialData
            feedPosTrial_idx = find(trialCell{i}.trialData_time == trialCell{i}.eventData_time(feedTime_idx)); % find index of position during feed
            % find value of trial position at feed time
            extractData.feedPosTrial{feedTraj_idx} = [feedTimeRelative, trialCell{i}.pos(feedPosTrial_idx)];
            %extractData.feederOut{feederOut_idx}= [trialCell{i}.trialData_time(feedTime_idx) - trialCell{i}.trialData_time(pretrial_idx) + 1, trialCell{i}.pos(1+ trialCell{i}.eventData_time(feedTime_idx))];
            posHit_idx = posHit_idx + 1;
            velHit_idx = velHit_idx + 1;
            feedTraj_idx = feedTraj_idx + 1;
        else % trial is a miss
            extractData.posMiss{posMiss_idx} = trialCell{i}.pos(pretrial_idx : end - 3);
            extractData.velMiss{velMiss_idx} = trialCell{i}.vel(pretrial_idx : end - 3);
            posMiss_idx = posMiss_idx + 1;
            velMiss_idx = velMiss_idx + 1;
        end
    end
    
    % then, plot the trajectories
    close all
    hitThresh = 5;
    figure;
    for i = 1 : length(extractData.posHit) % plot all hit trials
        subplot(2,1,1)
        plot(extractData.posHit{i}, 'b')
        title('Knob angle trajectories during lower thresh only task (thresh = 45 deg)')
        xlabel('Time (ms)')
        ylabel('Angle (deg)')
        hold on
        subplot(2,1,2)
        plot(extractData.velHit{i}, 'b')
        title('Knob velocity trajectories during lower thresh only task')
        xlabel('Time (ms)')
        ylabel('Velocity (deg / s)')
        hold on
    end
    
    for i = 1 : length(extractData.posMiss) % plot all hit trials
        subplot(2,1,1)
        plot(extractData.posMiss{i}, 'r')
        hold on
        subplot(2,1,2)
        plot(extractData.velMiss{i}, 'r')
        hold on
    end
    
    % plot feed times separately, so that they'll plot above all other lines
    
    subplot(2,1,1)
    plot(get(gca,'xlim'), [hitThresh hitThresh], '--k', 'lineWidth', 2)
    hold on
    plot(get(gca,'xlim'), [-hitThresh -hitThresh], '--k', 'lineWidth', 2)
    
    for i = 1 : length(extractData.posHit)
        subplot(2,1,1)
        scatter(extractData.feedPosTrial{i}(1), extractData.feedPosTrial{i}(2), '+g')
    end
end