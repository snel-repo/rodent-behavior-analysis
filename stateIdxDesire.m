function [idx_hit] = stateIdxDesire(trans_1, trans_2, trans_3, max_time)
% stateIdxDesire takes in the transition times for the two edges of a
% desired state (ex: trial that moves to reward) as well as the max time in
% the state, and outputs the leading indices that are hits. 
allTrans = trans_1 + trans_2;
idxAllTrans = find(allTrans);
idxDiff = find(diff(idxAllTrans) < max_time);
idx_hit_rise = idxAllTrans(idxDiff); %rising edge (ex: start of trial)
idx_hit_fall = idxAllTrans(idxDiff + 1); %falling edge (ex: start of reward)
idx_hit = [idx_hit_rise idx_hit_fall];

