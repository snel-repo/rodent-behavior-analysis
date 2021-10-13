
clear all;
close all;

ratName = 'B';

d = loadDataSessions(ratName);

plotInfo = {};
plotInfo.ratName = ratName;
plotInfo.sessionDateTimeAndSaveTag = '2021';
plotInfo.ylabel = 'Angular position (deg)';
plotInfo.varName = 'Position';
%plotInfo.HRstr1 = strcat(string(sum(hitCatchTrialsIdxs)),"/",string(sum(catchTrialIdxs)));
%plotInfo.HRstr2 = strcat(string(sum(hitNonCatchTrialsIdxs)),"/",string(sum(nonCatchTrialIdxs)));

plotAlignedAll(d.trialTime, d.moveOnset, d.motorCurrent, d.timeMax, d.conditionTrial, d.validTrial, plotInfo, 1, 10);

plotAlignedAll(d.trialTime, d.moveOnset, d.motorCurrentCom, d.timeMax, d.conditionTrial, d.validTrial, plotInfo, 1, 10);