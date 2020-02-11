function plotTenTrialsWithAutoTurnDebuggerZoomedIn(in)
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
state = {}
index = -10;

%%
%make a for-loop to access each trial
for i = 1:numel(allTrials)
   touchStatus{i} = allTrials(i).touchStatus;
   motorCurrent{i} = allTrials(i).motorCurrent;
   state{i} = allTrials(i).state;
   touchStatusNormalized{i} = allTrials(i).touchStatus;
   if any(touchStatus{i} == 1) && any(motorCurrent{i} ~= 0)
       %there was a touc}h in this trial, so we want to plot it
       index = index + 1;
       %want to plot vertical lines for where motor current starts
       %and stops
       currentStartIndex = find(motorCurrent{i} == 30,1);
       currentStopIndex = find(motorCurrent{i}(currentStartIndex : end) == 0,1) + currentStartIndex;
       
       %since zoomed in, what to format the vectors for touchFilt and
       %touchBaseline
       zoomXBegin = currentStartIndex - 100; %100 is buffer
       zoomXEnd = currentStopIndex + 250;%250 is buffer
       
       
       touchFiltModified{i} = allTrials(i).touchFilt(zoomXBegin : zoomXEnd);
       touchBaselineModified{i} = allTrials(i).touchBaseline(zoomXBegin : zoomXEnd);
       
       %recalculate currentStartIndex and currentStartIndex
%        currentStartIndex = 100;
%        currentStopIndex = zoomXEnd - zoomXBegin - 250;
       
       %need to find yLims
       %find lowest point
       minY = min(allTrials(i).touchFilt);
       maxY = max(allTrials(i).touchFilt);
       if (allTrials(i).hitTrial == 1)
           hit = 'Hit';
       else
           hit = 'Fail';
       end
       
       x = (zoomXBegin:1:zoomXEnd);
       
       %want to plot state, modify state so visible on graph
       state{i}(state{i}==1) = minY;
       state{i}(state{i}==3) = minY+15;
       state{i}(state{i}==5) = minY+30;
       state{i} = state{i}(zoomXBegin : zoomXEnd);
       
       %want to plot touchSensor
       
       touchStatusNormalized{i}(touchStatusNormalized{i}==1) = minY + 44;
       touchStatusNormalized{i}(touchStatusNormalized{i}==0) = minY + 2;
       touchStatusNormalized{i} = touchStatusNormalized{i}(zoomXBegin : zoomXEnd);
       switch index
           case 1
               plot(ax1,x,touchFiltModified{i});
               hold(ax1,'on');
               plot(ax1,x,touchBaselineModified{i});
               line(ax1,[currentStartIndex currentStartIndex], [minY maxY],'Color','magenta');
               line(ax1,[currentStopIndex currentStopIndex], [minY maxY],'Color','magenta');
               title(ax1,"Trial No. " + i + " " + hit + " " + allTrials(i).flagFail);
               plot(ax1,(zoomXBegin :1: zoomXEnd), state{i});
               plot(ax1,(zoomXBegin :1: zoomXEnd), touchStatusNormalized{i});
               legend(ax1,'TouchFilt','Baseline','Motor Current Start', 'Motor Current End','State','touchstatus');
           case 2
               plot(ax2,x,touchFiltModified{i});
               hold(ax2,'on');
               plot(ax2,x,touchBaselineModified{i});
               line(ax2,[currentStartIndex currentStartIndex], [minY maxY],'Color','magenta');
               line(ax2,[currentStopIndex currentStopIndex], [minY maxY],'Color','magenta');
               title(ax2,"Trial No. " + i + " " + hit + " " + allTrials(i).flagFail);
               plot(ax2,(zoomXBegin :1: zoomXEnd), state{i});
               plot(ax2,(zoomXBegin :1: zoomXEnd), touchStatusNormalized{i});
           case 3
               plot(ax3,x,touchFiltModified{i});
               hold(ax3,'on');
               plot(ax3,x,touchBaselineModified{i});
               line(ax3,[currentStartIndex currentStartIndex], [minY maxY],'Color','magenta');
               line(ax3,[currentStopIndex currentStopIndex], [minY maxY],'Color','magenta');
               title(ax3,"Trial No. " + i + " " + hit + " " + allTrials(i).flagFail);
               plot(ax3,(zoomXBegin :1: zoomXEnd), state{i});
               plot(ax3,(zoomXBegin :1: zoomXEnd), touchStatusNormalized{i});
           case 4
               plot(ax4,x,touchFiltModified{i});
               hold(ax4,'on');
               plot(ax4,x,touchBaselineModified{i});
               line(ax4,[currentStartIndex currentStartIndex], [minY maxY],'Color','magenta');
               line(ax4,[currentStopIndex currentStopIndex], [minY maxY],'Color','magenta');
               title(ax4,"Trial No. " + i + " " + hit + " " + allTrials(i).flagFail);
               plot(ax4,(zoomXBegin :1: zoomXEnd), state{i});
               plot(ax4,(zoomXBegin :1: zoomXEnd), touchStatusNormalized{i});
           case 5
               plot(ax5,x,touchFiltModified{i});
               hold(ax5,'on');
               plot(ax5,x,touchBaselineModified{i});
               line(ax5,[currentStartIndex currentStartIndex], [minY maxY],'Color','magenta');
               line(ax5,[currentStopIndex currentStopIndex], [minY maxY],'Color','magenta');
               title(ax5,"Trial No. " + i + " " + hit + " " + allTrials(i).flagFail);
               plot(ax5,(zoomXBegin :1: zoomXEnd), state{i});
               plot(ax5,(zoomXBegin :1: zoomXEnd), touchStatusNormalized{i});
           case 6
               plot(ax6,x,touchFiltModified{i});
               hold(ax6,'on');
               plot(ax6,x,touchBaselineModified{i});
               line(ax6,[currentStartIndex currentStartIndex], [minY maxY],'Color','magenta');
               line(ax6,[currentStopIndex currentStopIndex], [minY maxY],'Color','magenta');
               title(ax6,"Trial No. " + i + " " + hit + " " + allTrials(i).flagFail);
               plot(ax6,(zoomXBegin :1: zoomXEnd), state{i});
               plot(ax6,(zoomXBegin :1: zoomXEnd), touchStatusNormalized{i});
           case 7
               plot(ax7,x,touchFiltModified{i});
               hold(ax7,'on');
               plot(ax7,x,touchBaselineModified{i});
               line(ax7,[currentStartIndex currentStartIndex], [minY maxY],'Color','magenta');
               line(ax7,[currentStopIndex currentStopIndex], [minY maxY],'Color','magenta');
               title(ax7,"Trial No. " + i + " " + hit + " " + allTrials(i).flagFail);
               plot(ax7,(zoomXBegin :1: zoomXEnd), state{i});
               plot(ax7,(zoomXBegin :1: zoomXEnd), touchStatusNormalized{i});
           case 8
               plot(ax8,x,touchFiltModified{i});
               hold(ax8,'on');
               plot(ax8,x,touchBaselineModified{i});
               line(ax8,[currentStartIndex currentStartIndex], [minY maxY],'Color','magenta');
               line(ax8,[currentStopIndex currentStopIndex], [minY maxY],'Color','magenta');
               title(ax8,"Trial No. " + i + " " + hit + " " + allTrials(i).flagFail);
               plot(ax8,(zoomXBegin :1: zoomXEnd), state{i});
               plot(ax8,(zoomXBegin :1: zoomXEnd), touchStatusNormalized{i});
           case 9
               plot(ax9,x,touchFiltModified{i});
               hold(ax9,'on');
               plot(ax9,x,touchBaselineModified{i});
               line(ax9,[currentStartIndex currentStartIndex], [minY maxY],'Color','magenta');
               line(ax9,[currentStopIndex currentStopIndex], [minY maxY],'Color','magenta');
               title(ax9,"Trial No. " + i + " " + hit + " " + allTrials(i).flagFail);
               plot(ax9,(zoomXBegin :1: zoomXEnd), state{i});
               plot(ax9,(zoomXBegin :1: zoomXEnd), touchStatusNormalized{i});
           case 10
%                plot(ax10,x,touchFiltModified{i}/max(touchFiltModified{i}));
               plot(ax10,x,touchFiltModified{i});
               hold(ax10,'on');
%                plot(ax10,x,touchBaselineModified{i}/max(touchBaselineModified{i}));
               plot(ax10,x,touchBaselineModified{i});
               line(ax10,[currentStartIndex currentStartIndex], [minY maxY],'Color','magenta');
               line(ax10,[currentStopIndex currentStopIndex], [minY maxY],'Color','magenta');
%                line(ax10,[currentStartIndex currentStartIndex], [min(touchFiltModified{i})/max(touchFiltModified{i}) 1],'Color','magenta');
%                line(ax10,[currentStopIndex currentStopIndex], [min(touchFiltModified{i})/max(touchFiltModified{i}) 1],'Color','magenta');
               title(ax10,"Trial No. " + i + " " + hit+ " " + allTrials(i).flagFail);
%                plot(ax10,(zoomXBegin :1: zoomXEnd), state{i}/max(state{i}));
               plot(ax10,(zoomXBegin :1: zoomXEnd), state{i});
%                plot(ax10,(zoomXBegin :1: zoomXEnd), touchStatusNormalized{i}/max(touchStatusNormalized{i}));
               plot(ax10,(zoomXBegin :1: zoomXEnd), touchStatusNormalized{i});
       end
   end
end