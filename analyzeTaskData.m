%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Authors: Tony Corsten, Feng Zhu, and Sean O'Connell
% Purpose: this is an automated analysis suite that takes rat name and
% pulls available tasks that rat has completed. You can then select one or
% multiple sessions to produce task-related results and plots.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function Usage:0) analyzeTaskData() <-this will plot with traditional GUI
%
%                1) analyzeTaskData('xy') <-- for rats X and Y (default number of sessions is 1)
%
%                2) analyzeTaskData('ZX',numSessEachRat) <--for rats X and Z
%
%                3) analyzeTaskData('vwxy',numSessEachRat,plotStr) <--
%                     --> plotStr can equal 'scat','kin','cyc', or 'png'
%                         ^^^ set plotStr to 'png' to skip plotting and ^^^
%                         generate png's of the default plot type (scatter)
%
%                4) analyzeTaskData(('xyz',numSessEachRat,plotStr,pngFlag)) <--
%                     --> pngFlag can be set to 'png' this will create a
%                         png in the appropriate folder for the selected
%                         plot type (chosen with plotStr)
%
% By default, PNGs are saved to:
% /snel/share/data/trialLogger/RATKNOBTASK_PNGfiles/[sessionDate]/[ratName]_[plotType].png


%% Pull rat names for user to select
function [] = analyzeTaskData(varargin)

basedir = '/snel/share/data/trialLogger/RATKNOBTASK/'; %removed folder selection GUI entirely - SeanOC
ratDirAll = dir(basedir); % pull full directory of rat name information
ratNames = {ratDirAll.name}; % extract only rat names

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Check for valid user inputs and initialize variables accordingly.   %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin > 4 % check for excess user inputs
    error('Too many input arguments. Try following examples in "help analyzTaskData"')
elseif nargin == 0 % normal GUI function mode if no input argument
    try % instead of erroring, just try/catch if the wrong directory is selected
        [ratInput_idx,~] = listdlg('PromptString', 'Select a rat', 'SelectionMode', 'single', 'ListString', ratNames,  'ListSize', [300 300]); % prompt user to select a rat
    catch
        fprintf('Failed to pull rat directories. Likely incorrect base directory selected.\n');
        return; % return control to user
    end
    if isempty(ratInput_idx) % if cancel is selected instead of a rat, exit program
        fprintf('Exiting program.\n')
        return % return control to user
    end
    totalNumSess=1; numSessEachRat=1; loopedRatNames=ratInput_idx; % allow original mode
    chosenRat_idx=0; flexMode = false; % disable flexible input mode
    
elseif nargin == 1
    ratString = unique(varargin{1}); % a string with 1st letter of each rat wanted
    numSessEachRat = 1;
    plotStr = 'scat'; % scatter plot selected by default
    pngFlag = 'nopng'; % PNG output disabled by default
    
elseif nargin == 2
    ratString = unique(varargin{1}); % A string with 1st letter of each rat wanted
    numSessEachRat = varargin{2};
    plotStr = 'scat'; % scatter plot selected by default
    pngFlag = 'nopng'; % PNG output disabled by default
    
elseif nargin == 3
    ratString = unique(varargin{1}); % a string with 1st letter of each rat wanted
    numSessEachRat = varargin{2};
    plotStr = varargin{3};
    pngFlag = 'nopng'; % PNG output disabled by default
elseif nargin == 4
    ratString = unique(varargin{1}); % a string with 1st letter of each rat wanted
    numSessEachRat = varargin{2};
    plotStr = varargin{3};
    pngFlag = varargin{4}; % PNG output disabled by default
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                    HANDLE FLEXIBLE USER INPUTS                        %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin == 1 || nargin == 2 || nargin == 3
    flexMode = true; % if 1, 2, or 3 user inputs, flexible input mode flag
end

if flexMode % if 1, 2, or 3 user inputs, flexible input mode
    
    numRatLetters = length(ratString);
    totalNumSess = numSessEachRat*numRatLetters;
    
    %collect ordered indexes for most recently edited rat folders
    [~,sortedRat_idx] = sort([ratDirAll.datenum],'descend');
    sortedRat_idx = sortedRat_idx'; % transpose sorted list to column
    
    matchedRat_idx = zeros(length(sortedRat_idx),1); % initialize
    
    % this nested loop checks the filename cell array for each starting letter requested
    for ll = 1:numRatLetters
        ratLetter = ratString(ll); cntr1 = 0; % reinitialize counter
        nameMatches = zeros(length(sortedRat_idx),1); % reinitialize found matches array
        for kk = sortedRat_idx' % this inner loop checks for matches with 1 letter
            cntr1 = cntr1 + 1;
            nameMatches(cntr1)=strncmpi(ratNames{kk},ratLetter,1); % find case insensitive first letter match indeces
            if nameMatches(cntr1)
                break % terminate string search when most recent match is found
            end
        end
        % logical indexing/bitmasking & collecting indexes between loops by cum. summation
        matchedRat_idx=matchedRat_idx+(sortedRat_idx.*nameMatches);
    end
    
    chosenRat_idx = nonzeros(matchedRat_idx); % just get nonzero indexes of matched rat folders
    numFoundMatches = length(chosenRat_idx);  % get number of these nonzero vals (matches)
    
    loopedRatNames = zeros(numFoundMatches*numSessEachRat,1);
    for jj = 1:numFoundMatches % iterate only the number of found ratLetter matches
        cntr2 = jj*numSessEachRat;
        loopedRatNames(cntr2-numSessEachRat+1:cntr2)=chosenRat_idx(jj); % create array to iter through, repping each rat
    end
end

if isempty(chosenRat_idx)
    error('Sorry, there was no rat folder match for the letters you provided')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                      EXTRACT RELEVANT TRIALS                          %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

plotcntr = 0; % plot loop counter initialize

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
        sessionDates = sessionDates(1:2); % hardcoded, gets the entered # days worth of date files
    elseif flexMode % Flex Mode , NEED TO COMMENT BELOW CODE BLOCK
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
        [taskInput_idx, ~] = listdlg('PromptString', 'Select a task for this animal to analyze', 'SelectionMode', 'single', 'ListString', uniqueTaskMode, 'ListSize', [300 300]);
        validSessions = strcmp(uniqueTaskMode{taskInput_idx}, {taskMode(:).taskModeEnum});
        [sessionInput_idx, ~] = listdlg('PromptString', 'Select sessions to analyze', 'ListString', dateAndSaveTagString(validSessions),  'ListSize', [300 300]);
        sessionDateAndSaveTag = dateAndSaveTagString(validSessions);
        selectedTaskMode = taskMode(validSessions);
        selectedTaskMode = selectedTaskMode(sessionInput_idx);
        selectedSessions = {selectedTaskMode(:).path};
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%       Flexible Input Mode with CLI      %%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%datetime(YourVector, 'ConvertFrom', 'yyyymmdd', 'Format','MM/dd/yyyy')%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    elseif flexMode % if 1, 2, or 3 user inputs, flexible input mode
        selectedSessions = sessionsFound(modCntr+1);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    trials = selectedSessionsToTrials(selectedSessions);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%     Choose analysis based on selected taskMode or User input      %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if flexMode == true
        sessionSaveTag = string(trials.trials(modCntr+1).saveTag);
        sessionDateTime = char(datetime(string(trials.trials(1).dateTimeTag), 'InputFormat', 'yyyyMMddHHmmss','Format', 'yyyy-MM-dd, HH:mm:ss'));
        sessionDateTimeAndSaveTag = [sessionDateTime ' - SaveTag: ' char(sessionSaveTag)];
        pngPath = [basedir(1:end-1) '_PNGfiles' filesep sessionDateTime(1:10) filesep];
        switch plotStr
            case 'scat'
                ratScatter(trials, ratNames{ratIdx}, sessionDateTimeAndSaveTag, pngFlag, pngPath)
            case 'cyc'
                [~] = cycleFlags(trials,0);
            case 'kin'
                % Future feature. Will behave like cycleFlags, but will be of kinematics
                % You can add in the function below to test as step 1
                % ratKinematics(trials)
                
                % then Later as step 2 you can add the below function with more input arguments:
                % ratKinematics(trials, ratNames{ratIdx}, sessionDateTimeAndSaveTag, pngFlag, pngPath)
            case 'png'
                pngFlag = plotStr; % overwrite default 'nopng' value to 'png' so it will skip plotting and save the PNG
                ratScatter(trials, ratNames{ratIdx}, sessionDateTimeAndSaveTag, pngFlag, pngPath)
            case 'all'
            otherwise
        end
    elseif flexMode == false
        switch uniqueTaskMode{taskInput_idx}
            case 'LOWER_THRESHOLD'
                trials = analyzeTurnAttempts(trials);
                [trials, summary] = analyzeKnobTurn(trials, sessionDateAndSaveTag(sessionInput_idx));
                plotKnobTurn(trials, summary);
            case 'LOWER_THRESHOLD_PERTURBATION'
                trials = analyzeTurnAttempts(trials);
                [trials, summary] = analyzeKnobTurn(trials, sessionDateAndSaveTag(sessionInput_idx));
                plotKnobTurnPerturbation(trials, summary);
            case 3
            case {'KNOB_HOLD_CUED_TURN', 'KNOB_HOLD_RAND_TURN'}
                [trials, summary] = analyzeCuedTurn(trials, sessionDateAndSaveTag(sessionInput_idx));
                plot_cued_turn(trials, summary)
                %[trials, summary] = analyzeKnobTurn(trials, sessionTags(sessionInput_idx));
                %plotKnobTurn(trials, summary);
            case 'RAND_TURN_TWO_TARGETS'
                %plotBadGoodTouches_1(trials, ratNames{ratIdx}, sessionTags{sessionInput_idx})
                %[trials, summary] = analyzeCuedTurn(trials, sessionTags(sessionInput_idx));
                %plotHoldTurnViolin(trials, summary);
                plot_rand_turn(trials, summary)
            case {'KNOB_HOLD_ASSOCIATION', 'KNOB_HOLD_ASSO_NOMIN', 'KNOB_HOLD_CONSOL','KNOB_HOLD_AUTO_TURN'}
                plotBadGoodTouches_1(trials, ratNames{ratIdx}, sessionDateAndSaveTag{sessionInput_idx})
                %plotDistribution(trials)
                %plotBadTouches(trials)
                %plotHoldPosMaxAnalysis(trials)
                %plotFailFlag16Overlay(trials)
                % trials = findHoldIdx(trials);
                % summary = analyzeKnobHold(trials, sessionTags(sessionInput_idx)); % creates a session summary for the holding task % FZ commented on 190930
                % plotHoldViolin(trials, summary); % creates plots for the holding task to analyze critical data % FZ commented on 190930
            otherwise
        end
    end
    plotcntr = plotcntr + 1; % increment the counter
end