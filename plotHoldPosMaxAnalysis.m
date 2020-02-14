function plotHoldPosMaxAnalysis(in)
%function used to see if the rats are turning or wobbling during the
%holding period

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
ax1 = subplot(5,2,1);
ax2 = subplot(5,2,2);
ax3 = subplot(5,2,3);
ax4 = subplot(5,2,4);
ax5 = subplot(5,2,5);
ax6 = subplot(5,2,6);
ax7 = subplot(5,2,7);
ax8 = subplot(5,2,8);
ax9 = subplot(5,2,9);
ax10 = subplot(5,2,10);


xlabel(ax1,'Ticks');
xlabel(ax2,'Ticks');
xlabel(ax3,'Ticks');
xlabel(ax4,'Ticks');
xlabel(ax5,'Ticks');
xlabel(ax6,'Ticks');
xlabel(ax7,'Ticks');
xlabel(ax8,'Ticks');
xlabel(ax9,'Ticks');
xlabel(ax10,'Ticks');

%add ylabel
ylabel(ax1,'Position');
ylabel(ax2,'Position');
ylabel(ax3,'Position');
ylabel(ax4,'Position');
ylabel(ax5,'Position');
ylabel(ax6,'Position');
ylabel(ax7,'Position');
ylabel(ax8,'Position');
ylabel(ax9,'Position');
ylabel(ax10,'Position');

touchStatus = {};
kinematicsAligned = {};

%change index to -10 to get trials 10-20 with the issue and so on
index = 0;
%make a for-loop to access each trial
for i = 1:numel(allTrials)
    
    touchStatus{i} = allTrials(i).touchStatus;
    state{i} = allTrials(i).state;
    state3Start = find(state{i} == 3, 1);
    state3End = find(state{i} == 3, 1, 'last');
    touchStatusModified{i} = touchStatus{i}(state3Start:state3End);
    
    if any(touchStatusModified{i} == 1)
       %there was a touc}h in this trial, so we want to plot it
       index = index + 1;
       
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
       

       switch index
           case 1
               plot(ax1,kinematicsAligned{i});
               hold(ax1,'on');
               line(ax1,[minHoldTime minHoldTime], [-holdPosMax-2 holdPosMax+2],'Color','magenta');
               line(ax1,[0 minHoldTime+5], [-holdPosMax -holdPosMax], 'Color','green');
               line(ax1,[0 minHoldTime+5], [holdPosMax holdPosMax], 'Color','green');
               title(ax1,"Trial No. " + i + " " + hit);
           case 2
               plot(ax2,kinematicsAligned{i});
               hold(ax2,'on');
               line(ax2,[minHoldTime minHoldTime], [-holdPosMax-2 holdPosMax+2],'Color','magenta');
               line(ax2,[0 minHoldTime+5], [-holdPosMax -holdPosMax], 'Color','green');
               line(ax2,[0 minHoldTime+5], [holdPosMax holdPosMax], 'Color','green');
               title(ax2,"Trial No. " + i + " " + hit);
           case 3
               plot(ax3,kinematicsAligned{i});
               hold(ax3,'on');
               line(ax3,[minHoldTime minHoldTime], [-holdPosMax-2 holdPosMax+2],'Color','magenta');
               line(ax3,[0 minHoldTime+5], [-holdPosMax -holdPosMax], 'Color','green');
               line(ax3,[0 minHoldTime+5], [holdPosMax holdPosMax], 'Color','green');
               title(ax3,"Trial No. " + i + " " + hit);
           case 4
               plot(ax4,kinematicsAligned{i});
               hold(ax4,'on');
               line(ax4,[minHoldTime minHoldTime], [-holdPosMax-2 holdPosMax+2],'Color','magenta');
               line(ax4,[0 minHoldTime+5], [-holdPosMax -holdPosMax], 'Color','green');
               line(ax4,[0 minHoldTime+5], [holdPosMax holdPosMax], 'Color','green');
               title(ax4,"Trial No. " + i + " " + hit);
           case 5
               plot(ax5,kinematicsAligned{i});
               hold(ax5,'on');
               line(ax5,[minHoldTime minHoldTime], [-holdPosMax-2 holdPosMax+2],'Color','magenta');
               line(ax5,[0 minHoldTime+5], [-holdPosMax -holdPosMax], 'Color','green');
               line(ax5,[0 minHoldTime+5], [holdPosMax holdPosMax], 'Color','green');
               title(ax5,"Trial No. " + i + " " + hit)
           case 6
               plot(ax6,kinematicsAligned{i});
               hold(ax6,'on');
               line(ax6,[minHoldTime minHoldTime], [-holdPosMax-2 holdPosMax+2],'Color','magenta');
               line(ax6,[0 minHoldTime+5], [-holdPosMax -holdPosMax], 'Color','green');
               line(ax6,[0 minHoldTime+5], [holdPosMax holdPosMax], 'Color','green');
               title(ax6,"Trial No. " + i + " " + hit);
           case 7
               plot(ax7,kinematicsAligned{i});
               hold(ax7,'on');
               line(ax7,[minHoldTime minHoldTime], [-holdPosMax-2 holdPosMax+2],'Color','magenta');
               line(ax7,[0 minHoldTime+5], [-holdPosMax -holdPosMax], 'Color','green');
               line(ax7,[0 minHoldTime+5], [holdPosMax holdPosMax], 'Color','green');
               title(ax7,"Trial No. " + i + " " + hit);
           case 8
               plot(ax8,kinematicsAligned{i});
               hold(ax8,'on');
               line(ax8,[minHoldTime minHoldTime], [-holdPosMax-2 holdPosMax+2],'Color','magenta');
               line(ax8,[0 minHoldTime+5], [-holdPosMax -holdPosMax], 'Color','green');
               line(ax8,[0 minHoldTime+5], [holdPosMax holdPosMax], 'Color','green');
               title(ax8,"Trial No. " + i + " " + hit);
           case 9
               plot(ax9,kinematicsAligned{i});
               hold(ax9,'on');
               line(ax9,[minHoldTime minHoldTime], [-holdPosMax-2 holdPosMax+2],'Color','magenta');
               line(ax9,[0 minHoldTime+5], [-holdPosMax -holdPosMax], 'Color','green');
               line(ax9,[0 minHoldTime+5], [holdPosMax holdPosMax], 'Color','green');
               title(ax9,"Trial No. " + i + " " + hit);
           case 10
               plot(ax10,kinematicsAligned{i});
               hold(ax10,'on');
               line(ax10,[minHoldTime minHoldTime], [-holdPosMax-2 holdPosMax+2],'Color','magenta');
               line(ax10,[0 minHoldTime+5], [-holdPosMax -holdPosMax], 'Color','green');
               line(ax10,[0 minHoldTime+5], [holdPosMax holdPosMax], 'Color','green');
               title(ax10,"Trial No. " + i + " " + hit);
       end
    end
end

end