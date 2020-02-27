function plotTouchFiltDebugger(in)
%function that plots a single trial and looks at both the Ex and Me
%touchFilts and baselines

session = in(1);

%now have session, want to get all the trials in session
allTrials = session.trials;

trialIndex = input('Please select Trial Number: ');
singleTrial = allTrials(trialIndex);


%want to plot vertical lines for where motor current starts
%and stops
try 
currentStartIndex = find(singleTrial.motorCurrent ~= 0,1);
currentStopIndex = find(singleTrial.motorCurrent(currentStartIndex : end) == 0,1) + currentStartIndex;
catch
end

if (singleTrial.hitTrial == 1)
   hit = 'Hit';
else
   hit = 'Fail';
end


f = figure('Name',"SingleTrialAutoTurnDebugger" + singleTrial.subject);

ax1 = subplot(3,1,1);
ax2 = subplot(3,1,2);
ax3 = subplot(3,1,3);
%% Subplot 1 Exponential Filt
minYEx = min(singleTrial.touchFiltEx);
maxYEx = max(singleTrial.touchFiltEx);
plot(ax1,singleTrial.touchFiltEx);
hold(ax1, 'on');
plot(ax1,singleTrial.touchBaselineEx);
title(ax1,"Trial No. " + trialIndex + " " + hit + " " + singleTrial.flagFail + " ExponentialFilt");
touchStateExFormatted = cast(singleTrial.touchStateEx, 'uint16');
touchStateExFormatted(touchStateExFormatted == 1) = maxYEx;
touchStateExFormatted(touchStateExFormatted == 0) = minYEx;
plot(ax1, touchStateExFormatted);
try
line(ax1,[currentStartIndex currentStartIndex], [minYEx maxYEx],'Color','magenta');
line(ax1,[currentStopIndex currentStopIndex], [minYEx maxYEx],'Color','magenta');
catch
end
legend(ax1,'TouchFiltEx','TouchBaselineEx','TouchStateEx','Motor Current Start','Motor Current Stop')
%% Subplot 2 Median Filt
minYMed = min(singleTrial.touchFiltMed);
maxYMed = max(singleTrial.touchFiltMed);
plot(ax2,singleTrial.touchFiltMed);
hold(ax2, 'on');
plot(ax2,singleTrial.touchBaselineMed);
title(ax2,"Trial No. " + trialIndex + " " + hit + " " + singleTrial.flagFail + " MedianFilt");
touchStateMedFormatted = cast(singleTrial.touchStateMed, 'uint16');
touchStateMedFormatted(touchStateMedFormatted == 1) = maxYMed;
touchStateMedFormatted(touchStateMedFormatted == 0) = minYMed;
plot(ax2, touchStateMedFormatted);
try
line(ax2,[currentStartIndex currentStartIndex], [minYMed maxYMed],'Color','magenta');
line(ax2,[currentStopIndex currentStopIndex], [minYMed maxYMed],'Color','magenta');
catch
end

%% Subplot 3 Touch Status and State
plot(ax3, singleTrial.touchStatus, 'Color', 'y');
hold(ax3, 'on');
plot(ax3, singleTrial.state);
legend('touchStatus', 'state')
end