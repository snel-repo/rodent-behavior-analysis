function plotTenTrialsAutoTurnDebugger(in)
%function that plots the first ten trials where there is a touch to debug
%the capacitance spiking
%only use 1 for now to plot one session
session = in(1);

%now have session, want to get all the trials in session
allTrials = session.trials;

%so, first make figure and subplots
figure('Name',"TenTrialsAutoTurnDebugger" + allTrials(1).subject);
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
%change index to -10 to get trials 10-20 with the issue and so on
index = 0;
%make a for-loop to access each trial
for i = 1:numel(allTrials)
   touchStatus{i} = allTrials(i).touchStatus;
   touchStatusNormalized{i} = allTrials(i).touchStatus;
   if any(touchStatus{i} == 1)
       %there was a touc}h in this trial, so we want to plot it
       index = index + 1;
       
       if (allTrials(i).hitTrial == 1)
           hit = 'Hit';
       else
           hit = 'Fail';
       end
      minY = min(allTrials(i).touchFilt);
      maxY = max(allTrials(i).touchFilt);   
      
      touchStatusNormalized{i}(touchStatusNormalized{i}==1) = minY + 44;
      touchStatusNormalized{i}(touchStatusNormalized{i}==0) = minY + 2;
       
       switch index
           case 1
               plot(ax1,allTrials(i).touchFilt);
               hold(ax1,'on');
               plot(ax1,allTrials(i).touchBaseline);
               plot(ax1, touchStatusNormalized{i});
               title(ax1,"Trial No. " + i + " " + hit);
           case 2
               plot(ax2,allTrials(i).touchFilt);
               hold(ax2,'on');
               plot(ax2,allTrials(i).touchBaseline);
               title(ax2,"Trial No. " + i + " " + hit);
           case 3
               plot(ax3,allTrials(i).touchFilt);
               hold(ax3,'on');
               plot(ax3,allTrials(i).touchBaseline);
               title(ax3,"Trial No. " + i + " " + hit);
           case 4
               plot(ax4,allTrials(i).touchFilt);
               hold(ax4,'on');
               plot(ax4,allTrials(i).touchBaseline);
               title(ax4,"Trial No. " + i + " " + hit);
           case 5
               plot(ax5,allTrials(i).touchFilt);
               hold(ax5,'on');
               plot(ax5,allTrials(i).touchBaseline);
               title(ax5,"Trial No. " + i + " " + hit)
           case 6
               plot(ax6,allTrials(i).touchFilt);
               hold(ax6,'on');
               plot(ax6,allTrials(i).touchBaseline);
               title(ax6,"Trial No. " + i + " " + hit);
           case 7
               plot(ax7,allTrials(i).touchFilt);
               hold(ax7,'on');
               plot(ax7,allTrials(i).touchBaseline);
               title(ax7,"Trial No. " + i + " " + hit);
           case 8
               plot(ax8,allTrials(i).touchFilt);
               hold(ax8,'on');
               plot(ax8,allTrials(i).touchBaseline);
               title(ax8,"Trial No. " + i + " " + hit);
           case 9
               plot(ax9,allTrials(i).touchFilt);
               hold(ax9,'on');
               plot(ax9,allTrials(i).touchBaseline);
               title(ax9,"Trial No. " + i + " " + hit);
           case 10
               plot(ax10,allTrials(i).touchFilt);
               hold(ax10,'on');
               plot(ax10,allTrials(i).touchBaseline);
               title(ax10,"Trial No. " + i + " " + hit);
       end
   end
end