%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Tony Corsten, tony.corsten93@gmail.com
% Date: 9/11/2018
% Purpose: this is an automated analysis suite that takes rat name and
% pulls available tasks that rat has completed. You can then select one or
% multiple sessions to produce task-related results and plots.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear all
addpath('/snel/home/jwang945/Projects/rodent-behavior-analysis')
%clear all
%% Pull rat names for user to select
basedir = uigetdir([], 'Select rodent data directory (RATKNOBTASK)');
if basedir == 0 % if no rodent selected (cancel)
    fprintf('Cancel selected. Exiting program.\n')
    return  % return control to user
end
basedir = [basedir filesep]; % append \ for base directory
ratNameDirAll = dir(basedir); % pull full directory of rat name information
ratNames = {ratNameDirAll.name}; % extract only rat names
ratNames= ratNames(3:end); % trim . and .. from filenames
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
subjdir = [basedir ratNames{ratInput_idx} filesep]; % create a new string with the subject directory
%% Extract relevant trials
sessionDatesDirAll = dir(subjdir);
sessionDates = {sessionDatesDirAll.name};
%sessionDates = sessionDates(3:end); % trim . and .. from filenames % if you want all
%sessionDates = sessionDates(3:end);
sessionDates = sessionDates(end-1:end);

if ~isempty(find(strcmp(sessionDates, '.DS_Store') | strcmp(sessionDates, '._.DS_Store')))
    sessionDates(find(strcmp(sessionDates, '.DS_Store') | strcmp(sessionDates, '._.DS_Store'))) = [];
end
tmpProtocolDir = cell(1, length(sessionDates));
[tmpProtocolDir{:}] = deal([filesep '1' filesep]); % deal can be used similarly to repmat for strings
sessionDatesFullPath = strcat(sessionDates,  tmpProtocolDir); % this combines the session date string with the '/1/' string to get past protocol number directory
tmpSubjPath = cell(1, length(sessionDates));
[tmpSubjPath{:}] = deal(subjdir); % creates a copy of the subject directory
fullRatDatePaths = strcat(tmpSubjPath, sessionDatesFullPath);


[taskMode] = extractTaskModes(fullRatDatePaths, sessionDates);
uniqueTaskMode = unique({taskMode(:).taskModeEnum});
dateAndSaveTagString = strcat({taskMode(:).date}, ' : ', {taskMode(:).saveTag});
%
[taskInput_idx, ~] = listdlg('PromptString', 'Select a task for this animal to analyze', 'SelectionMode', 'single', 'ListString', uniqueTaskMode, 'ListSize', [300 300]);
validSessions = strcmp(uniqueTaskMode{taskInput_idx}, {taskMode(:).taskModeEnum});
[sessionInput_idx, ~] = listdlg('PromptString', 'Select sessions to analyze', 'ListString', dateAndSaveTagString(validSessions),  'ListSize', [300 300]);
sessionTags = dateAndSaveTagString(validSessions);
selectedTaskMode = taskMode(validSessions);
selectedTaskMode = selectedTaskMode(sessionInput_idx);
selectedSessions = {selectedTaskMode(:).path};
trials = selectedSessionsToTrials(selectedSessions);

    %% switch analysis based on selected taskMode
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
      %[trials, summary] = analyzeCuedTurn(trials, sessionTags(sessionInput_idx));
      %pl}otHoldTurnViolin(trials, summary);
      %plotTwoTargetTimeAnalysis(trials)
      %plot_rand_turn(trials, summary)
      %plotTenTrialsWithAutoTurnDebuggerZoomedIn(trials)
      singleTrialAutoTurnDebugger(trials)
    case {'KNOB_HOLD_ASSOCIATION', 'KNOB_HOLD_ASSO_NOMIN', 'KNOB_HOLD_CONSOL'}
      %plotTwoTargetTimeAnalysis(trials)
      plotBadGoodTouches_1(trials, ratNames{ratInput_idx}, sessionTags{sessionInput_idx})
      %plotDistribution(trials)
      %plotBadTouches(trials)
      
        % trials = findHoldIdx(trials);
        % summary = analyzeKnobHold(trials, sessionTags(sessionInput_idx)); % creates a session summary for the holding task % FZ commented on 190930
        % plotHoldViolin(trials, summary); % creates plots for the holding task to analyze critical data % FZ commented on 190930
    case 'KNOB_HOLD_AUTO_TURN'
%        plotTwoTargetTimeAnalysis(trials)
%       plotTenTrialsAutoTurnDebugger(trials)
%         plotTenTrialsWithAutoTurnDebugger(trials)
       plotTenTrialsWithAutoTurnDebuggerZoomedIn(trials)
%       singleTrialAutoTurnDebugger(trials)
        
end