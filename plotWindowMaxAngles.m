function plotWindowMaxAngles(trials)
trialNum = 1:numel(trials);
scatter(trialNum, [trials.rewardAngle], 'filled', 'o');
xlim([trialNum(1) trialNum(end)])
hold on
% scatter(trialNum, [trials.failAngle], 'filled', 'o', 'markerFaceColor', 'r');
% hold on
plot(trialNum, [trials.maxWindow], 'lineWidth', 2, 'Color', 'k')
title('Final trial angles and max window thresholds')
xlabel('Trial #')
ylabel('Angle (deg)')
lsline
legend({'Final Trial Angle (FTA; Success Trial)', 'Max Window Threshold', 'Best fit line of FTA'})
set(gca, 'FontSize', 20)