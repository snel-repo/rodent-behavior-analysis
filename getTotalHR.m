%%% getTotalHR(inputNameStr, sessionNumberToday, catchTrialBoolean)
%%% ----> inputNameStr is a string in the form of 'x', 'zabc', etc.
%%% ----> sessionNumberToday is the number of today's session (e.g. 1, 2)
%%% ----> catchTrialBoolean determines whether to print catch trial stats 
%%% 
function [] = getTotalHR(inputNameStr,sessionNumberToday) %, catchTrialBoolean)
    
    % initialize counters
    sessionCntr = 1;
    nameCntr = 1;
    
    % preallocate arrays for food already eaten and food to give
    sessionHitsMatrix = zeros(length(inputNameStr),sessionNumberToday);
    sessionTrialCntMatrix = zeros(length(inputNameStr),sessionNumberToday);
    sessionHRmatrix = zeros(length(inputNameStr),sessionNumberToday);
    totalHitsMatrix = zeros(length(inputNameStr),1);
    totalTrialCntMatrix = zeros(length(inputNameStr),1);
    totalHRmatrix = zeros(length(inputNameStr),1);
    
    % iterate through each rat and each session, computing 
    for iName=num2cell(inputNameStr)
        
        % iterate through each session for the current selected rat name
        while sessionCntr < sessionNumberToday + 1
            trials = analyzeTaskData(iName,sessionCntr,'noplot');
            [sessionHR, sessionHits, sessionTrialCnt] = getHR(trials);
            sessionHRmatrix(nameCntr,sessionCntr) = sessionHR;
            sessionHitsMatrix(nameCntr,sessionCntr) = sessionHits;
            sessionTrialCntMatrix(nameCntr,sessionCntr) = sessionTrialCnt;
            sessionCntr = sessionCntr + 1;
        end
        
        % compute HR across all trials today
        totalHitsForRat = sum(sessionHitsMatrix(nameCntr,:));
        totalTrialCntForRat = sum(sessionTrialCntMatrix(nameCntr,:));
        totalHRforRat = totalHitsForRat/totalTrialCntForRat;
        totalHitsMatrix(nameCntr) = totalHitsForRat;
        totalTrialCntMatrix(nameCntr) = totalTrialCntForRat;
        totalHRmatrix(nameCntr) = totalHRforRat;
        nameCntr = nameCntr + 1;
        sessionCntr = 1; % reinitialize
    end
    % print results for food to give to each rat, respectively
    fprintf("\nTotal successful trials for rats %s, respectively:\n", inputNameStr)
    for iName=1:length(inputNameStr)
        fprintf("%u / %u successful trials. Hitrate: %.3f\n",totalHitsMatrix(iName),totalTrialCntMatrix(iName),totalHRmatrix(iName))
    end
    
%     fprintf("\nTotal s for rats %s, respectively:\n", inputNameStr)
%     fprintf("%.3f\n", totalHRmatrix')
end