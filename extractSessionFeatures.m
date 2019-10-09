function [extractData] = extractSessionFeatures(trials, timeOfInterest)
posHit_idx = 1;
posMiss_idx = 1;
hitPert_idx = 1;
hit_idx = 1;
miss_idx = 1;
missPert_idx = 1;
extractData.trials = trials;
for i = 1:length(trials)
    if i == 1 && trials(i).protocolVersion ~=3
        extractData.subject = trials(i).subject;
        extractData.date = datestr(datenum(num2str(trials(i).date), 'yyyymmdd'), 'mm/dd/yy');
        extractData.sampleTime = trials(i).sampleTime * 1000;
        extractData.protocolVersion = trials(i).protocolVersion;
        if isfield(trials(i), 'pertEnable') && trials(i).pertEnable == 1 % if there is pertEnable, pertMagnitude exists, too
            
            %extractData.pertMagnitude = num2str(100*trials(i).pertMagnitude);
        else
            %             extractData.pertMagnitude = NaN;
            extractData.hitMode = NaN;
        end
        if trials(i).saveTag == 1 % morning, FIX THIS IN PREPROCESS INSTEAD
            extractData.session = 'MORNING';
        else
            extractData.session = 'AFTERNOON';
        end
        if (trials(i).protocolVersion == 3 && trials(i).hitMode == 0) || (trials(i).protocolVersion == 4 && trials(i).taskMode == 0)% window
            extractData.hitMode = 'window';
            if trials(i).threshMode == 1
                extractData.minWindow = trials(i).thetaTarget;
                extractData.maxWindow = trials(i).thetaTarget + trials(i).windowSize;
            else
                extractData.minWindow = trials(i).thetaTarget;
                extractData.maxWindow = NaN;
            end
        else % lower thresh
            extractData.hitMode = 'lower';
            if trials(i).threshMode == 1 % static
                
                extractData.minWindow = trials(i).thetaTarget;
                extractData.maxWindow = NaN;
            else % adaptive
                extractData.minWindow = trials(i).medianMinAngle;
                extractData.maxWindow = NaN;
            end
        end
    end
    
    if i == 1 && trials(i).protocolVersion == 3
        extractData.subject = trials(i).subject;
        extractData.date = datestr(datenum(num2str(trials(i).date), 'yyyymmdd'), 'mm/dd/yy');
        extractData.sampleTime = trials(i).sampleTime * 1000;
        extractData.protocolVersion = trials(i).protocolVersion;
        if isfield(trials(i), 'pertEnable') && trials(i).pertEnable == 1 % if there is pertEnable, pertMagnitude exists, too
            extractData.pertMagnitude = num2str(100*trials(i).pertMagnitude);
        else
            extractData.pertMagnitude = NaN;
            extractData.taskMode = NaN;
        end
        if trials(i).saveTag == 1 % morning, FIX THIS IN PREPROCESS INSTEAD
            extractData.session = 'MORNING';
        else
            extractData.session = 'AFTERNOON';
        end
        if trials(i).taskMode == 0 % window
            extractData.taskMode = 'window';
            if trials(i).threshMode == 1
                extractData.minWindow = trials(i).thetaTarget;
                extractData.maxWindow = trials(i).thetaTarget + trials(i).windowSize;
            else
                extractData.minWindow = trials(i).thetaTarget;
                extractData.maxWindow = NaN;
            end
        else % lower thresh
            extractData.taskMode = 'lower';
            if trials(i).threshMode == 1 % static
                
                extractData.minWindow = trials(i).thetaTarget;
                extractData.maxWindow = NaN;
            else % adaptive
                extractData.minWindow = trials(i).medianMinAngle;
                extractData.maxWindow = NaN;
            end
        end
    end
    
    trial_idx = find(trials(i).state == 3 ,1) + 1; % find time index that trial first enters PRETRIAL (movement of knob)
    trial_time = trials(i).trialData_time(trial_idx);
    extractData.lowerTimeIdx = find(trials(i).trialData_time == trial_time - timeOfInterest(1));
    extractData.upperTimeIdx = find(trials(i).trialData_time == trial_time + timeOfInterest(2));
    extractData.timeRelativeEvent{i} = trials(i).eventData_time(1) - trials(i).sampleTime / (1e-3) - trials(i).trialData_time(trial_idx);
    extractData.velRelativeTrial{i} = trials(i).vel(find(trials(i).trialData_time == extractData.timeRelativeEvent{i}));
    if trials(i).wasHit % trial is a hit
        feedTime_idx = find(trials(i).feederOut == 0); % a 0 is a feed
        
        extractData.timeHit{posHit_idx} = trials(i).trialData_time(extractData.lowerTimeIdx : extractData.upperTimeIdx);
        extractData.posHit{posHit_idx} = trials(i).pos(extractData.lowerTimeIdx : extractData.upperTimeIdx);
        if ~isempty(extractData.posHit{posHit_idx})
            maxA(posHit_idx) = max(extractData.posHit{posHit_idx});
        end
        extractData.velHit{posHit_idx} = trials(i).vel(extractData.lowerTimeIdx : extractData.upperTimeIdx);
        if isfield(trials(i), 'pertEnable') && trials(i).pertEnableTrial
            extractData.pertHitTime{hitPert_idx,1} = extractData.timeRelativeEvent{i};
            extractData.pertHitTime{hitPert_idx, 2} = extractData.velRelativeTrial{i};
            extractData.posHitPert{hitPert_idx} = trials(i).pos(extractData.lowerTimeIdx : extractData.upperTimeIdx);
            extractData.velHitPert{hitPert_idx} = trials(i).vel(extractData.lowerTimeIdx : extractData.upperTimeIdx);
            trials(i).motorCurrent(trials(i).motorCurrent < 0) = 0;
            extractData.pertCurrent{hitPert_idx} = trials(i).motorCurrent(extractData.lowerTimeIdx : extractData.upperTimeIdx);
            hitPert_idx = hitPert_idx + 1;
        elseif isfield(trials(i), 'pertEnable') && ~trials(i).pertEnableTrial
            extractData.noPertHitTime{hit_idx,1} = extractData.timeRelativeEvent{i};
            extractData.noPertHitTime{hit_idx, 2} = extractData.velRelativeTrial{i};
            extractData.posHitNoPert{hit_idx} = trials(i).pos(extractData.lowerTimeIdx : extractData.upperTimeIdx);
            extractData.velHitNoPert{hit_idx} = trials(i).vel(extractData.lowerTimeIdx : extractData.upperTimeIdx);
            hit_idx = hit_idx + 1;
        else
            extractData.posHitPert = NaN;
            extractData.velHitPert = NaN;
            extractData.pertCurrent = NaN;
            extractData.posHitNoPert = NaN;
            extractData.velHitNoPert = NaN;
            extractData.posMissPert = NaN;
            extractData.velMissPert = NaN;
            extractData.posMissNoPert = NaN;
            extractData.velMissNoPert = NaN;
        end
        % find when the feed occurred relative to trial init
        feedTimeRelative = trials(i).eventData_time(feedTime_idx) - trials(i).trialData_time(trial_idx);
        % find idx of feed time in trialData
        feedPosTrial_idx = find(trials(i).trialData_time == trials(i).eventData_time(feedTime_idx)); % find index of position during feed
        % find value of trial position at feed time
        extractData.feedPosTrial{posHit_idx} = [feedTimeRelative, trials(i).pos(feedPosTrial_idx - 1)];
        %extractData.feederOut{posHit_idx}= [trials(i).trialData_time(feedTime_idx) - trials(i).trialData_time(trial_idx) + 1, trials(i).pos(1+ trials(i).eventData_time(feedTime_idx))];
        posHit_idx = posHit_idx + 1;
    else % trial is a miss
        %         extractData.posMiss{posMiss_idx} = trials(i).pos(trial_idx : end);
        %         extractData.velMiss{posMiss_idx} = 6*trials(i).vel(trial_idx : end);
        %         if isfield(trials(i), 'pertEnable') && trials(i).pertEnableTrial
        %             extractData.posMissPert{missPert_idx} = trials(i).pos(trial_idx : end);
        %             extractData.velMissPert{missPert_idx} = trials(i).vel(trial_idx : end);
        %             missPert_idx = missPert_idx + 1;
        %         elseif isfield(trials(i), 'pertEnable') && ~trials(i).pertEnableTrial
        %             extractData.posMissNoPert{miss_idx} = trials(i).pos(trial_idx : end);
        %             extractData.velMissNoPert{miss_idx} = trials(i).vel(trial_idx : end);
        %             miss_idx = miss_idx + 1;
        %         else
        %             extractData.posHitPert = NaN;
        %             extractData.velHitPert = NaN;
        %             extractData.pertCurrent = NaN;
        %             extractData.posHitNoPert = NaN;
        %             extractData.velHitNoPert = NaN;
        %             extractData.posMissPert = NaN;
        %             extractData.velMissPert = NaN;
        %             extractData.posMissNoPert = NaN;
        %             extractData.velMissNoPert = NaN;
        %         end
        
        extractData.posMiss{posMiss_idx} = trials(i).pos(extractData.lowerTimeIdx : extractData.upperTimeIdx);
        extractData.velMiss{posMiss_idx} = 6*trials(i).vel(extractData.lowerTimeIdx : extractData.upperTimeIdx);
        if isfield(trials(i), 'pertEnable') && trials(i).pertEnableTrial
            extractData.posMissPert{missPert_idx} = trials(i).pos(extractData.lowerTimeIdx : extractData.upperTimeIdx);
            extractData.velMissPert{missPert_idx} = trials(i).vel(extractData.lowerTimeIdx : extractData.upperTimeIdx);
            extractData.pertMissTime{missPert_idx,1} = extractData.timeRelativeEvent{i};
            extractData.pertMissTime{missPert_idx, 2} = extractData.velRelativeTrial{i};
            missPert_idx = missPert_idx + 1;
        elseif isfield(trials(i), 'pertEnable') && ~trials(i).pertEnableTrial
            extractData.posMissNoPert{miss_idx} = trials(i).pos(extractData.lowerTimeIdx : extractData.upperTimeIdx);
            extractData.velMissNoPert{miss_idx} = trials(i).vel(extractData.lowerTimeIdx : extractData.upperTimeIdx);
            extractData.noPertMissTime{miss_idx,1} = extractData.timeRelativeEvent{i};
            extractData.noPertMissTime{miss_idx,2} = extractData.velRelativeTrial{i};
            miss_idx = miss_idx + 1;
        else
            extractData.posHitPert = NaN;
            extractData.velHitPert = NaN;
            extractData.pertCurrent = NaN;
            extractData.posHitNoPert = NaN;
            extractData.velHitNoPert = NaN;
            extractData.posMissPert = NaN;
            extractData.velMissPert = NaN;
            extractData.posMissNoPert = NaN;
            extractData.velMissNoPert = NaN;
        end
        posMiss_idx = posMiss_idx + 1;
    end
end