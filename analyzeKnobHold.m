function summary = analyzeKnobHold(in, sessionTag)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Tony Corsten, tony.corsten93@gmail.com
% Date: 9/11/2018
% Purpose: produce summary information for the knob holding task. If you
% want to add more summary metrics, just add a new field in the form of :
% summary(i).NewMetric = MetricValue
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:length(in)
    summary(i).trialNum = length(in(i).trials);
    summary(i).hitNum = sum([in(i).trials(:).hitTrial]);
    summary(i).hitRate = sum([in(i).trials(:).hitTrial]) / length(in(i).trials); % compute hit rate 
    tmp = [in(i).trials(:).timeHoldMax]; % set temp variable for all max hold times 
%     ol = isoutlier(tmp); % determine indices for outliers 
%     tmp = tmp(~ol); % remove outliers 
    summary(i).meanTimeHoldThresh = mean([in(i).trials(:).timeHoldThresh]); % compute mean of threshold hold times 
    summary(i).medianTimeHoldThresh = median([in(i).trials(:).timeHoldThresh]);
    summary(i).meanTimeHoldMax = mean(tmp); % compute mean of max hold times
    summary(i).medianTimeHoldMax = median(tmp); % compute mean of max hold times
    summary(i).stdTimeHoldThresh = std([in(i).trials(:).timeHoldThresh]); % compute stdev of threshold hold times 
    summary(i).stdTimeHoldMax = std(tmp); % compute stdev of max hold times 
    summary(i).bottomHoldThresh = min([in(i).trials(:).timeHoldThresh]);
    summary(i).sessionTag = sessionTag{i};
    summary(i).madThresh = mad([in(i).trials(:).timeHoldThresh], 1);
    summary(i).madMax = mad([in(i).trials(:).timeHoldMax], 1);
    summary(i).iqrThresh = iqr([in(i).trials(:).timeHoldThresh]);
    summary(i).iqrMax = iqr([in(i).trials(:).timeHoldMax]);
end


