function [pelletWeightG] = getPellets(in)
% [HR] = getHR(in)  OR  [HR] = getHR(in,indexRange)
% input the 'trials' struct from analyzeTaskData, output the hitrate
% (optional) input the indexRange for inspection [as, a, vector]

allHitFlags = [in.trials.hitTrial];

hitIdxs = allHitFlags(allHitFlags==1); numHits = length(hitIdxs);
%missIdxs = allHitFlags(allHitFlags==0); numMiss = length(missIdxs);
pelletWeightG = numHits * 0.045; % pellet weight is 0.045g

fprintf("%s: ",in.trials(1).subject)
fprintf("%.2fg\n", pelletWeightG)
end