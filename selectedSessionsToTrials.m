function [out] = selectedSessionsToTrials(in)
for i = 1:length(in)
    files = dir([in{i} '*.mat']);
    trialCell = cell(length(files), 1);
    for iF = 1:length(files)
        data = load([in{i} files(iF).name], 'trial');
        trialCell{iF} = data.trial;
    end
    trials = preprocessData(trialCell, files);
    %[~, idx] = sort([trials(:).wallclockStart]); % Tony
    [~, idx] = sort([trials(:).trialId]); % FZ 06/13/2019
    trials(:) = trials(idx);
    for j = 1 :length(trials)
        if isfield(trials(j), 'touchBus_time') && length(trials(j).touchBus_time) > 1.2 * length(trials(j).trialData_time) % something weird w/ the sampling rates
            % do nothing 
        else
            if trials(j).hitTrial
                trials(j).timeHoldMax = trials(j).timeHold(find(trials(j).state == 5 & trials(j).timeHold == 0,1) - 1);
            else
                trials(j).timeHoldMax = trials(j).timeHold(find(trials(j).state ==5,1) - 2);
            end
        end
    end
    if ~isempty(find([trials.timeHoldMax] > 1990)) && trials(j).taskMode == 6
        fprintf(['Removed trials ' num2str(find([trials.timeHoldMax] > 1990)) ' for touch sensor reset\n'])
        trials(find([trials.timeHoldMax] > 1990)) = [];
    end
    out(i).trials = trials;
end