function plotWindowMaxAnglesWithMisses(trials)
trialNum = 1:numel(trials);
scatter(trialNum, [trials.rewardAngle], 'filled', 'o');
hold on
scatter(trialNum, [trials.failAngle], 'filled', 'o', 'markerFaceColor', 'r');
xlim([trialNum(1) trialNum(end)])
hold on
% scatter(trialNum, [trials.failAngle], 'filled', 'o', 'markerFaceColor', 'r');
% hold on
plot(trialNum, [trials.maxWindow], 'lineWidth', 2, 'Color', 'k')
title('Final trial angles and max window thresholds (Success & Fail)')
xlabel('Trial #')
ylabel('Angle (deg)')
legend({'Final Trial Angle (FTA; Success Trial)', 'Final Trial Angle (Fail Trial)', 'Max Window Threshold'})
set(gca, 'FontSize', 20)