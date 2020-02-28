function [trialNumbers] = findFlags(in,flagNumber)
if flagNumber >= 0
    allFailFlags = [in.trials.flagFail];
    trialNumbers = find(allFailFlags==flagNumber);
elseif flagNumber == -1
    allCatchTrials = [in.trials.catchTrialFlag];
    trialNumbers = find(allCatchTrials==1);
end
end