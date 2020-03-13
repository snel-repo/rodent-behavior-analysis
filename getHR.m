function [HR,trialCount] = getHR(in,varargin)
% [HR] = getHR(in)  OR  [HR] = getHR(in,indexRange)
% input the 'trials' struct from analyzeTaskData, output the hitrate
% (optional) input the indexRange for inspection [as, a, vector]

allHitFlags = [in.trials.hitTrial];

if nargin == 1 % HR calculation for entire session (all trials)
    hitIdxs = allHitFlags(allHitFlags==1); numHits = length(hitIdxs);
    missIdxs = allHitFlags(allHitFlags==0); numMiss = length(missIdxs);
    trialCount = length(allHitFlags);
    HR = numHits/trialCount;
elseif nargin == 2 % HR calculation for subset of session (select trials)
    inputIdxRng = varargin{1};
    subsetHitFlags = allHitFlags(inputIdxRng);
    hitIdxs = subsetHitFlags(subsetHitFlags==1); numHits = length(hitIdxs);
    missIdxs = subsetHitFlags(subsetHitFlags==0); numMiss = length(missIdxs);
    trialCount = length(subsetHitFlags);
    HR = numHits/trialCount;
end

if nargin == 1
    fprintf("Overall Hit Rates for %s:\n",in.trials(1).subject)
    fprintf("%u / %u successful trials. Hitrate: %.4f\n",numHits,trialCount,HR)
elseif nargin == 2
    fprintf("Catch Trial Subset Hit Rates for %s:\n",in.trials(1).subject)
    fprintf("%u / %u successful trials. Hitrate: %.4f\n",numHits,trialCount,HR)
end
end