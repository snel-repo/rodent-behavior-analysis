%%%%% need to finish this function: currently cannot do multiple sessions
%%%%% for each rat
function [] = getAllHR(inputNameStr,numSessions,catchTrialBoolean)
    cntr = 0;
    % cellArray = cell(length(inputNameStr),1);
    for iName=num2cell(inputNameStr)
        trials = analyzeTaskData(iName,numSessions,'noplot');
        cntr = cntr + 1;
        % cellArray(cntr) = 
        getHR(trials);
    
        if catchTrialBoolean
            getHR(trials,findFlags(trials,-1));
        end
    end
end