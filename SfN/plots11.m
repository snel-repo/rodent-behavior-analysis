
clear all;
close all;

ratName = 'B';

cond = 25;
ylimsp = [-10 50];
ylimsv = [-250 1000];
ylimst = [-5e-1 15e-1];
ylimsf = [0 150];
alpha = 0.2;

d = loadDataSessions(ratName);

% plotInfo = {};
% plotInfo.ratName = ratName;
% plotInfo.sessionDateTimeAndSaveTag = '2021';
% plotInfo.ylabel = 'Angular position (deg)';
% plotInfo.varName = 'Position';
% %plotInfo.HRstr1 = strcat(string(sum(hitCatchTrialsIdxs)),"/",string(sum(catchTrialIdxs)));
% %plotInfo.HRstr2 = strcat(string(sum(hitNonCatchTrialsIdxs)),"/",string(sum(nonCatchTrialIdxs)));
% 
% plotAlignedAll(d.trialTime, d.moveOnset, d.position, d.timeMax, d.conditionTrial, d.validTrial, plotInfo, 180/pi, 100);

%plotAlignedAll(d.trialTime, d.moveOnset, d.position, d.timeMax, d.conditionTrial, d.validTrial, plotInfo, 180/pi, 100);

%% Trial start -> Touch detection

figure(); 
set(gcf, 'OuterPosition', [50, 50, 900, 800]);

% xline(0,'--')
% % Position
% s11 = subplot(4,3,1); hold on
% for i = 1:length(d.trialTime)
%     if d.validTrial{i} && d.conditionTrial{i} == cond
%         t_offset = d.cueOnset{i};
%         is = d.cueOnset{i};
%         isoff = 100;
%         ie = d.cueOnset{i}+100;
%         plot(d.trialTime{i}(is-isoff:ie)-d.trialTime{i}(is), 180/pi*d.position{i}(is-isoff:ie), 'LineWidth', 2, 'Color', [0, 0, 0, alpha]);
%     end
% end
% grid on;
% %xlabel('Time (ms)');
% ylabel('Angular position (deg)');
% %title(strcat("(Catch trials) ", plotInfo.varName," for ", plotInfo.ratName, " for Session ", plotInfo.sessionDateTimeAndSaveTag))%, " - HR: ", plotInfo.HRstr1));
% ylim(ylimsp)
% 
% % Velocity
% s21 = subplot(4,3,4); hold on
% for i = 1:length(d.trialTime)
%     if d.validTrial{i} && d.conditionTrial{i} == cond
%         t_offset = d.cueOnset{i};
%         is = d.cueOnset{i};
%         isoff = 100;
%         ie = d.cueOnset{i}+100;
%         plot(d.trialTime{i}(is-isoff:ie)-d.trialTime{i}(is), 180/pi*d.velocity{i}(is-isoff:ie), 'LineWidth', 2, 'Color', [1, 0, 0, alpha]);
%     end
% end
% 
% xline(0,'--')
% grid on;
% %xlabel('Time (ms)');
% ylabel('Angular velocity (deg/s)');
% %title(strcat("(Catch trials) ", plotInfo.varName," for ", plotInfo.ratName, " for Session ", plotInfo.sessionDateTimeAndSaveTag))%, " - HR: ", plotInfo.HRstr1));
% ylim(ylimsv)
% 
% % Torque
% s31 = subplot(4,3,7); hold on
% for i = 1:length(d.trialTime)
%     if d.validTrial{i} && d.conditionTrial{i} == cond
%         t_offset = d.cueOnset{i};
%         is = d.cueOnset{i};
%         isoff = 100;
%         ie = d.cueOnset{i}+100;
%         %is = d.cueOnset{i};
%         %ie = d.touchOnset{i};
%         plot(d.trialTime{i}(is-isoff:ie)-d.trialTime{i}(is), 1000*d.torque{i}(is-isoff:ie), 'LineWidth', 2, 'Color', [0, 1, 0, alpha]);
%     end
% end
% 
% xline(0,'--')
% grid on;
% % xlabel('Time (ms)');
% ylabel('Estimated rat torque (mNm)');
% %title(strcat("(Catch trials) ", plotInfo.varName," for ", plotInfo.ratName, " for Session ", plotInfo.sessionDateTimeAndSaveTag))%, " - HR: ", plotInfo.HRstr1));
% ylim(ylimst)
% 
% % Force
% s41 = subplot(4,3,10); hold on
% for i = 1:length(d.trialTime)
%     if d.validTrial{i} && d.conditionTrial{i} == cond
%         t_offset = d.cueOnset{i};
%         is = d.cueOnset{i};
%         isoff = 100;
%         ie = d.cueOnset{i}+100;
%         plot(d.trialTime{i}(is-isoff:ie)-d.trialTime{i}(is), d.forceMag{i}(is-isoff:ie), 'LineWidth', 2, 'Color', [0, 0, 1, alpha]);
%     end
% end
% 
% grid on;
% xlabel('Time (ms)');
% ylabel('Force Magnitude (g)');
% %title(strcat("(Catch trials) ", plotInfo.varName," for ", plotInfo.ratName, " for Session ", plotInfo.sessionDateTimeAndSaveTag))%, " - HR: ", plotInfo.HRstr1));
% ylim(ylimsf)

%% Touch detection --> Move Onset

xlims2 = [-800 200];
isoff = 100;
isaft = 50;



% Position
s12 = subplot(4,2,1); hold on
xline(0,'--', 'LineWidth', 1.5)
for i = 1:length(d.trialTime)
    if d.validTrial{i} && d.conditionTrial{i} == cond
        t_offset = d.touchOnset{i};
        is = d.cueOnset{i}+10;
        ie = d.moveOnset{i};
        plot(d.trialTime{i}(is:ie)-d.trialTime{i}(t_offset), 180/pi*d.position{i}(is:ie), 'LineWidth', 2, 'Color', [0, 0, 0, alpha]);
    end
end


grid on;
% xlabel('Time (ms)');
% ylabel('Angular position (deg)');
%title(strcat("(Catch trials) ", plotInfo.varName," for ", plotInfo.ratName, " for Session ", plotInfo.sessionDateTimeAndSaveTag))%, " - HR: ", plotInfo.HRstr1));
ylim(ylimsp)
xlim(xlims2)

% Velocity
s22 = subplot(4,2,4); hold on
xline(0,'--', 'LineWidth', 1.5)
for i = 1:length(d.trialTime)
    if d.validTrial{i} && d.conditionTrial{i} == cond
        t_offset = d.touchOnset{i};
        is = d.cueOnset{i}+10;
        isoff = 100;
        ie = d.moveOnset{i};
        plot(d.trialTime{i}(is:ie)-d.trialTime{i}(t_offset), 180/pi*d.velocity{i}(is:ie), 'LineWidth', 2, 'Color', [1, 0, 0, alpha]);
    end
end

grid on;
% xlabel('Time (ms)');
% ylabel('Angular velocity (deg/s)');
%title(strcat("(Catch trials) ", plotInfo.varName," for ", plotInfo.ratName, " for Session ", plotInfo.sessionDateTimeAndSaveTag))%, " - HR: ", plotInfo.HRstr1));
ylim(ylimsv)
xlim(xlims2)


% Torque
s32 = subplot(4,3,[7 8]); hold on
xline(0,'--', 'LineWidth', 1.5)
for i = 1:length(d.trialTime)
    if d.validTrial{i} && d.conditionTrial{i} == cond
        t_offset = d.touchOnset{i};
        is = d.cueOnset{i}+10;
        isoff = 100;
        ie = d.moveOnset{i};
        plot(d.trialTime{i}(is:ie)-d.trialTime{i}(t_offset), 1000*d.torque{i}(is:ie), 'LineWidth', 2, 'Color', [0, 1, 0, alpha]);
    end
end

grid on;
% xlabel('Time (ms)');
% ylabel('Estimated rat torque (mNm)');
%title(strcat("(Catch trials) ", plotInfo.varName," for ", plotInfo.ratName, " for Session ", plotInfo.sessionDateTimeAndSaveTag))%, " - HR: ", plotInfo.HRstr1));
ylim(ylimst)
xlim(xlims2)

% Force
s42 = subplot(4,3,[10 11]); hold on
xline(0,'--', 'LineWidth', 1.5)
for i = 1:length(d.trialTime)
    if d.validTrial{i} && d.conditionTrial{i} == cond
        t_offset = d.touchOnset{i};
        is = d.cueOnset{i}+10;
        isoff = 100;
        ie = d.moveOnset{i};
        plot(d.trialTime{i}(is:ie)-d.trialTime{i}(t_offset), d.forceMag{i}(is:ie), 'LineWidth', 2, 'Color', [0, 0, 1, alpha]);
    end
end

grid on;
xlabel('Time (ms)');
% ylabel('Force (g)');
%title(strcat("(Catch trials) ", plotInfo.varName," for ", plotInfo.ratName, " for Session ", plotInfo.sessionDateTimeAndSaveTag))%, " - HR: ", plotInfo.HRstr1));
%ylim(ylimst)
xlim(xlims2)

%% Move Onset --> Peak Rotation

% Position
s13 = subplot(4,3,3); hold on
xline(0,'--', 'LineWidth', 1.5)
for i = 1:length(d.trialTime)
    if d.validTrial{i} && d.conditionTrial{i} == cond
        t_offset = d.moveOnset{i};
        is = d.cueOnset{i}+10;
        ie = d.timeMax{i};
        plot(d.trialTime{i}(is:ie)-d.trialTime{i}(t_offset), 180/pi*d.position{i}(is:ie), 'LineWidth', 2, 'Color', [0, 0, 0, alpha]);
    end
end

grid on;
% xlabel('Time (ms)');
% ylabel('Angular position (deg)');
%title(strcat("(Catch trials) ", plotInfo.varName," for ", plotInfo.ratName, " for Session ", plotInfo.sessionDateTimeAndSaveTag))%, " - HR: ", plotInfo.HRstr1));
ylim(ylimsp)
xlim([-200 300])

% Velocity
s23 = subplot(4,3,6); hold on
xline(0,'--', 'LineWidth', 1.5)
for i = 1:length(d.trialTime)
    if d.validTrial{i} && d.conditionTrial{i} == cond
        t_offset = d.moveOnset{i};
        is = d.cueOnset{i}+10;
        ie = d.timeMax{i};
        plot(d.trialTime{i}(is:ie)-d.trialTime{i}(t_offset), 180/pi*d.velocity{i}(is:ie), 'LineWidth', 2, 'Color', [1, 0, 0, alpha]);
    end
end


grid on;
%xlabel('Time (ms)');
%ylabel('Angular velocity (deg)');
%title(strcat("(Catch trials) ", plotInfo.varName," for ", plotInfo.ratName, " for Session ", plotInfo.sessionDateTimeAndSaveTag))%, " - HR: ", plotInfo.HRstr1));
ylim(ylimsv)
xlim([-200 300])

% Torque
s33 = subplot(4,3,9); hold on
xline(0,'--', 'LineWidth', 1.5)
for i = 1:length(d.trialTime)
    if d.validTrial{i} && d.conditionTrial{i} == cond
        t_offset = d.moveOnset{i};
        is = d.cueOnset{i}+10;
        ie = d.timeMax{i};
        plot(d.trialTime{i}(is:ie)-d.trialTime{i}(t_offset), 1000*d.torque{i}(is:ie), 'LineWidth', 2, 'Color', [0, 1, 0, alpha]);
    end
end

grid on;
%xlabel('Time (ms)');
%ylabel('Estimated rat torque (mNm)');
%title(strcat("(Catch trials) ", plotInfo.varName," for ", plotInfo.ratName, " for Session ", plotInfo.sessionDateTimeAndSaveTag))%, " - HR: ", plotInfo.HRstr1));
ylim(ylimst)
xlim([-200 300])

% Force
s43 = subplot(4,3,12); hold on
xline(0,'--', 'LineWidth', 1.5)
for i = 1:length(d.trialTime)
    if d.validTrial{i} && d.conditionTrial{i} == cond
        t_offset = d.moveOnset{i};
        is = d.cueOnset{i}+10;
        ie = d.timeMax{i};
        plot(d.trialTime{i}(is:ie)-d.trialTime{i}(t_offset), d.forceMag{i}(is:ie), 'LineWidth', 2, 'Color', [0, 0, 1, alpha]);
    end
end

grid on;
xlabel('Time (ms)');
xlim([-200 300])


%%

linkaxes([s12,s22,s32,s42],'x');
linkaxes([s13,s23,s33,s43],'x');

linkaxes([s12,s13],'y');
linkaxes([s22,s23],'y');
linkaxes([s32,s33],'y');
linkaxes([s42,s43],'y');

% linkaxes([s11,s21,s31,s41],'x');
% linkaxes([s12,s22,s32,s42],'x');
% linkaxes([s13,s23,s33,s43],'x');
% 
% linkaxes([s11,s12,s13],'y');
% linkaxes([s21,s22,s23],'y');
% linkaxes([s31,s32,s33],'y');
% linkaxes([s41,s42,s43],'y');
