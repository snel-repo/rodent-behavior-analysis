 
allMaxCurr = zeros(length(in.trials),1);
for ii=1:length(in.trials)
    allMaxCurr(ii) = max(in.trials(ii).motorCurrent);
end

allMaxCurrNzIdx = find(allMaxCurr~=0);
disp(allMaxCurrNzIdx)