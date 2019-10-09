function plotKnobTurnPerturbation(in, summary)
blockSize = inputFlex('How many trials per analysis group?: ', [1 inf], 3);
for i = 1 : length(in)
    tmp = in(i).trials;
    blockNum = tmp(i).trials(1).blockNum;
    blockArray = 1:blockNum;
    blockArray = reshape(blockArray, blockNum / blockSize, blockSize);
    vals = [];
    tmpName = {};
    for j = 1 : size(blockArray,1)
        indices = ismember([tmp(:).maxAngleTrialOnly], blockArray(j, :));
        vals = [vals tmp(indices).maxAngleTrialOnly];
        [tmpName{1:sum(indices)}] = deal(char(96+j));
    end
end