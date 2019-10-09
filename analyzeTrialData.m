% analyzeTrialData
close all
trialData= struct('posEncoder', allStruct.posEncoder,...
    'velEncoder', allStruct.velEncoder,...
    'pertEnable', allStruct.pertEnable);
extractedStateTrans = extractTransIdx(allStruct);
[extractedTrial, pertTrue] = extractState(allStruct, extractedStateTrans);
%idx_hit = stateIdxDesire(extractedStateTrans.preToTrial, extractedStateTrans.trialToReward, extractedStateTrans.trialToInit, allStruct.timeMax(3));
%[extractedTrial, pertTrue] = extractStateData(trialData, idx_hit);
plotTrajectoryTrial(extractedTrial, pertTrue)
trialStats = statTrialData(extractedTrial, pertTrue);