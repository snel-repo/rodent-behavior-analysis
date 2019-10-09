function [statOut] = statTrialData(extractedTrial, pert)
pertTrials = extractedTrial(logical(pert), :);
nonpertTrials = extractedTrial(logical(~pert), :);

pertLen = cellfun(@length, pertTrials(:,1));
nonpertLen = cellfun(@length, nonpertTrials(:,1));
meanPertTrialTime = mean(pertLen);
sdPertTrialTime = std(pertLen);
meanNonPertTrialTime = mean(nonpertLen);
sdNonPertTrialTime = std(nonpertLen);

pertThresh = cellfun(@(x) find(x > 80, 1), pertTrials(:,1));
nonPertThresh = cellfun(@(x) find(x > 80, 1), nonpertTrials(:,1));
meanPertThreshTime = mean(pertThresh);
meanNonPertThreshTime = mean(nonPertThresh);
sdPertThreshTime = std(pertThresh);
sdNonPertThreshTime = std(nonPertThresh);

pertRestAngle = cellfun(@(x) x(end), pertTrials(:,1));
nonPertRestAngle = cellfun(@(x) x(end), nonpertTrials(:,1));
meanPertRestAngle = mean(pertRestAngle);
meanNonPertRestAngle = mean(nonPertRestAngle);
sdPertRestAngle = std(pertRestAngle);
sdNonPertRestAngle = std(nonPertRestAngle);


statOut = struct('rawPertTrialTime', pertLen,...
    'rawNonPertTrialTime', nonpertLen,...
    'meanPertTrialTime', meanPertTrialTime,...
    'sdPertTrialTime', sdPertTrialTime,...
    'meanNonPertTrialTime', meanNonPertTrialTime,...
    'sdNonPertTrialTime', sdNonPertTrialTime,...
    'rawPertThresh', pertThresh,...
    'rawNonPertThresh', nonPertThresh,...
    'meanPertThreshTime', meanPertThreshTime,...
    'sdPertThreshTime', sdPertThreshTime,...
    'meanNonPertThreshTime', meanNonPertThreshTime,...
    'sdNonPertThreshTime', sdNonPertThreshTime,...
    'pertRestAngle', pertRestAngle,...
    'nonPertRestAngle', nonPertRestAngle,...
    'meanPertRestAngle', meanPertRestAngle,...
    'meanNonPertRestAngle', meanNonPertRestAngle,...
    'sdPertRestAngle', sdPertRestAngle,...
    'sdNonPertRestAngle', sdNonPertRestAngle);
