function [filtData, baseLine] = touchFiltVariableHandler(in,currentTrial)
    try
    filtData = in.trials(currentTrial).touchFiltEx;
    baseLine = in.trials(currentTrial).touchBaselineEx;
    catch
    filtData = in.trials(currentTrial).touchFilt;
    baseLine = in.trials(currentTrial).touchBaseline;
    end
end