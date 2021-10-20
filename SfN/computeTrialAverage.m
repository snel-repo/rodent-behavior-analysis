function [trialAverage] = computeTrialAverage(data,indexes,start_list,len)

    trialSum = zeros(len,1);
    for i = indexes
        start = start_list{i};
        data{i}(start:start+len-1);
        trialSum = trialSum + data{i}(start:start+len-1);
    end

    trialAverage = trialSum/length(indexes);
end