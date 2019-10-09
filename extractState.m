function [extractedState, pertTrue]  = extractState(trialData, extractedStateTrans)
stateHit = find(extractedStateTrans.trialToReward);
stateLen = trialData.timeElapsedState(stateHit,2);
extractedState = cell(length(stateHit),3);
[~, pertIdx, ~] = intersect(stateHit, find(diff(trialData.pertEnable(:,2)) == -1)+1);
pertTrue = zeros(length(stateHit), 1);
pertTrue(pertIdx) = 1;
for i = 1:length(stateLen)
    extractedState{i,1} = trialData.posEncoder((stateHit(i) - stateLen(i)) : stateHit(i), 2)';
    extractedState{i,2} = trialData.velEncoder((stateHit(i) - stateLen(i)) : stateHit(i), 2)';
    extractedState{i,3} = trialData.pertCurrent((stateHit(i) - stateLen(i)) : stateHit(i),2)';
end
