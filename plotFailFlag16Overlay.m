function plotFailFlag16Overlay(in)
%function plots the kinematics of all the trials in a session that have
%failFlag 16

%variables to adjust if needed

minHoldTime = 25;
holdPosMax = 6;
%only use 1 for now to plot one session
session = in(1);

%now have session, want to get all the trials in session
allTrials = session.trials;
%so, first make figure and subplots
figure('Name',"HoldPosMax Analysis " + allTrials(1).subject);
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);

touchStatus = {};
kinematicsAligned = {};
%hodlPosMax and minHoldTime lines
line([minHoldTime minHoldTime], [-holdPosMax-2 holdPosMax+2],'Color','magenta');
hold('on');
line([0 minHoldTime+5], [-holdPosMax -holdPosMax], 'Color','green');
line([0 minHoldTime+5], [holdPosMax holdPosMax], 'Color','green');

index = 0;
for i = 1:numel(allTrials)
    touchStatus{i} = allTrials(i).touchStatus;
    state{i} = allTrials(i).state;
    state3Start = find(state{i} == 3, 1);
    state3End = find(state{i} == 3, 1, 'last');
    touchStatusModified{i} = touchStatus{i}(state3Start:state3End);
    
    if (allTrials(i).flagFail == 16)  
       if (allTrials(i).hitTrial == 1)
           hit = 'Hit';
       else
           hit = 'Fail';
       end
 
       %want to align them to first touch
       firstTouch = find(touchStatusModified{i}, 1) + state3Start - 1;
       endOfHoldingPeriod = firstTouch + minHoldTime;
       
       endXForKine = endOfHoldingPeriod + 20;
       kinematicsAligned{i} = allTrials(i).pos(firstTouch:endXForKine);
       keyboard
       plot(kinematicsAligned{i}, 'Color','blue');
       index = index + 1;
    end
end
end
