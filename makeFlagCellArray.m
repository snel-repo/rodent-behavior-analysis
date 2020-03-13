function [flagStruct] = makeFlagCellArray(in)
% [flagStruct] = makeFlagCellArray(in)
%       Input the 'trials' struct from analyzeTaskData, a struct will be
%       created with unique flags stored in the flagStruct.flagsFound field
%       and the corresponding indeces of all trial flags found in the
%       session will be stored in a cell array at flagStruct.flagCellArray

    flagsFoundInThisSession = int8(unique([in.trials.flagFail]));
    if any([in.trials.catchTrialFlag]) % are there any catch trials? 
        flagsFoundInThisSession = [-1 flagsFoundInThisSession]; % preappend the catch trial flag: -1
    end
    cellArrayLength = length(flagsFoundInThisSession);
    flagCellArray = cell(cellArrayLength,1);
    for ii=1:cellArrayLength
        flagCellArray{ii} = findFlags(in, flagsFoundInThisSession(ii));
    end
    
    % build struct to keep organization of which cells represent which flags
    flagStruct.flagsFound = flagsFoundInThisSession; % these flags are like titles for the cells below (tells you what's in the cells)
    flagStruct.flagCellArray = flagCellArray; % actual flag indeces for each flag found
end