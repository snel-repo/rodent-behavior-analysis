close all
for i = 1:length(trials)
avgTime(i) = trials(i).rewardDelay + 2 * find(trials(i).state == 3, 1);
trialTime(i) = length(find(trials(i).state == 3));
end
outlierRemovedTrialTime = hampel(trialTime);
meanTime = mean(avgTime);
figure('units','normalized','outerposition',[0 0 1 1])
histogram(outlierRemovedTrialTime, 50);
xlabel('Duration of trial (LED time, ms)')
ylabel('Frequency')
title(['Histogram of trial duration (time since LED turned on) ' trials(1).subject])
set(gca, 'FontSize', 24)

figure('units','normalized','outerposition',[0 0 1 1])
histogram(avgTime, 50)
xlabel('Inter-trial period (ms)')
ylabel('Frequency')
title(['Histogram of inter-trial duration ' trials(1).subject])
set(gca, 'FontSize', 24)