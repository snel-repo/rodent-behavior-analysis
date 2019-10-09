function dataLogger(trialData, taskParams, pertParams, saveDirectory)
allStruct = catstruct(trialData,...
    taskParams,...
    pertParams);
mkdir(saveDirectory)
outputFileName = sprintf('%strialData.mat', saveDirectory);
save(outputFileName, 'allStruct')

