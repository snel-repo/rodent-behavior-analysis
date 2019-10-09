close all
clear all
% change basedir to the directory right before the subject name folder
timeOfInterest = 500;
basedir = uigetdir([], 'Select rodent data directory (RATKNOBTASK)');
basedir = [basedir '\'];
%---SELECT TYPE OF ANALYSIS (SINGLE SESSION OR MULTI)----%
choice = questdlg('Choose your desired analysis', 'Analysis Selector', 'Single Session', 'LED Association', 'Cancel', 'Single Session');
if strcmp(choice, 'Cancel')
    fprintf('Exiting program.\n')
    return
end
switch choice
    %----SINGLE SESSION ANALYSIS-----%
    case 'Single Session'
        % first select subject
        ratNameDirAll = dir(basedir);
        ratNames = {ratNameDirAll.name};
        ratNames= ratNames(3:end); % trim . and .. from filenames
        try
            [ratInput_idx,~] = listdlg('PromptString', 'Select a rat', 'SelectionMode', 'single', 'ListString', ratNames);
        catch
            fprintf('Failed to pull rat directories. Likely incorrect base directory selected.\n');
            return;
        end
        if isempty(ratInput_idx)
            fprintf('Exiting program.\n')
            return
        end
        subjdir = [basedir ratNames{ratInput_idx} '/'];
        % next select session date
        sessionDatesDirAll = dir(subjdir);
        sessionDates = {sessionDatesDirAll.name};
        sessionDates = sessionDates(3:end); % trim . and .. from filenames
        [dateInput_idx,~] = listdlg('PromptString', 'Select a date', 'SelectionMode', 'single', 'ListString', sessionDates);
        if isempty(dateInput_idx)
            fprintf('Exiting program.\n')
            return
        end
        sessiondir = [subjdir sessionDates{dateInput_idx} '/1/'];
        % next select session time (morning or afternoon)
        sessionTimeDirAll = dir(sessiondir);
        sessionTime = {sessionTimeDirAll.name};
        sessionTime = sessionTime(3:end); % trim . and .. from filenames
        convSessionTime = regexprep(sessionTime, 'saveTag001', 'Morning');
        convSessionTime = regexprep(convSessionTime, 'saveTag002', 'Afternoon');
        [timeInput_idx,~] = listdlg('PromptString', 'Select a session time', 'SelectionMode', 'single', 'ListString', convSessionTime);
        if isempty(timeInput_idx)
            fprintf('Exiting program.\n')
            return
        end
        dataDir = [sessiondir sessionTime{timeInput_idx} '/'];
        % next ask if trajectories should be plotted for the session
        plotTrajDlg = questdlg('Would you like to plot trajectories?');
        
        files = dir([dataDir '*.mat']);
        trialCell = cell(length(files), 1);
        for iF = 1:length(files)
            data = load([dataDir files(iF).name], 'trial');
            trialCell{iF} = data.trial;
        end
        trials = preprocessData(trialCell, files);
        sessionData = extractSessionFeatures(trials, [100 500]);
        trialNum = 1:numel(trials);
        hitTotal = 0;
        hitPertTotal = 0;
        pertTrialTotal = 0;
        trialMissTot = 0;
        sampleTime = trialCell{1}.sampleTime / 1e-3; % sample time in ms
        for i = 1:length(trialCell)
            trialDataEnsure = find(diff(trialCell{i}.trialData_time) ~= 2);
            trialMissTot = trialMissTot + length(trialDataEnsure);
            hitTrialExist = isfield(trialCell{i}, 'hitTrial');
            if hitTrialExist == 1 && ~isempty(trialCell{i}.hitTrial) && trialCell{i}.hitTrial == 1
                if trialCell{i}.pertEnableTrial
                    hitPertTotal = hitPertTotal + 1;
                end
                hitTotal = hitTotal + 1;
            end
            if trialCell{i}.pertEnableTrial
                pertTrialTotal = pertTrialTotal + 1;
            end
        end
        [attempts, trials, session] = attemptPreprocess(trials);
        fprintf('\n++++++++SESSION SUMMARY+++++++\n');
        fprintf('Rat name: %s\n', ratNames{ratInput_idx});
        fprintf('Session date: %s\n', sessionDates{dateInput_idx});
        fprintf('Session time: %s\n', convSessionTime{timeInput_idx});
        fprintf('Total pellets dispensed: %d\n', hitTotal);
        fprintf('Total trials: %d\n', length(trialCell));
        fprintf('Total perturbed trials: %1.0f\n', session.pertTrialTotal)
        fprintf('Total unpertubed trials: %1.0f\n', session.unpertTrialTotal)
        fprintf('Upper window mean value: %0.2f\n', mean([trials.maxWindow]));
        fprintf('Session turn attempt hit rate : %s\n', num2str(round(session.attemptHitRate,2)))
        fprintf('Overall hit rate (corrected for non-movement trials): %s\n', num2str(round(session.overallHitRateCorrected,2)));
        if trialCell{i}.pertEnable
            fprintf('Perturbed trial hit rate: %0.2f\n', session.pertHitRateCorrected);
            fprintf('Unperturbed trial hit rate: %0.2f\n', session.unpertHitRateCorrected);
        else
            fprintf('Perturbed trial hit rate: N/A (perturbations off)\n');
            fprintf('Unperturbed trial hit rate: N/A (perturbations off)\n');
        end
        fprintf('Plot trajectories: %s\n', plotTrajDlg);
        % first extract data for hits and misses
        
        if strcmp(plotTrajDlg, 'Yes')
            prompt = {'How many ms of data prior to trial?'};
            promptTitle = 'Plotting information';
            defaultAnswers = {'100'};
            answer = inputdlg(prompt, promptTitle, 1, defaultAnswers);
            tracePlotter(trials, attempts, session, str2num(answer{1}) / 2)
            %[attemptTrial] = tracePlotter(trials, str2num(answer{1}) / 2);
            %             hitThresh = trialCell{1}.thetaTarget;
            %             pertEnable = trialCell{1}.pertEnable;
            %
            %             if ~pertEnable
            %                 figure;
            %                 plotHitTrajectories(extractData, sampleTime, timeOfInterest);
            %                 subplot(3,1,1)
            %                 if trialCell{1}.hitMode == 0 % window
            %                     plot(get(gca, 'xlim'), [trialCell{1}.thetaTarget, trialCell{1}.thetaTarget], 'lineWidth', 3, 'Color', 'k', 'lineStyle', '--')
            %                     plot(get(gca, 'xlim'), [trialCell{1}.thetaTarget + trialCell{1}.windowSize,  trialCell{1}.thetaTarget + trialCell{1}.windowSize], 'lineWidth', 3, 'Color', 'k', 'LineStyle',  '--')
            %                 end
            %                 % plot feed times separately, so that they'll plot above all other lines
            %                 for i = 1 : length(extractData.posHit)
            %                     scatter(extractData.feedPosTrial{i}(1), extractData.feedPosTrial{i}(2), '+m')
            %                 end
            %                 figure;
            %                 %plotHitTrajectories(extractData, sampleTime, timeOfInterest);
            %                 plotMissTrajectories(extractData, sampleTime, timeOfInterest);
            %                 if ~trialCell{1}.hitMode
            %                     figure
            %                     plotWindowMaxAngles(trials);
            %                     figure
            %                     plotWindowMaxAnglesWithMisses(trials);
            %                 end
            %             else % if perturbations on
            %                 figure;
            %                 plotNoPertHit(sessionData,timeOfInterest)
            %                 plotPertMiss(sessionData, timeOfInterest)
            %                 plotNoPertMiss(sessionData, timeOfInterest)
            %                 plotPertHit(sessionData, timeOfInterest)
            %
            %                 figure
            %                 plotNoPertHit(sessionData, timeOfInterest)
            %                 plotPertMiss(sessionData, timeOfInterest)
            %                 plotPertHit(sessionData, timeOfInterest)
            %
            %                 figure
            %
            %                  plotNoPertHit(sessionData, timeOfInterest)
            %                 plotPertHit(sessionData, timeOfInterest)
            %                 %plotNoPertHitSmooth(sessionData, timeOfInterest)
            %                 %plotPertHitSmooth(sessionData, timeOfInterest)
            %             end
        end
    case 'Multi-session'
        %----MULTI SESSION ANALYSIS----%
        %----EXTRACT DATA----%
        % first select subject
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
                    sessionData(sessionCounter).session = extractSessionFeatures(trials, [50 250]);
                    sessionCounter = sessionCounter + 1;
                end
            end
        end
        fprintf('COMPLETE\n');
        fprintf('Plotting session data...\n');
        %---PLOT MULTI-SESSION ANALYSIS---%
        subjectAndDate = [sessionData(1).session.subject];
        PertUnpertHitID = importdata('Pert_Unpert_Hit_Only_IDs.txt');
        AllPertID = importdata('All_Pert_IDs.txt');
        for i  = 1:length(sessionData) % run through each session and plot extracted data
            %---PLOT OVERALL PERFORMANCE PLOTS----%
            %             figure;
            %             plotHitTrajectories(sessionData(i).session, timeOfInterest)
            %             plotMissTrajectories(sessionData(i).session, timeOfInterest)
            %             close all
            %----PLOT PERTURBED PERFORMANCE----%
            if ~isnan(sessionData(i).session.pertMagnitude) % is a perturbed session
                uniqueID = [sessionData(i).session.subject '_' sessionData(i).session.date '_' sessionData(i).session.session];
                if ~any(strcmp(uniqueID, AllPertID))
                    close all
                    fid = fopen('All_Pert_IDs.txt', 'a');
                    fprintf(fid, '%s\r\n', uniqueID);
                    fclose(fid);
                    figure('units','normalized','outerposition',[0 0 1 1])
                    plotPertHit(sessionData(i).session, timeOfInterest)
                    plotPertMiss(sessionData(i).session, timeOfInterest)
                    plotNoPertHit(sessionData(i).session, timeOfInterest)
                    plotNoPertMiss(sessionData(i).session, timeOfInterest)
                    subplot(2,2,1)
                    plot(get(gca, 'xlim'), [sessionData(i).session.minWindow, sessionData(i).session.minWindow], 'lineWidth', 3, 'Color', 'k', 'lineStyle', '--')
                    if strcmp(sessionData(i).session.hitMode, 'window') % window
                        plot(get(gca, 'xlim'), [sessionData(i).session.maxWindow,  sessionData(i).session.maxWindow], 'lineWidth', 3, 'Color', 'k', 'LineStyle',  '--')
                    end
                    filename = sprintf('All perturbed task trajectories %s', sessionData(1).session.subject);
                    export_fig([basesave filename], '-append', '-pdf');
                end
                
                if ~any(strcmp(uniqueID, PertUnpertHitID))
                    close all
                    fid = fopen('Pert_Unpert_Hit_Only_IDs.txt', 'a');
                    fprintf(fid, '%s\r\n', uniqueID);
                    fclose(fid);
                    figure('units','normalized','outerposition',[0 0 1 1])
                    plotPertHit(sessionData(i).session, timeOfInterest)
                    plotNoPertHit(sessionData(i).session, timeOfInterest)
                    subplot(2,2,1)
                    plot(get(gca, 'xlim'), [sessionData(i).session.minWindow, sessionData(i).session.minWindow], 'lineWidth', 3, 'Color', 'k', 'lineStyle', '--')
                    if strcmp(sessionData(i).session.hitMode, 'window') % window
                        plot(get(gca, 'xlim'), [sessionData(i).session.maxWindow,  sessionData(i).session.maxWindow], 'lineWidth', 3, 'Color', 'k', 'LineStyle',  '--')
                    end
                    filename = sprintf('Perturbed and unperturbed hit trajectories %s', sessionData(1).session.subject);
                    export_fig([basesave filename], '-append', '-pdf');
                    
                end
                
                
            end
            
            
            
        end
        
    case 'LED Association'
        fprintf('Knob Touching LED Association Selected.\n')
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
                clear trialCell avgTime trialTime sumMiss posStore velStore
                sumMiss = 0;
                dataDir = [sessiondir sessionTime{times} '/'];
                files = dir([dataDir '*.mat']);
                for iF = 1:length(files) % load files for summaries
                    data = load([dataDir files(iF).name], 'trial');
                    trialCell{iF} = data.trial;
                    %
                end
                trials = preprocessData(trialCell, files);
                if ~isempty(trials)
                    for i = 1:length(trials)
                        avgTime(i) = trials(i).rewardDelay + 2 * find(trials(i).state == 3, 1);
                        trialTime(i) = length(find(trials(i).state == 3));
                        hit(i) = trials(i).hitTrial;
                        if isfield(trials(i), 'lastTouchFlag')
                            tempDiff = find(diff(trials(i).lastTouchFlag) == 1);
                            lastTrial = find(trials(i).state == 3);
                            tempDiff(abs(tempDiff - lastTrial(end)) < 100) = [];
                            sumMiss(i) = length(tempDiff);
                            if length(find(trials(i).state == 3)) < 2500
                                trialLen = length(find(trials(i).state == 3));
                            else
                                trialLen = 2500;
                            end
                            posStore{i} = trials(i).pos(find(trials(i).state == 3,1) : find(trials(i).state == 3,1) + trialLen + 150);
                            velStore{i} =  trials(i).vel(find(trials(i).state == 3,1) : find(trials(i).state == 3,1) + trialLen + 150);
                        else
                            sumMiss(i) = NaN;
                            posStore{i} = NaN;
                            velStore{i} = NaN;
                        end
                    end
                    avgTimeAll{sessionCounter} = avgTime;
                    trialTimeAll{sessionCounter} = trialTime;
                    outlierRemovedTrialTime= hampel(trialTime);
                    meanInterTrialTime(sessionCounter) = mean(avgTime);
                    meanTrialTime(sessionCounter) = mean(outlierRemovedTrialTime);
                    totalMiss{sessionCounter} = sumMiss;
                    posStoreFull{sessionCounter} = posStore;
                    velStoreFull{sessionCounter} = velStore;
                    hitAll{sessionCounter} = hit;
                    
                    %                     figure('units','normalized','outerposition',[0 0 1 1])
                    %                     histogram(outlierRemovedTrialTime, 50);
                    %                     xlabel('Duration of trial (LED time, ms)')
                    %                     ylabel('Frequency')
                    %                     title(['Histogram of trial duration (time since LED turned on) ' trials(1).subject])
                    %                     set(gca, 'FontSize', 24)
                    %
                    %                     figure('units','normalized','outerposition',[0 0 1 1])
                    %                     histogram(avgTime, 50)
                    %                     xlabel('Inter-trial period (ms)')
                    %                     ylabel('Frequency')
                    %                     title(['Histogram of inter-trial duration ' trials(1).subject])
                    %                     set(gca, 'FontSize', 24)
                    % sessionData(sessionCounter).session = extractSessionFeatures(trials, [50 250]);
                    sessionCounter = sessionCounter + 1;
                end
            end
        end
        histPlotterMini
        %         fprintf('COMPLETE\n');
        %         fprintf('Plotting session data...\n');
        %         figure
        %         scatter([1:length(meanInterTrialTime)], meanInterTrialTime, 100, 'filled')
        %         set(gca, 'fontSize', 24)
        %         title(['Mean inter-trial time per session for ' trials(1).subject])
        %         xlabel('Session #')
        %         ylabel('Time (ms)')
        %         figure
        %         scatter([1:length(meanTrialTime)], meanTrialTime, 100, 'filled')
        %         set(gca, 'fontSize', 24)
        %         title(['Mean trial time (duration of LED on) per session for ' trials(1).subject])
        %         xlabel('Session #')
        %         ylabel('Time (ms)')
        %         figure
        %         scatter([1:length(totalMiss)], totalMiss, 100, 'filled')
        %         set(gca, 'fontSize', 24)
        %         title(['Total incorrectly timed swipes per session for ' trials(1).subject])
        %         xlabel('Session #')
        %         ylabel('Swipe #s')
    case 'Cancel'
        fprintf('Exiting program.\n')
        return
end