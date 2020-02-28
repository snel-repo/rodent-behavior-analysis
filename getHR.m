function [HR] = getHR(in,varargin)
% [HR] = getHR(in)  OR  [HR] = getHR(in,indexRange)
% input the in parameter from analyzeTaskData, output the hitrate
% (optional) input the indexRange for inspection [as, a, vector]

allHits=[in.trials.hitTrial];

if nargin == 1
    HR = length(allHits(allHits==1))/(length(allHits(allHits==0))+length(allHits(allHits==1)));
elseif nargin == 2
    inputIdxRng = varargin{1};
    subHits = allHits(inputIdxRng);
    HR = length(subHits(subHits==1))/(length(subHits(subHits==0))+length(subHits(subHits==1)));
end
end