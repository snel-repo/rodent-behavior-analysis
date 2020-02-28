function [filtData, baseLine] = touchFiltVariableHandler(in,currentTrial,touchTypeFlag)

try    
    switch touchTypeFlag
        case 0
            filtData = in.trials(currentTrial).touchFiltEx;
            baseLine = in.trials(currentTrial).touchBaselineEx;
        case 1
            filtData = in.trials(currentTrial).touchFiltMed;
            baseLine = in.trials(currentTrial).touchBaselineMed;
    end

catch
    filtData = in.trials(currentTrial).touchFilt;
    baseLine = in.trials(currentTrial).touchBaseline;
end
end