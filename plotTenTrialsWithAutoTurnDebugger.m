function plotTenTrialsWithAutoTurnDebugger(in)
%this one plots the first ten trials that have an autoturn movement
session = in(1);

%now have session, want to get all the trials in session
allTrials = session.trials;

%so, first make figure and subplots

%%
figure('Name',"TenTrialsWithAutoTurnDebugger" + allTrials(1).subject);
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
ax1 = subplot(5,2,1,'ButtonDownFcn',@createNewFig);
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
ylabel(ax1,'Capcitance(C)');
ylabel(ax2,'Capcitance(C)');
ylabel(ax3,'Capcitance(C)');
ylabel(ax4,'Capcitance(C)');
ylabel(ax5,'Capcitance(C)');
ylabel(ax6,'Capcitance(C)');
ylabel(ax7,'Capcitance(C)');
ylabel(ax8,'Capcitance(C)');
ylabel(ax9,'Capcitance(C)');
ylabel(ax10,'Capcitance(C)');

touchStatus = {};
motorCurrent = {};
index = 0;

%%
%make a for-loop to access each trial
for i = 1:numel(allTrials)
   touchStatus{i} = allTrials(i).touchStatus;
   motorCurrent{i} = allTrials(i).motorCurrent;
   if any(touchStatus{i} == 1) && any(motorCurrent{i} ~= 0)
       %there was a touc}h in this trial, so we want to plot it
       index = index + 1;
       %want to plot vertical lines for where motor current starts
       %and stops
       currentStartIndex = find(motorCurrent{i} == 30,1);
       currentStopIndex = find(motorCurrent{i}(currentStartIndex : end) == 0,1) + currentStartIndex;
       %need to find yLims
       %find lowest point
       minY = min(allTrials(i).touchFilt);
       maxY = max(allTrials(i).touchFilt);
       if (allTrials(i).hitTrial == 1)
           hit = 'Hit';
       else
           hit = 'Fail';
       end
       switch index
           case 1
               plot(ax1,allTrials(i).touchFilt);
               hold(ax1,'on');
               plot(ax1,allTrials(i).touchBaseline);
               line(ax1,[currentStartIndex currentStartIndex], [minY maxY],'Color','magenta');
               line(ax1,[currentStopIndex currentStopIndex], [minY maxY],'Color','magenta');
               title(ax1,"Trial No. " + i + " " + hit);
           case 2
               plot(ax2,allTrials(i).touchFilt);
               hold(ax2,'on');
               plot(ax2,allTrials(i).touchBaseline);
               line(ax2,[currentStartIndex currentStartIndex], [minY maxY],'Color','magenta');
               line(ax2,[currentStopIndex currentStopIndex], [minY maxY],'Color','magenta');
               title(ax2,"Trial No. " + i + " " + hit);
           case 3
               plot(ax3,allTrials(i).touchFilt);
               hold(ax3,'on');
               plot(ax3,allTrials(i).touchBaseline);
               line(ax3,[currentStartIndex currentStartIndex], [minY maxY],'Color','magenta');
               line(ax3,[currentStopIndex currentStopIndex], [minY maxY],'Color','magenta');
               title(ax3,"Trial No. " + i + " " + hit);
           case 4
               plot(ax4,allTrials(i).touchFilt);
               hold(ax4,'on');
               plot(ax4,allTrials(i).touchBaseline);
               line(ax4,[currentStartIndex currentStartIndex], [minY maxY],'Color','magenta');
               line(ax4,[currentStopIndex currentStopIndex], [minY maxY],'Color','magenta');
               title(ax4,"Trial No. " + i + " " + hit);
           case 5
               plot(ax5,allTrials(i).touchFilt);
               hold(ax5,'on');
               plot(ax5,allTrials(i).touchBaseline);
               line(ax5,[currentStartIndex currentStartIndex], [minY maxY],'Color','magenta');
               line(ax5,[currentStopIndex currentStopIndex], [minY maxY],'Color','magenta');
               title(ax5,"Trial No. " + i + " " + hit);
           case 6
               plot(ax6,allTrials(i).touchFilt);
               hold(ax6,'on');
               plot(ax6,allTrials(i).touchBaseline);
               line(ax6,[currentStartIndex currentStartIndex], [minY maxY],'Color','magenta');
               line(ax6,[currentStopIndex currentStopIndex], [minY maxY],'Color','magenta');
               title(ax6,"Trial No. " + i + " " + hit);
           case 7
               plot(ax7,allTrials(i).touchFilt);
               hold(ax7,'on');
               plot(ax7,allTrials(i).touchBaseline);
               line(ax7,[currentStartIndex currentStartIndex], [minY maxY],'Color','magenta');
               line(ax7,[currentStopIndex currentStopIndex], [minY maxY],'Color','magenta');
               title(ax7,"Trial No. " + i + " " + hit);
           case 8
               plot(ax8,allTrials(i).touchFilt);
               hold(ax8,'on');
               plot(ax8,allTrials(i).touchBaseline);
               line(ax8,[currentStartIndex currentStartIndex], [minY maxY],'Color','magenta');
               line(ax8,[currentStopIndex currentStopIndex], [minY maxY],'Color','magenta');
               title(ax8,"Trial No. " + i + " " + hit);
           case 9
               plot(ax9,allTrials(i).touchFilt);
               hold(ax9,'on');
               plot(ax9,allTrials(i).touchBaseline);
               line(ax9,[currentStartIndex currentStartIndex], [minY maxY],'Color','magenta');
               line(ax9,[currentStopIndex currentStopIndex], [minY maxY],'Color','magenta');
               title(ax9,"Trial No. " + i + " " + hit);
           case 10
               plot(ax10,allTrials(i).touchFilt);
               hold(ax10,'on');
               plot(ax10,allTrials(i).touchBaseline);
               line(ax10,[currentStartIndex currentStartIndex], [minY maxY],'Color','magenta');
               line(ax10,[currentStopIndex currentStopIndex], [minY maxY],'Color','magenta');
               title(ax10,"Trial No. " + i + " " + hit);
       end
   end
end