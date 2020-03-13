function [matchingIndexes] = findFlags(in,flagNumber)
% [trialNumbers] = findFlags(in,flagNumber)
%           1st argument: input the trial struct from analyzeTaskData
%           2nd argument: input the trial flag for the trials you want to find

if flagNumber >= 0
    allFailFlags = [in.trials.flagFail];
    matchingIndexes = find(allFailFlags==flagNumber);
elseif flagNumber == -1
    allCatchTrials = [in.trials.catchTrialFlag];
    matchingIndexes = find(allCatchTrials==1);
end
end