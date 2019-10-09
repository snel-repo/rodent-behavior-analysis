% extract transition indices
function [extractedStateTrans] = extractTransIdx(trialData)

preIdx = [0; diff(trialData.state(:,2))]; % 0 padded to match indices

% determine transition indices between states
initToPre = (trialData.state(:,2) == 2) .* (preIdx == 1); 
preToInit = (trialData.state(:,2) == 1) .* (preIdx == -1);
preToTrial = (trialData.state(:,2) == 3) .* (preIdx == 1);
trialToInit = (trialData.state(:,2) == 1) .* (preIdx == -2);
trialToReward = (trialData.state(:,2) == 4) .* (preIdx == 1);
rewardToInit = (trialData.state(:,2) == 1) .* (preIdx == -3);


extractedStateTrans = struct('initToPre', initToPre,...
    'preToInit', preToInit,...
    'preToTrial', preToTrial,...
    'trialToInit', trialToInit,...
    'trialToReward', trialToReward,...
    'rewardToInit', rewardToInit);
    