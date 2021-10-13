
clear all;
close all;

k_mot = 36 * 1/1000;

ratName = 'B';

d = loadDataSessions(ratName);

plotInfo = {};
plotInfo.ratName = ratName;
plotInfo.sessionDateTimeAndSaveTag = '2021';
plotInfo.ylabel = 'Angular position (deg)';
plotInfo.varName = 'Position';
%plotInfo.HRstr1 = strcat(string(sum(hitCatchTrialsIdxs)),"/",string(sum(catchTrialIdxs)));
%plotInfo.HRstr2 = strcat(string(sum(hitNonCatchTrialsIdxs)),"/",string(sum(nonCatchTrialIdxs)));

%plotAlignedAll(d.trialTime, d.moveOnset, d.motorCurrent, d.timeMax, d.conditionTrial, d.validTrial, plotInfo, 1, 10);

%plotAlignedAll(d.trialTime, d.moveOnset, d.motorCurrentCom, d.timeMax, d.conditionTrial, d.validTrial, plotInfo, 1, 10);

figure()
set(gcf, 'OuterPosition', [10, 10, 810, 810]);

ax1 = subplot(2,1,1);
hold on;

n = 0;
%indexes = [7 10 15 16 17];
indexes = [7 10 ];
for i = indexes

    t_offset = d.trialTime{i}(d.moveOnset{i});
    %if (allTrials(i).flagFail == failFlag && failFlag ~= 0)allTrials(i).flagFail
    if length(t_offset)>0 % failFlag == 255 % this allows plotting ALL fail flags if set to 255
        %c = double(cell2mat(d.conditionTrial(i)))/max(indexes)
        c = n/(length(indexes)-1);
        n = n+1;
        
        plot(d.trialTime{i}(1:d.timeMax{i})-t_offset, 180/pi*d.position{i}(1:d.timeMax{i}), 'LineWidth', 2, 'Color', [0, c, 1-c, 1]);
    end    
end

xlabel('Time (ms)');
ylabel('Knob position (deg)');
title(strcat("Knob position for sample trials"));

xlim([0 inf])


ax2 = subplot(2,1,2);
hold on;

n = 0;
%indexes = [7 10 15 16 17];
indexes = [7 10 ];
for i = indexes

    t_offset = d.trialTime{i}(d.moveOnset{i});
    %if (allTrials(i).flagFail == failFlag && failFlag ~= 0)allTrials(i).flagFail
    if length(t_offset)>0 % failFlag == 255 % this allows plotting ALL fail flags if set to 255
        %c = double(cell2mat(d.conditionTrial(i)))/max(indexes)
        c = n/(length(indexes)-1);
        n = n+1;
        
        plot(d.trialTime{i}(1:d.timeMax{i})-t_offset, 1000*k_mot*d.motorCurrent{i}(1:d.timeMax{i}), 'LineWidth', 2, 'Color', [0, c, 1-c, 1]);
        plot(d.trialTime{i}(1:d.timeMax{i})-t_offset, 1000*k_mot*d.motorCurrentCom{i}(1:d.timeMax{i}), '--', 'LineWidth', 2, 'Color', [0, c, 1-c, 1]);
    end    
end

xlabel('Time (ms)');
ylabel('Torque (mNm)');
title(strcat("Position-proportional counter-torque for sample trials"));

L(1) = plot(nan, nan, '--', 'LineWidth', 2, 'Color',[0,0,0,1]);
L(2) = plot(nan, nan, 'LineWidth', 2, 'Color',[0, 0, 0, 1]);
legend(L, {'Reference counter-torque', 'Measured counter-torque'}, 'Location', 'Best')


xlim([0 inf])

linkaxes([ax1,ax2],'x')
