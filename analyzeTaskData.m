%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Tony Corsten, tony.corsten93@gmail.com, Then Sean O'Connell
% Date: 9/11/2018, (Sean on 11/6/19)
% Purpose: this is an automated analysis suite that takes rat name and
% pulls available tasks that rat has completed. You can then select one or
% multiple sessions to produce task-related results and plots.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pull rat names for user to select
function [] = analyzeTaskData(varargin)

basedir = '/snel/share/data/trialLogger/RATKNOBTASK/'; %removed folder selection GUI - SeanOC

ratDirAll = dir(basedir); % pull full directory of rat name information
ratNames = {ratDirAll.name}; % extract only rat names

%%%%  These first 4 if-else blocks check for valid user inputs and initialize %%%
%%%%  variables accordingly.

if nargin > 2 % check for excess user inputs
    error('Too many input arguments. Try following example in line 42 of analyzeTaskData code') 
    % Function Usage: analyzeTaskData(numberOfSessions) or analyzeTaskData(numSessEachRat,'xyz') <--for rats X, Y, and Z -SOC
end

if nargin == 0 % normal GUI function mode if no input argument
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
    totalNumSess=1; numSessEachRat=1; loopedRatNames=ratInput_idx; % these are just to allow for original implementation
    chosenRat_idx=0; % another initialization for PNG Mode compatibility
end

if nargin == 1 % 1 user input is not valid for this function
    error('Use 2 inputs as described in line 42 of the code.')
end

if nargin == 2 % if 2 user inputs, will run New PNG output mode
    numSessEachRat = varargin{1};
    ratString = unique(varargin{2}); % this should be a string with 1st letter of each rat wanted
    numRatLetters = length(ratString);
    totalNumSess = numSessEachRat*numRatLetters;
    
    %collect ordered indexes for most recently edited rat folders
    [~,sortedRat_idx] = sort([ratDirAll.datenum],'descend'); 
    sortedRat_idx = sortedRat_idx'; % transpose sorted list to column 
       
    matchedRat_idx = zeros(length(sortedRat_idx),1); % initialize
        
    %% this nested loop checks the filename cell array for each starting letter requested
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

%% Extract relevant trials
plotcntr = 0; % plot loop counter initialize
for ii=loopedRatNames' % loop through the chosen rat ID's
    
    if mod(plotcntr,numSessEachRat)==0 % check for first call of each rat (for efficiency)
    subjdir = [basedir ratNames{ii} filesep]; % create a new string with the subject directory
    sessionDatesDirAll = dir(subjdir);
    sessionDates = {sessionDatesDirAll.name};
    end
    
    if nargin == 0 % Original Mode
        sessionDates = sessionDates(end-1:end); % gets the past couple days worth of date files
    elseif nargin == 2 % PNG Mode for multi-plotting -- SeanOC
        sessionDates = sessionDates(end-numSessEachRat+1:end); % get desired amount of recent files
    end

    if ~isempty(find(strcmp(sessionDates, '.DS_Store') | strcmp(sessionDates, '._.DS_Store')))
        sessionDates(find(strcmp(sessionDates, '.DS_Store') | strcmp(sessionDates, '._.DS_Store'))) = [];
    end
    tmpProtocolDir = cell(1, length(sessionDates));
    [tmpProtocolDir{:}] = deal([filesep '1' filesep]); % deal can be used similarly to repmat for strings
    sessionDatesFullPath = strcat(sessionDates, tmpProtocolDir); % this combines the session date string with the '/1/' string to get past protocol number directory
    tmpSubjPath = cell(1, length(sessionDates));
    [tmpSubjPath{:}] = deal(subjdir); % creates a copy of the subject directory
    fullRatDatePaths = strcat(tmpSubjPath, sessionDatesFullPath);
    fullRatDatePathsTrunc = fullRatDatePaths(~cellfun(@(x) any(isletter(x)),sessionDatesFullPath)); %check for any letters in filenames, cause warning
    if any(isletter([sessionDatesFullPath{:}]))
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
    % now get user input through GUI
    if nargin == 0
        [taskInput_idx, ~] = listdlg('PromptString', 'Select a task for this animal to analyze', 'SelectionMode', 'single', 'ListString', uniqueTaskMode, 'ListSize', [300 300]);
        validSessions = strcmp(uniqueTaskMode{taskInput_idx}, {taskMode(:).taskModeEnum});
        [sessionInput_idx, ~] = listdlg('PromptString', 'Select sessions to analyze', 'ListString', dateAndSaveTagString(validSessions),  'ListSize', [300 300]);
        sessionTags = dateAndSaveTagString(validSessions);
        selectedTaskMode = taskMode(validSessions);
        selectedTaskMode = selectedTaskMode(sessionInput_idx);
        selectedSessions = {selectedTaskMode(:).path};
        trials = selectedSessionsToTrials(selectedSessions);
    elseif nargin == 2 % for PNG mode
        [~,sortedDate_idx] = sort([sessionDatesDirAll.datenum],'descend'); % get sorted idx's
        sortedSessionDatesDirAll = sessionDatesDirAll(sortedDate_idx); % use idx's to sort the array
        %find folders without leading '.' and extract their indeces by
        %logical indexing
        modCntr = mod(plotcntr,numSessEachRat);
        if modCntr==0 % check for first call for a given rat
            validSortedDate_idx = ~strncmp('.',{sortedSessionDatesDirAll(:).name},1).*sortedDate_idx; %logical indexing (bitmasking)
            nonzeroValidSortedDate_idx = nonzeros(validSortedDate_idx); % just remove zeros
        end
        for gg = modCntr
        end
    end
    %% choose analysis based on selected taskMode
    switch uniqueTaskMode{taskInput_idx}
        case 'LOWER_THRESHOLD'
            trials = analyzeTurnAttempts(trials);
            [trials, summary] = analyzeKnobTurn(trials, sessionTags(sessionInput_idx));
            plotKnobTurn(trials, summary);
        case 'LOWER_THRESHOLD_PERTURBATION'
            trials = analyzeTurnAttempts(trials);
            [trials, summary] = analyzeKnobTurn(trials, sessionTags(sessionInput_idx));
            plotKnobTurnPerturbation(trials, summary);
        case 3
        case {'KNOB_HOLD_CUED_TURN', 'KNOB_HOLD_RAND_TURN'}

          [trials, summary] = analyzeCuedTurn(trials, sessionTags(sessionInput_idx));
          plot_cued_turn(trials, summary)
            %[trials, summary] = analyzeKnobTurn(trials, sessionTags(sessionInput_idx));
            %plotKnobTurn(trials, summary);
        case 'RAND_TURN_TWO_TARGETS'
          %plotBadGoodTouches_1(trials, ratNames{ii}, sessionTags{sessionInput_idx})
          %[trials, summary] = analyzeCuedTurn(trials, sessionTags(sessionInput_idx));
          %plotHoldTurnViolin(trials, summary);
        plot_rand_turn(trials, summary)
        case {'KNOB_HOLD_ASSOCIATION', 'KNOB_HOLD_ASSO_NOMIN', 'KNOB_HOLD_CONSOL','KNOB_HOLD_AUTO_TURN'}
          plotBadGoodTouches_1(trials, ratNames{ii}, sessionTags{sessionInput_idx})
          %plotDistribution(trials)
          %plotBadTouches(trials)
          %plotHoldPosMaxAnalysis(trials)
          %plotFailFlag16Overlay(trials)
            % trials = findHoldIdx(trials);
            % summary = analyzeKnobHold(trials, sessionTags(sessionInput_idx)); % creates a session summary for the holding task % FZ commented on 190930
            % plotHoldViolin(trials, summary); % creates plots for the holding task to analyze critical data % FZ commented on 190930
    end
    plotcntr = plotcntr + 1; % increment the counter
end
end