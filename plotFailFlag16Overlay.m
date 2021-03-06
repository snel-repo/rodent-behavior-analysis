function plotFailFlag16Overlay(in)
%function plots the kinematics of all the trials in a session that have
%failFlag 16

%variables to adjust if needed

minHoldTime = 30;
holdPosMax = 6;

%only use 1 for now to plot one session
session = in(1);

%now have session, want to get all the trials in session
allTrials = session.trials;
%so, first make figure and subplots
figure('Name',"HoldPosMax Analysis " + allTrials(1).subject);
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
hold('on');
touchStatus = {};
kinematicsAligned = {};
xlabel('Ticks');
ylabel('Position');
title('Analysis of Rat Turning Behavior - black is catchTrial');
line([minHoldTime minHoldTime], [-holdPosMax-2 holdPosMax+2],'Color','magenta');
line([0 minHoldTime+120], [-holdPosMax -holdPosMax], 'Color','red');
line([0 minHoldTime+120], [holdPosMax holdPosMax], 'Color','red', 'HandleVisibility', 'off');

for i = 1:numel(allTrials)
    touchStatus{i} = allTrials(i).touchStatus;
    state{i} = allTrials(i).state;
    state3Start = find(state{i} == 3, 1);
    state3End = find(state{i} == 3, 1, 'last');
    touchStatusModified{i} = touchStatus{i}(state3Start:state3End);
    
    if (allTrials(i).flagFail == 16)  
       %want to align them to first touch
       firstTouch = find(touchStatusModified{i}, 1) + state3Start - 1;
       endOfHoldingPeriod = firstTouch + minHoldTime;
       
       endXForKine = endOfHoldingPeriod + 20;
       kinematicsAligned{i} = allTrials(i).pos(firstTouch:endXForKine);
       if (allTrials(i).catchTrialFlag)
           plot(kinematicsAligned{i}, 'Color','black');
       else
           plot(kinematicsAligned{i}, 'Color','cyan');
       end
    end
    if (allTrials(i).flagFail == 0)
        %want to align them to first touch
       firstTouch = find(touchStatusModified{i}, 1) + state3Start - 1;
       endOfHoldingPeriod = firstTouch + minHoldTime;
       
       endXForKine = endOfHoldingPeriod + 120;
       kinematicsAligned{i} = allTrials(i).pos(firstTouch:endXForKine);
       if (allTrials(i).catchTrialFlag)
           plot(kinematicsAligned{i}, 'Color','black');
       else
           plot(kinematicsAligned{i}, 'Color','green');
       end
       currentStartIndex = find(allTrials(i).motorCurrent ~= 0,1);
       try
       line([currentStartIndex-firstTouch currentStartIndex-firstTouch], [-holdPosMax-2 holdPosMax+2], 'Color', 'blue');
       catch
       end
    end
end
    legend('minHoldTime', 'holdPosMax', 'failFlag16Kinematics', 'failFlag0Kinematics', 'motorCurrentStart');
    
    
end
