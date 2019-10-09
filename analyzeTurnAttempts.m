function out = analyzeTurnAttempts(in)
for i = 1 : length(in)
    keyboard
    tmp = in(i).trials; % temporarily hold each session's trials 
    for j = 1 : length(tmp) % run through each trial 
        turnStartIdx = find(tmp(j).state == 3 & [0; diff(int8(tmp(j).zeroVelFlag))] == -1); % find indices where velocity goes above thresh in trial  
        in(i).trials(j).attemptType = 0; % type 0 is made in trial 
        if isempty(turnStartIdx) % rat started turning in init 
            turnStartIdx = find(tmp(j).state == 1 & [0; diff(int8(tmp(j).zeroVelFlag))] == -1);
            stateIdx = find(tmp(j).state == 5);
            stateIdx = stateIdx(end); 
            turnStartIdx(turnStartIdx > stateIdx) = [];
            in(i).trials(j).attemptType = 1; % type 1 is made in init
        end
        trialEndIdx = find(tmp(j).state == 5 &  [0; diff(int8(tmp(j).zeroVelFlag))] == 1,1); % find when the final attempt ends
        turnEndIdx = find(tmp(j).state == 3 &  [0; diff(int8(tmp(j).zeroVelFlag))] == 1,1);
        attemptIdx = turnStartIdx(end) : trialEndIdx; 
        in(i).trials(j).attemptIdx = attemptIdx;
        in(i).trials(j).lengthAttempt = length(attemptIdx);
    end
end
out = in;