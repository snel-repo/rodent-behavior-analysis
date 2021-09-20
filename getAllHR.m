%%% getAllHR(inputNameStr, sessionNumberToday, catchTrialBoolean)
%%% ----> inputNameStr is a string in the form of 'x', 'zabc', etc.
%%% ----> sessionNumberToday is the number of today's session (e.g. 1, 2)
%%% ----> catchTrialBoolean determines whether to print catch trial stats
%%%
%%% currently cannot do multiple sessions for each rat

function [] = getAllHR(inputNameStr,sessionNumberToday,catchTrialBoolean)
    cntr = 0;

    for iName=num2cell(inputNameStr)
        trials = analyzeTaskData(iName,sessionNumberToday,'noplot');
        cntr = cntr + 1;

        getHR(trials);
    
        inputIdxRng = varargin{1};
        subsetHitFlags = allHitFlags(inputIdxRng);
        hitIdxs = subsetHitFlags(subsetHitFlags==1); numHits = length(hitIdxs);
        %missIdxs = subsetHitFlags(subsetHitFlags==0); numMiss = length(missIdxs);
        trialCount = length(subsetHitFlags);
        HR = numHits/trialCount;
        
        if catchTrialBoolean
            getHR(trials,findFlags(trials,-1));
        end
    end
end