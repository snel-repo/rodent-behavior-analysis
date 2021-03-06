%dataLoggerAndPlotter
close all
trialData = struct(...
    'velEncoder', vel,...
    'posEncoder', pos,...
    'pertCurrent', current,...
    'taskDir', dirTask,...
    'pertDir', pertDir,...
    'state', state,...
    'rawEncoder', rawspeed,...
    'speakerFreq', speaker,...
    'sampleRate', sampleTime,...
    'timeSpanLog', timeSpan,...
    'pertEnable', enable,...
    'timeElapsedState', timeElapsedState,...
    'flagFail', flagFail,...
    'trialNum', trialNum,...
    'successNum', successNum);

saveDirectory = setSaveDirectory;
dataLogger(trialData, taskParams, pertParams, saveDirectory);
trialPlotter(trialData, saveDirectory);