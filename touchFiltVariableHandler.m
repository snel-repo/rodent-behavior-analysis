function [filtData, baseLine] = touchFiltVariableHandler(in,currentTrial,touchTypeFlag)
% This function is for compatibility with previously logged data (before 
% Feb 2020). We recently began calculating and saving exponential moving 
% averaged touch data and median filtered data. Before we only saved EMA 
% data. This function checks for new format, and if an error arises, 
% reverts to original format. Sean O.

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