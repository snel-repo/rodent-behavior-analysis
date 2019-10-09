function [extractedPos] = extractStateData(trialData, idx_hit)
figure
extractedPos = cell(length(idx_hit), 1);
extractedVel = cell(length(idx_hit), 1);
for i = 1:length(idx_hit)
    extractedPos{i} = trialData.posEncoder(idx_hit(i, 1) : idx_hit(i, 2), 2);
    extractedVel{i} = trialData.velEncoder(idx_hit(i, 1) : idx_hit(i, 2), 2);
    subplot(2,1,1)
   plot(extractedPos{i})
   hold on
   subplot(2,1,2)
   plot(extractedVel{i})
   hold on
end
subplot(2,1,1)
xlabel('Time (ms)')
ylabel('Turn Angle (deg)')
title('Turn Angle Trajectories for Rewarded Trials')

subplot(2,1,2)
xlabel('Time (ms)')
ylabel('Velocity (rpm)')
title('Turn Angle Velocity for Rewarded Trials')