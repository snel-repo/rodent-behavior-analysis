function [in, summary] = analyzeKnobTurn(in, sessionTag)
for i = 1 : length(in)
    tmp = in(i).trials;
    vals = zeros(1,10);
    thresh = [];
    rmIdx = [];
    trialInBlock = 1;
    for j = 1 : length(tmp)
        % deal w/ thresholds
        thresh = median(vals);
        if thresh < 5
            thresh = 5 ;
        elseif thresh > 60
            thresh = 60;
        end
        in(i).trials(j).thresh = thresh;
        vals = [tmp(j).maxAngleTrialOnly vals(1:end-1)];
        %now, deal w/ velocities
        trialIdx = find(tmp(j).state == 3);
        trialIdx = [trialIdx' [trialIdx(end)+1 : 1 : trialIdx(end) + 50]];
        if max(abs(tmp(j).velRaw(trialIdx))) > 2500
            rmIdx = [rmIdx j];
        end
         if j ~= 1 && (in(i).trials(j-1).pertEnableTrial ~= in(i).trials(j).pertEnableTrial)
            trialInBlock = 1;
        end
        in(i).trials(j).trialInBlock = trialInBlock;
        trialInBlock = trialInBlock + 1;
    end
    in(i).trials(rmIdx) = [];
end

for i = 1 : length(in)
    summary(i).trialNum = length(in(i).trials);
    summary(i).hitNum = sum([in(i).trials(:).hitTrial]);
    summary(i).hitRate = sum([in(i).trials(:).hitTrial]) / length(in(i).trials); % compute hit rate
    summary(i).sessionTag = sessionTag{i};
    summary(i).medianMaxAngle = median([in(i).trials(:).maxAngleTrialOnly]); % compute median of maximum angle in single turn in trial
    summary(i).meanMaxAngle = mean([in(i).trials(:).maxAngleTrialOnly]); % compute mean of maximum angle in single turn in trial
    summary(i).currentMax = mode([in(i).trials(:).stiffCurrentMax]);
    summary(i).torqueMax = double(summary(i).currentMax) * 0.036; % convert from current to mNm
    summary(i).medianThresh = median([in(i).trials(:).thresh]);
        summary(i).iqrThresh = iqr([in(i).trials(:).thresh]);
    summary(i).iqrMax = iqr([in(i).trials(:).maxAngleTrialOnly]);
end



