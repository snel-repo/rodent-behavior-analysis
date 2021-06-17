%%% getTotalPellets(inputNameStr, sessionNumberToday)
%%% ----> inputNameStr is a string in the form of 'x', 'zabc', etc.
%%% ----> sessionNumberToday is the number of sessions today (e.g. 1, 2)
%%%
function [] = getTotalPellets(inputNameStr,sessionNumberToday)
    
    % initialize counters
    sessionCntr = 1;
    nameCntr = 1;
    
    % preallocate arrays for food already eaten and food to give
    pelletsEatenMatrix = zeros(length(inputNameStr),sessionNumberToday);
    giveFoodVector = zeros(length(inputNameStr),1);
    
    % iterate through each rat and each session, computing 
    for iName=num2cell(inputNameStr)
        
        % iterate through each session for the current selected rat name
        while sessionCntr < sessionNumberToday + 1
            trials = analyzeTaskData(iName,sessionCntr,'noplot');
            pelletWeightG = getPellets(trials);
            pelletsEatenMatrix(nameCntr,sessionCntr) = pelletWeightG;
            sessionCntr = sessionCntr + 1;
        end
        
        % compute food to give as sum of food eaten subtracted from 10g
        giveFoodWeightG = round(abs(10-sum(pelletsEatenMatrix(nameCntr,:))));
        giveFoodVector(nameCntr) = giveFoodWeightG;
        nameCntr = nameCntr + 1;
        sessionCntr = 1; % reinitialize
    end
    % print results for food to give to each rat, respectively
    fprintf("\nGive food to rats %s, respectively:\n\n", inputNameStr)
    fprintf("%.0fg\n", giveFoodVector')
end