function singleTrialAutoTurnDebugger(in)
%this function plots a single trial given the trial index which is found
%by seeing the trial from plotTenTrials...
%This gives a more indepth observation of the trial
session = in(1);

%now have session, want to get all the trials in session
allTrials = session.trials;

trialIndex = input('Please select Trial Number: ');
singleTrial = allTrials(trialIndex);
keyboard
minY = min(singleTrial.touchFiltEx);
maxY = max(singleTrial.touchFiltEx);
%want to plot vertical lines for where motor current starts
%and stops
currentStartIndex = find(singleTrial.motorCurrent ~= 0,1);
currentStopIndex = find(singleTrial.motorCurrent(currentStartIndex : end) == 0,1) + currentStartIndex;

if (singleTrial.hitTrial == 1)
   hit = 'Hit';
else
   hit = 'Fail';
end

state = singleTrial.state;
state(state==1) = minY;
state(state==3) = minY + 15;
state(state==5) = minY + 30;
f = figure('Name',"SingleTrialAutoTurnDebugger" + singleTrial.subject);
ax2 = subplot(4,1,2);
ax1 = subplot(4,1,1);
ax3 = subplot(4,1,3);
ax4 = subplot(4,1,4);

plot(ax1,singleTrial.touchFiltEx);
hold(ax1, 'on');
plot(ax1,singleTrial.touchBaselineEx);
line(ax1,[currentStartIndex currentStartIndex], [minY maxY],'Color','magenta');
line(ax1,[currentStopIndex currentStopIndex], [minY maxY],'Color','magenta');
title(ax1,"Trial No. " + trialIndex + " " + hit + " " + singleTrial.flagFail);
plot(ax1,state);
touchStatusFormatted = singleTrial.touchStatus;
touchStatusFormatted(touchStatusFormatted == 1) = maxY;
touchStatusFormatted(touchStatusFormatted == 0) = minY;
plot(ax1, touchStatusFormatted);
legend(ax1,'TouchFilt','TouchBaseline','Motor Current Start','Motor Current Stop','State','TouchStatus')

plot(ax2,singleTrial.motorCurrent);
hold(ax2, 'on');
title(ax2,"Trial No. " + trialIndex + " Motor Current");

plot(ax3,singleTrial.velRaw);
hold(ax3, 'on');
line(ax3,[0 numel(singleTrial.velRaw)], [singleTrial.minVelThresh singleTrial.minVelThresh], 'Color','green');
line(ax3,[0 numel(singleTrial.velRaw)], [-double(singleTrial.minVelThresh) -double(singleTrial.minVelThresh)], 'Color','green');
title(ax3,"Velocity and MinVelThresh");
legend(ax3,'velRaw','minVelThresh');

plot(ax4,singleTrial.pos);
hold(ax4, 'on');
title(ax4,"Knob Pos");

linkaxes([ax1, ax2, ax3, ax4], 'x');
end