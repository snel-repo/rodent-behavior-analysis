function [taskModes] = extractTaskModes(in, dates)
structIdx = 1;
if length(in)==0
    error('The input "in" structure was empty')
end
for i = 1 :length(in)
    filenames = dir(in{i});
    filenames = {filenames.name};
    filenames = filenames(3:end); % get rid of . and .. dir
    if ~isempty(find(strcmp(filenames, '.DS_Store') | strcmp(filenames, '._.DS_Store')))
        filenames(find(strcmp(filenames, '.DS_Store') | strcmp(filenames, '._.DS_Store'))) = [];
    end
    if length(filenames)==0
        error('No files were found in the specified directory, or the directory does not exist.')
    end
    for j = 1:length(filenames)
        %         if ~strcmp(filenames{j}, '.DS_Store')
        tmpPath = [in{i} filenames{j} filesep];
        trialnames = dir(tmpPath);
        trialnames = {trialnames.name};
        trialnames = trialnames(3:end);
        if ~isempty(find(strcmp(trialnames, '.DS_Store') | strcmp(trialnames, '._.DS_Store')))
            trialnames(find(strcmp(trialnames, '.DS_Store') | strcmp(trialnames, '._.DS_Store'))) = [];
        end
        
        tmpData = load([tmpPath trialnames{1}]);
        
        try % remove any blank taskmode trials
            taskModes(structIdx).taskMode = tmpData.trial.taskMode;
        catch
            warning('A trial does not have a taskMode, will set to KNOB_HOLD_AUTO_TURN. If different taskMode, be sure to change');
            taskModes(structIdx).taskMode = -1; %set to -1, so will see all trials that had no taskMode set to 0 for debug purposes
            tmpData.trial.taskMode = 12;
        end
        
        taskModes(structIdx).path = tmpPath;
        taskModes(structIdx).date = dates{i};
        taskModes(structIdx).saveTag = filenames{j};
        
        switch tmpData.trial.taskMode
            case 0
                taskModes(structIdx).taskModeEnum = 'TARGET_WINDOW';
            case 1
                taskModes(structIdx).taskModeEnum = 'LOWER_THRESHOLD';
                if tmpData.trial.pertEnable
                    taskModes(structIdx).taskModeEnum = 'LOWER_THRESHOLD_PERTURBATION';
                end
            case 2
                taskModes(structIdx).taskModeEnum = 'FAMILIARIZATION';
            case 3
                taskModes(structIdx).taskModeEnum = 'SOUND_CUE_ASSOCIATION_FEED';
            case 4
                taskModes(structIdx).taskModeEnum = 'KNOB_TOUCH_ASSOCIATION_NO_LED';
            case 5
                %taskModes(structIdx).taskModeEnum = 'KNOB_TOUCH_ASSOCIATION_LED';
                taskModes(structIdx).taskModeEnum = 'KNOB_HOLD_ASSO_NOMIN';
            case 6
                taskModes(structIdx).taskModeEnum = 'KNOB_HOLD_ASSOCIATION';
            case 7
                taskModes(structIdx).taskModeEnum = 'KNOB_HOLD_CUED_TURN';
            case 8
                taskModes(structIdx).taskModeEnum = 'HOLD_LOWER_THRESHOLD';
            case 9
                taskModes(structIdx).taskModeEnum = 'KNOB_HOLD_CONSOL';
            case 10
                taskModes(structIdx).taskModeEnum = 'KNOB_HOLD_RAND_TURN';
            case 11
                taskModes(structIdx).taskModeEnum = 'RAND_TURN_TWO_TARGETS';
            case 12
                taskModes(structIdx).taskModeEnum = 'KNOB_HOLD_AUTO_TURN';
            case 20
                taskModes(structIdx).taskModeEnum = 'FREE_SPIN';
            otherwise % sean added to define all possible cases - 3/13/20 
                error('taskMode undefined')
        end
        structIdx = structIdx + 1;
    end
end