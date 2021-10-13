%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Authors: ...
% Purpose: ...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage:
%   0) ...
%


%% Pull rat names for user to select
function [trials] = paramEstimation(varargin)

clear all
close all

load('freespin_data.mat');

for ratIdx=loopedRatNames' % loop through the chosen rat ID's
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%  Get the rat's data directories, sorted by date   %%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    modCntr = mod(plotcntr,numSessEachRat); % this will count proper number of trials per rat
    if modCntr==0 % check for first call of each rat (for efficiency we don't want to do these things on every single loop for the same rat)
        subjdir = [basedir ratNames{ratIdx} filesep]; % create a new string with the subject directory
        subjectFolderDatesDirAll = dir(subjdir);
        subjectFolderDates = {subjectFolderDatesDirAll.name};
        [~,sortedDate_idx] = sort([subjectFolderDatesDirAll.datenum],'descend'); % get sorted idx's
        sortedSessionDatesDirAll = subjectFolderDatesDirAll(sortedDate_idx); % use idx's to sort the entire struct
        validSortedDate_idx = ~strncmp('.',{sortedSessionDatesDirAll(:).name},1).*sortedDate_idx; %find folders without leading '.', deselect them by logical indexing
        nonzeroValidSortedDate_idx = nonzeros(validSortedDate_idx); % just remove zeros. This is now the indexes you can plug into the original sessionDatesDirAll
        sessionDates = subjectFolderDates(nonzeroValidSortedDate_idx);
    end
    if nargin == 0 % Original Mode
        try
            sessionDates = sessionDates(1:2); % hardcoded, gets the entered # days worth of date files
        catch
            sessionDates = sessionDates(1);
        end
    elseif flexMode % Flex Mode , NEED TO ADD COMMENTS TO BELOW CODE BLOCK
        selectedDateFolder = [subjdir sessionDates{1} filesep '1'];
        if modCntr==0
            sessionsFromSelectedDateFolder = dir(selectedDateFolder);
            validSessionsFromSelectedDateFolder = sessionsFromSelectedDateFolder(~strncmp('.',{sessionsFromSelectedDateFolder(:).name},1)); % remove folders beginning with '.'
            sessionsFound = cell(1,length(validSessionsFromSelectedDateFolder));
            [sessionsFound{:}] = deal([selectedDateFolder filesep]);
            numSessFound = length(sessionsFound);
            for iSess = 1:numSessFound
                sessionsFound{iSess} = [sessionsFound{iSess} validSessionsFromSelectedDateFolder(iSess).name filesep];
            end
            if numSessFound < numSessEachRat
                sessionDates = sessionDates(1:2+modCntr); % Increase each loop, if this is ever needed
            else
                sessionDates = sessionDates(1); % we got enough session files already
            end
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%     Original Mode with GUI selection    %%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if nargin == 0
        
        tmpProtocolDir = cell(1, length(sessionDates));
        [tmpProtocolDir{:}] = deal([filesep '1' filesep]); % deal can be used similarly to repmat for strings
        sessionDatesFullPath = strcat(sessionDates, tmpProtocolDir); % this combines the session date string with the '/1/' string to get past protocol number directory
        tmpSubjPath = cell(1, length(sessionDates));
        [tmpSubjPath{:}] = deal(subjdir); % creates a copy of the subject directory
        fullRatDatePaths = strcat(tmpSubjPath, sessionDatesFullPath);
        fullRatDatePathsTrunc = fullRatDatePaths(~cellfun(@(x) any(isletter(x)),sessionDatesFullPath)); %check for any letters in filenames, cause warning
        
        if any(isletter([sessionDatesFullPath{:}])) % remove folders with wrong name formats. They must not have letters in the folder names.
            warning('The following folders were de-selected because their folders contained letters. (This would''ve caused another error)')
            disp(sessionDatesFullPath(cellfun(@(x) any(isletter(x)),sessionDatesFullPath)))
            sessionDates = sessionDates(1:length(fullRatDatePathsTrunc));
            if isempty(sessionDates)
                warning('Some files contained letters, and were de-selected by cellfun, this empied the list of rat folders')
            end
        end
        
        if isempty(fullRatDatePathsTrunc)
            error('The only selected folder could not be loaded, and was de-selected. Quitting.')
        end
        [taskMode] = extractTaskModes(fullRatDatePathsTrunc, sessionDates);
        uniqueTaskMode = unique({taskMode(:).taskModeEnum});
        dateAndSaveTagString = strcat({taskMode(:).date}, ' : ', {taskMode(:).saveTag});
        %[taskInput_idx, ~] = listdlg('PromptString', 'Select a task for this animal to analyze', 'SelectionMode', 'single', 'ListString', uniqueTaskMode, 'ListSize', [300 300]);
        %validSessions = strcmp(uniqueTaskMode{taskInput_idx}, {taskMode(:).taskModeEnum});
        validSessions = strcmp('FREE_SPIN', {taskMode(:).taskModeEnum});
        [sessionInput_idx, ~] = listdlg('PromptString', 'Select sessions to analyze', 'ListString', dateAndSaveTagString(validSessions),  'ListSize', [300 300]);
        sessionDateAndSaveTag = dateAndSaveTagString(validSessions);
        selectedTaskMode = taskMode(validSessions);
        selectedTaskMode = selectedTaskMode(sessionInput_idx);
        selectedSessions = {selectedTaskMode(:).path};
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%       Flexible Input Mode with CLI      %%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    elseif flexMode % if 1, 2, or 3 user inputs, flexible input mode
        selectedSessions = flip(sessionsFound(modCntr+1));
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    trials = selectedSessionsToTrials(selectedSessions);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%     Plot relevant variables      %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    trial_cond = zeros(numel(trials.trials),1);
    accel_start_index = zeros(numel(trials.trials),1);
    accel_end_index = zeros(numel(trials.trials),1);
    decel_start_index = zeros(numel(trials.trials),1);
    decel_end_index = zeros(numel(trials.trials),1);
    
    
    % plot command current
    figure()
    for i = 1:numel(trials.trials)
    
        trial = trials.trials(i);
        
        mot_dir = double(2*trial.dirMotor)-1;
        motorCurrent = mot_dir.*trial.motorCurrent;
        
        trial_cond(i) = motorCurrent(1500);

        color_trial = [(40-trial_cond(i))/80,0,(trial_cond(i)+40)/80];
        
        plot(trial.trialData_time, motorCurrent, 'Color', color_trial);
        
        %accel_start_index(i) = find(motorCurrent ~= 0, 1);
        accel_start_index(i) = find(abs(trial.velRaw) > 10, 1);
        
        xlabel('time [ms]')
        ylabel('Motor current command [mA]')
    
    end
    
    % plot acceleration velocity
    figure()
    for i = 1:numel(trials.trials)
    
        trial = trials.trials(i);
        
        color_trial = [(40-trial_cond(i))/80,0,(trial_cond(i)+40)/80];
        
        ii = find(abs(trial.velRaw)>3000, 1);
        if length(ii) > 0 
            accel_end_index(i) = ii;
            plot(trial.trialData_time(accel_start_index(i):accel_end_index(i)), pi*trial.velRaw(accel_start_index(i):accel_end_index(i))/180, 'Color', color_trial)
            hold on
        else
            accel_end_index(i) = accel_start_index(i) + 100;
        end
        
        %accel_end_index(i) = find(abs(trial.velRaw)>3000, 1);
        
        xlabel('time [ms]')
        ylabel('Velocity [rad/s]')
        
          
    end
 
    % plot deceleration velocity
    for i = 1:numel(trials.trials)
        
        trial = trials.trials(i);
        
        decel_start_index(i) = find(abs(trial.velRaw(2450:end))<3000, 1) + 2450;
        sign_pre = sign(trial.velRaw(2450:end-1));
        sign_pos = sign(trial.velRaw(2450+1:end));
        %decel_end_index(i) = find((sign_pre ~= sign_pos) ~= 0, 1) + 2450
        %decel_end_index(i) = find(abs(trial.velRaw(2450:end))<10, 1);
        decel_end_index(i) = decel_start_index(i)+20;
    end
    
    
    figure()
    for i = 1:numel(trials.trials)
    
        trial = trials.trials(i);
        
        color_trial = [(40-trial_cond(i))/80,0,(trial_cond(i)+40)/80];
        
        plot(trial.trialData_time(decel_start_index(i):decel_end_index(i)), pi*trial.velRaw(decel_start_index(i):decel_end_index(i))/180, 'Color', color_trial)
        hold on
    
        xlabel('time [ms]')
        ylabel('Velocity [rad/s]')
        
    end
    
    
    % plot escon current measurement
    figure()
    for i = 1:numel(trials.trials)
    
        trial = trials.trials(i);
        
        color_trial = [(40-trial_cond(i))/80,0,(trial_cond(i)+40)/80];
        
        plot(trial.trialData_time(accel_start_index(i):accel_end_index(i)), trial.currentMeasEscon(accel_start_index(i):accel_end_index(i)), 'Color', color_trial)
        hold on
    
        xlabel('time [ms]')
        ylabel('Measured motor current (ESCON) [A]')
        
    end
    
    % plot shunt current measurement
    figure()
    for i = 1:numel(trials.trials)
    
        trial = trials.trials(i);
        
        color_trial = [(40-trial_cond(i))/80,0,(trial_cond(i)+40)/80];
        
        %plot(trial.trialData_time(accel_start_index(i):accel_end_index(i)), trial.currentMeasShunt(accel_start_index(i):accel_end_index(i)), 'Color', color_trial)
        plot(trial.currentMeasShunt(1:accel_end_index(i)), 'Color', color_trial)
        hold on

        xlabel('time [ms]')
        ylabel('Measured motor current (shunt) [A]')
        
        
    end
    
    % plot both current measurements
    figure()
    for i = 1:numel(trials.trials)
    
        trial = trials.trials(i);
        
        color_trial = [(40-trial_cond(i))/80,0,(trial_cond(i)+40)/80];
        
        plot(trial.trialData_time(), trial.currentMeasShunt(), 'Color', color_trial)
        hold on
        plot(trial.trialData_time(), trial.currentMeasEscon(), '--', 'Color', color_trial)

        xlabel('time [ms]')
        ylabel('Measured motor current (shunt) [A]')
        
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%     Compute torque parameters relevant variables      %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    close all
    
    k_mot = 36 * 1/1000;  
    ts = 0.002;
    
    y_full = [];
    y_accel = [];
    y_decel = [];

    x_mot_full = [];
    x_mot_accel = [];
    x_mot_decel = [];
    
    sign_fric_accel = [];
    sign_fric_decel = [];
    
    for i = 1:numel(trials.trials)
    
        trial = trials.trials(i);
        
        color_trial = [(40-trial_cond(i))/80,0,(trial_cond(i)+40)/80];
        
        %plot(trial.trialData_time(accel_start_index(i):accel_end_index(i)), trial.currentMeasShunt(accel_start_index(i):accel_end_index(i)), 'Color', color_trial)
        %hold on
        %xlabel('time [ms]')
        %ylabel('Measured motor current (shunt) [A]')
        
        i_mot_i = trial.currentMeasShunt(accel_start_index(i):accel_end_index(i)-1);
        i_mot_i = i_mot_i - trial.currentMeasShunt(1);
        i_mot_i = -i_mot_i;

%         i_mot_i = trial.currentMeasEscon(accel_start_index(i):accel_end_index(i)-1);
%         i_mot_i = i_mot_i - trial.currentMeasEscon(1);
        
        vel_i = pi*trial.velRaw(accel_start_index(i):accel_end_index(i))/180;
        accel_i = diff(vel_i)/ts;
        
        sign_fric_accel_i = -sign(vel_i(end))*ones(size(i_mot_i));
        
        if length(find(abs(vel_i)>80)) == 0 && length(vel_i)>80 == 0 && abs(vel_i(end))>50
            x_mot_accel = [x_mot_accel; i_mot_i];       
            y_accel = [y_accel; accel_i];
            %sign_fric_accel = [sign_fric_accel; sign_fric_accel_i];
            
            if sign(vel_i(1)) > 0 
                sign_fric_accel = [sign_fric_accel; [sign_fric_accel_i, zeros(size(sign_fric_accel_i))]];
            else
                sign_fric_accel = [sign_fric_accel; [zeros(size(sign_fric_accel_i)), sign_fric_accel_i]];
            end
            
            figure(1)
            plot(i_mot_i);
            hold on

            figure(2)
            plot(vel_i);
            hold on
            %plot(sign_fric_accel_i,'k')
            
        end
        
        i_mot_i = trial.currentMeasShunt(decel_start_index(i):decel_end_index(i)-1);
        i_mot_i = i_mot_i - trial.currentMeasShunt(1);
        i_mot_i = -i_mot_i;
        
%         i_mot_i = trial.currentMeasEscon(decel_start_index(i):decel_end_index(i)-1);
%         i_mot_i = i_mot_i - trial.currentMeasEscon(1);

%         figure(3)
%         plot(i_mot_i);
%         hold on
        
        vel_i = pi*trial.velRaw(decel_start_index(i):decel_end_index(i))/180;
        decel_i = diff(vel_i)/ts;
        
        sign_fric_decel_i = -sign(vel_i(1))*ones(size(i_mot_i));
        
        if abs(vel_i(1))>40 && length(find(abs(vel_i)>80)) == 0
        
            x_mot_decel = [x_mot_decel; i_mot_i];        
            y_decel = [y_decel; decel_i];

            if sign(vel_i(1)) > 0 
                sign_fric_decel = [sign_fric_decel; [sign_fric_decel_i, zeros(size(sign_fric_decel_i))]];
            else
                sign_fric_decel = [sign_fric_decel; [zeros(size(sign_fric_decel_i)), sign_fric_decel_i]];
            end
             
            
            figure(4)
            plot(vel_i);
            hold on
            %plot(sign_fric_decel_i,'k')
        
        end
        

        
    end
    
    %figure
    %plot(x_mot_accel)
    
    X_mot_accel = [k_mot*x_mot_accel, sign_fric_accel];
    
    %figure
    %plot(y_accel)
    
    %figure
    %plot(x_mot_decel)
    
    X_mot_decel = [k_mot*x_mot_decel, sign_fric_decel];
    
    %figure
    %plot(y_decel)
    
    X = [X_mot_accel; X_mot_decel];
    y = [y_accel; y_decel];
    
    %X = [X_mot_decel];
    %y = [y_decel];
    
    %X = [X_mot_accel];
    %y = [y_accel];
    
    theta = inv(X'*X)*X'*y

    I_net = theta(1)^(-1)
    T_fri_mag_pos = theta(2)/theta(1)
    T_fri_mag_neg = theta(3)/theta(1)

    %% analysis

    rmse = (mean((X*theta - y).^2)).^(0.5)

    figure()
    plot(y_accel)
    hold on
    plot(X_mot_accel*theta)
    legend({'Measured','Prediction'});
    xlabel('Sample # (concatenated trials)') 
    ylabel('Knob Acceleration [rad/s^2]') 
    title('Measured v/s predicted acceleration, for acceleration trials (speed 0-50 rad/s)')

    figure()
    plot(y_decel)
    hold on
    plot(X_mot_decel*theta)
    legend({'Measured','Prediction'});
    xlabel('Sample # (concatenated trials)') 
    ylabel('Knob Acceleration [rad/s^2]') 
    title('Measured v/s predicted acceleration, for deceleration trials (speed 50-0 rad/s)')

    T_in_accel = I_net*y_accel - k_mot*x_mot_accel - sign_fric_accel*[T_fri_mag_pos; T_fri_mag_neg];
    T_in_decel = I_net*y_decel - k_mot*x_mot_decel - sign_fric_decel*[T_fri_mag_pos; T_fri_mag_neg];

    figure()
    plot(T_in_accel,'Linewidth',1)
    %figure()
    hold on
    plot(T_in_decel,'Linewidth',1)
    plot(0.036*0.02*ones(1,length(T_in_accel)),'k--','Linewidth',1)
    hold on
    legend({'Accel. 0-50 rad/s','Decel. 50-0 rad/s','Motor torque at 20mA'});
    xlabel('Sample # (concatenated trials)') 
    ylabel('Estimated external torque [N]') 
    title('Estimated external torque (should be 0)')    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%     Choose analysis based on selected taskMode or User input      %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     sessionSaveTag = string(trials.trials(modCntr+1).saveTag);
%     sessionDateTime = char(datetime(string(trials.trials(1).dateTimeTag), 'InputFormat', 'yyyyMMddHHmmss','Format', 'yyyy-MM-dd, HH:mm:ss'));
%     sessionDateTimeAndSaveTag = [sessionDateTime ' - SaveTag: ' char(sessionSaveTag)];
%     pngPath = [basedir(1:end-1) '_PNGfiles' filesep sessionDateTime(1:10) filesep];
%     if flexMode == true && ~strcmp(plotStr,'noplot')
%         switch plotStr 
%             case 'scat'
%                 ratScatter(trials, ratNames{ratIdx}, sessionDateTimeAndSaveTag, pngFlag, pngPath)
%             case 'cyc'
%                 allTrialFlags=0; iFlag=-1; % loop to check for flags that exist
%                 while(~any(allTrialFlags))
%                     try
%                         [allTrialFlags] = cycleFlags(trials,iFlag);
%                     catch
%                         iFlag = iFlag+1;
%                     end
%                 end
%             case 'kin' % plot knob kinematics
%                 ratKinematics(trials, ratNames(ratIdx), sessionDateTimeAndSaveTag, pngFlag, pngPath)
%             case 'png'
%                 pngFlag = plotStr; % overwrite default 'nopng' value to 'png' so it will skip plotting and save the PNG
%                 ratScatter(trials, ratNames{ratIdx}, sessionDateTimeAndSaveTag, pngFlag, pngPath)
%             case 'force'
%                 ratForces(trials, ratNames(ratIdx), sessionDateTimeAndSaveTag, pngFlag, pngPath)
%             case 'all'
%             otherwise
%                 if strncmpi(plotStr,'kin',3)
%                     failFlag = str2double(plotStr(4:end)); % grab the fail flag suffix from something like "kin16" or "kin09"
%                     ratKinematics(trials, ratNames(ratIdx), sessionDateTimeAndSaveTag, pngFlag, pngPath, failFlag)
%                 end
%         end
%     elseif flexMode == false
%         pngFlag = 'nopng';
%         switch uniqueTaskMode{taskInput_idx}
%             case 'LOWER_THRESHOLD'
%                 trials = analyzeTurnAttempts(trials);
%                 [trials, summary] = analyzeKnobTurn(trials, sessionDateAndSaveTag(sessionInput_idx));
%                 plotKnobTurn(trials, summary);
%             case 'LOWER_THRESHOLD_PERTURBATION'
%                 trials = analyzeTurnAttempts(trials);
%                 [trials, summary] = analyzeKnobTurn(trials, sessionDateAndSaveTag(sessionInput_idx));
%                 plotKnobTurnPerturbation(trials, summary);
%             case 3
%             case {'KNOB_HOLD_RAND_TURN'} % Also 'KNOB_HOLD_CUED_TURN' can be added here
%                 [trials, summary] = analyzeCuedTurn(trials, sessionDateAndSaveTag(sessionInput_idx));
%                 plot_cued_turn(trials, summary)
%                 %[trials, summary] = analyzeKnobTurn(trials, sessionTags(sessionInput_idx));
%                 %plotKnobTurn(trials, summary);
%             case 'RAND_TURN_TWO_TARGETS'
%                 %plotBadGoodTouches_1(trials, ratNames{ratIdx}, sessionTags{sessionInput_idx})
%                 %[trials, summary] = analyzeCuedTurn(trials, sessionTags(sessionInput_idx));
%                 %plotHoldTurnViolin(trials, summary);
%                 plot_rand_turn(trials, summary)
%             case {'KNOB_HOLD_CUED_TURN','KNOB_HOLD_ASSOCIATION', 'KNOB_HOLD_ASSO_NOMIN', 'KNOB_HOLD_CONSOL','KNOB_HOLD_AUTO_TURN', 'FREE_SPIN'}
%                 %ratForces(trials, ratNames(ratIdx), sessionDateTimeAndSaveTag, pngFlag, pngPath)
%                 allTrialFlags=0; iFlag=-1; % loop to check for flags that exist
%                 while(~any(allTrialFlags))
%                     try
%                         [allTrialFlags] = cycleFlags(trials,iFlag);
%                     catch
%                         iFlag = iFlag+1;
%                     end
%                 end
%                 ratKinematics(trials, ratNames(ratIdx), sessionDateTimeAndSaveTag, pngFlag, pngPath)
%                 %plotBadGoodTouches_1(trials, ratNames{ratIdx}, sessionDateAndSaveTag{sessionInput_idx})
%                 %plotDistribution(trials)
%                 %plotBadTouches(trials)
%                 %plotHoldPosMaxAnalysis(trials)
%                 %plotFailFlag16Overlay(trials)
%                 % trials = findHoldIdx(trials);
%                 % summary = analyzeKnobHold(trials, sessionTags(sessionInput_idx)); % creates a session summary for the holding task % FZ commented on 190930
%                 % plotHoldViolin(trials, summary); % creates plots for the holding task to analyze critical data % FZ commented on 190930
%             otherwise
%         end
%     end
%     plotcntr = plotcntr + 1; % increment the counter

end