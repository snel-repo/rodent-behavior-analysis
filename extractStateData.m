function [extractedTrial, pertTrue] = extractStateData(trialData, idx_hit)
extractedPos = cell(length(idx_hit), 1);
extractedVel = cell(length(idx_hit), 1);

[~, pertIdx, ~] = intersect(idx_hit(:,2), find(diff(trialData.pertEnable(:,2)) == -1)+1);
pertTrue = zeros(length(idx_hit), 1);
pertTrue(pertIdx) = 1;

for i = 1:length(idx_hit)
    extractedPos{i} = trialData.posEncoder(idx_hit(i, 1) : idx_hit(i, 2), 2);
    extractedVel{i} = trialData.velEncoder(idx_hit(i, 1) : idx_hit(i, 2), 2);
end
extractedTrial = [extractedPos, extractedVel];
