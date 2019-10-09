function trials = preprocessData(in, files)


eventFields = {'hitTrial', 'eventData_time', 'feederOut', 'servoDuty', 'zeroVelTransition_time', 'zeroVelTransition', 'maxVelTransition', 'maxVelTransition_time', 'attemptBus_time', 'attemptNum'};
eventTypes = {'double', 'double', 'uint8', 'double', 'double', 'uint8', 'uint8', 'double', 'double', 'uint8'};
% turn into a struct array
deleteFieldsIdx = 1;
deleteFields = [];
for i = 1:numel(in)
    for j = 1:numel(eventFields)
        if ~isfield(in{i}, eventFields{j})
            eval(['in{i}.' eventFields{j} '=' eventTypes{j} '.empty(0,1);']);
        end
        if ~isfield(in{i}, 'trialData_time') || isempty(in{i}.cpt) % if a session for some reason doesn't have trialdata, throw it out
            deleteFields(deleteFieldsIdx) = i;
            deleteFieldsIdx = deleteFieldsIdx + 1;
        end
    end
    
    fieldLen(i) = length(fieldnames(in{i})); % used for debugging unequal field name lengths
    % process file times, format is YYYYMMDD.HHMMSS.sss    
end
in(deleteFields) = []; % sessions to throw out
deleteFieldsIdx = 1;
deleteFields = [];
clear i
for i = 1:numel(in)
    if length(in{i}.trialData_time) == 1|| isempty(in{i}.currentMax)% probably a fragment trial
        deleteFields(deleteFieldsIdx) = i;
        fprintf('Skipping file %s, assumed empty\n', in{deleteFields}.trialIdStr);
    end
end
in(deleteFields) = [];
%% check broken trials
for i = 1:length(in)
    brokenAll = cellfun(@(x) length(fieldnames(x)), in);
    if range(brokenAll) ~= 0
        trialPass = false;
    else
        trialPass = true;
    end
end

if ~trialPass
    for i = 1:length(brokenAll)
        fprintf('Trial #%s, fieldNum: %s\n', num2str(i), num2str(brokenAll(i)))
    end
end
assert(trialPass, 'Input trials are not all the same number of field names. Likely a storage issue from trialLogger.')
trials = vertcat(in{:}); % turn cell -> struct

% hits = arrayfun(@(x) ~isempty(x.hitTrial), trials);

for ntr = 1:numel(trials)
        filename = files(i).name(1:end-4); % pull out filename, get rid of .mat
        timeStore.ms = filename(end-2:end);
        filename = filename(1:end-4);
        timeStore.hhmmss = filename(end-5:end);
        filename = filename(1:end-7);
        timeStore.yyyymmdd = filename(end-7:end);
        
        trials(ntr).dateTimeTag = str2num([timeStore.yyyymmdd timeStore.hhmmss]);
        % find out when there was a hit trial
        if trials(ntr).hitTrial
            trials(ntr).wasHit = 1;
        else
            trials(ntr).wasHit = 0;
        end
        if isfield(trials(ntr), 'pertEnable') && ~isempty(trials(ntr).pertEnable)% means perturbations are included
            if trials(ntr).pertEnable && trials(ntr).pertEnableTrial % pert enabled overall & for trial
                %             if isfield(trials(ntr), 'hitMode') && ~trials(ntr).hitMode
                %                 trials(ntr).windowPertHit = hits(ntr);
                %             else
                %                 trials(ntr).windowPertHit = nan;
                %             end
                trials(ntr).pertHit = trials(ntr).wasHit;
                trials(ntr).pertSession = 1;
            elseif trials(ntr).pertEnable && ~trials(ntr).pertEnableTrial % pert enabled overall off for trial
                %             if isfield(trials(ntr), 'hitMode') && ~trials(ntr).hitMode
                %                 trials(ntr).windowPertHit = hits(ntr);
                %             else
                %                 trials(ntr).windowPertHit = nan;
                %             end
                trials(ntr).nonPertHit = trials(ntr).wasHit;
                trials(ntr).pertSession = 1;
            else % pert not enabled overall
                if isfield(trials(ntr), 'hitMode') && ~trials(ntr).hitMode
                    trials(ntr).windowHit = trials(ntr).wasHit;
                else
                    trials(ntr).windowHit = nan;
                end
                trials(ntr).pertHit = nan;
                trials(ntr).nonPertHit = nan;
                trials(ntr).pertSession = 0;
            end
        else % pert parameters not included in output (no pert)
            trials(ntr).pertHit = nan;
            trials(ntr).nonPertHit = nan;
            trials(ntr).pertSession = 0;
        end
        
        
        % on trials where there was a hit, when does it transition from state.TRIAL
        % to state.REWARD
        if trials(ntr).wasHit
            trials(ntr).rewardTime = find(trials(ntr).state == 5,1);
            %what was the angle when a reward was achieved
            trials(ntr).rewardAngle = trials(ntr).pos(trials(ntr).rewardTime);
            trials(ntr).failAngle = nan;
        else
            trials(ntr).rewardTime = nan;
            trials(ntr).rewardAngle = nan;
            if isfield(trials, 'maxAngleTrialOnly')
                trials(ntr).failAngle = trials(ntr).maxAngleTrialOnly;
            end
            %trials(ntr).
        end
        if trials(ntr).saveTag == 1
            trials(ntr).sessionTime = 'afternoon';
        else
            trials(ntr).sessionTime = 'morning';
        end
end



