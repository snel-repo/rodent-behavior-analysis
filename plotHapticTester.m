function plotHapticTester(in)
session = in(numel(in));
allTrials = session.trials;

dirTask = [allTrials.dirTask];
touchStatus = {};
trialState = {};
touchTimes = {};
alignInd = zeros(1, numel(allTrials));
keyboard

for i = 1:numel(allTrials)
    %dirTask{i} = allTrials(i).dirTask;
    touchStatus{i} = allTrials(i).touchStatus;
    trialState{i} = allTrials(i).trialState;
    tmp = find(touchStatus{i} == 1 && trialState{i} == 3);
    if isempty(tmp)
        alignInd(i) = NaN;
    else
        alignInd(i) = tmp(1);
    end
    %temp is now a vector where each index is the first index of each trial
    %where it's a proper touch
end

%align to touch start
%find trial with earliest touch, set that as zero
