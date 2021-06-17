%%% getAllPellets(inputNameStr, sessionNumberToday)
%%% ----> inputNameStr is a string in the form of 'x', 'zabc', etc.
%%% ----> sessionNumberToday is the number of today's session (e.g. 1, 2)
%%%
%%% currently cannot do multiple sessions for each rat
function [] = getAllPellets(inputNameStr,sessionNumberToday)
    cntr = 0;
    
    for iName=num2cell(inputNameStr)
        trials = analyzeTaskData(iName,sessionNumberToday,'noplot');
        cntr = cntr + 1;

        getPellets(trials);
    end
end