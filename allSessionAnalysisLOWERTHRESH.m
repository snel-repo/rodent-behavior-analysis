clear all

basedir = ['Z:\data\trialLogger\RATKNOBTASK\'];
%basedir = ['/home/snel/mnt/turing/data/trialLogger/RATKNOBTASK/']; % FOR WORK

fprintf('Multi-session Analysis selected.\n')
        sessionCounter = 1;
        ratNameDirAll = dir(basedir);
        ratNames = {ratNameDirAll.name};
        ratNames= ratNames(3:end); % trim . and .. from filenames
        [ratInput_idx,~] = listdlg('PromptString', 'Select a rat to create session summaries', 'SelectionMode', 'single', 'ListString', ratNames);
        %fprintf('Selected rat is %s\n' ratNames{ratInput_idx});
        subjdir = [basedir ratNames{ratInput_idx} '/'];
        sessionDatesDirAll = dir(subjdir);
        sessionDates = {sessionDatesDirAll.name};
        sessionDates = sessionDates(3:end); % trim . and .. from filenames
        fprintf('Extracting data from all sessions...');
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
                    %
                end
                trials = preprocessData(trialCell, files);
                if ~isempty(trials)
                    ssessionData(sessionCounter).session = extractSessionFeatures(trials, [50 250]);
                    sessionCounter = sessionCounter + 1;
                end
            end
        end
        usedSessions = 1;
        for i = 1:length(sessionData)
            

            if sessionData(i).session.trials(1).taskMode == 1 && sessionData(i).session.trials(1).threshMode == 0
                hitRate(usedSessions) = sum([sessionData(i).session.trials(:).wasHit]) / length(sessionData(i).session.trials);
                numTrials(usedSessions) = length(sessionData(i).session.trials);
                medianTurn(usedSessions) = median([sessionData(i).session.trials(:).maxAngleTrialOnly]);
                medianThresh(usedSessions) = median([sessionData(i).session.trials(:).thetaThresh]);
                usedSessions = usedSessions + 1;
            end
        end
        
        close all
        figure
        yyaxis left
        plot(hitRate, '-o', 'lineWidth', 2)
        hold on
        ylabel('Hit Rate')
        yyaxis right
        plot(medianThresh, '-o', 'lineWidth', 2)
        ylabel('Median Threshold Angle for Session (Deg)')
        xlabel('Session Number')    