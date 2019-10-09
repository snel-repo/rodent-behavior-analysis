close all
figure('units','normalized','outerposition',[0 0 1 1])
outlierTrialTime = [];
trialTimeGroups = [];
for i = 1:length(trialTimeAll) - 1
    subplot(3,3,i)
    tempTime = trialTimeAll{i};
    tempTime(tempTime > 5000) = [];
    outlierTrialTime = [outlierTrialTime tempTime];
    trialTimeGroups = [trialTimeGroups repelem(i, length(tempTime))];
    histogram(tempTime, 50)
    axis([0 5000 -inf inf])
    title(['Trial Time for ' trials(1).subject ' session ' num2str(i)])
    xlabel('Time, ms')
    ylabel('Frequency')
    set(gca, 'FontSize', 18)
end

figure('units','normalized','outerposition',[0 0 1 1])
boxplot(outlierTrialTime, trialTimeGroups)
title(['Boxplots for session trial times for ' trials(1).subject])
xlabel('Session #')
ylabel('Trial Time (ms)')
set(gca, 'FontSize', 18)

figure('units','normalized','outerposition',[0 0 1 1])
totalMissTrunc = cellfun(@sum, totalMiss);
totalMissNorm = totalMissTrunc;
for i = 1:length(totalMiss) 
    totalMissNorm(i) = totalMissTrunc(i) / length(totalMiss{i});
end
scatter([1:length(totalMiss) - 1], totalMissNorm(1:end-1), 100, 'filled')
set(gca, 'fontSize', 24)
title(['Incorrect turn rate per session for ' trials(1).subject])
xlabel('Session #')
ylabel('Turn rate (total incorrect turns / total trials)')
interTrial = [];
interTrialGroups = [];

figure('units','normalized','outerposition',[0 0 1 1])

for i = 1:length(avgTimeAll) - 1
    subplot(3,3,i)
    %     tempTime = avgTimeAll{i};
    %     tempTime(tempTime > 5000) = [];
    interTrial = [interTrial avgTimeAll{i}];
    interTrialGroups = [interTrialGroups repelem(i, length(avgTimeAll{i}))];
    histogram(avgTimeAll{i}, 50)
    axis([0 25000 -inf inf])
    title(['InterTrial Time for ' trials(1).subject ' session ' num2str(i)])
    xlabel('Time, ms')
    ylabel('Frequency')
    set(gca, 'FontSize', 18)
end

figure('units','normalized','outerposition',[0 0 1 1])
boxplot(interTrial, interTrialGroups)
axis([0 length(avgTimeAll) -inf inf])
title(['Boxplots for session inter-trial times  for ' trials(1).subject])
xlabel('Session #')
ylabel('Inter-Trial Time (ms)')
set(gca, 'FontSize', 18)

figure('units','normalized','outerposition',[0 0 1 1])


for j = 1:length(velStoreFull)
    for i = 1:length(velStoreFull{j})
        
        temp = velStoreFull{j};
        tempHit = hitAll{j};
        subplot(3,3,j)
        if strcmp(trials(1).subject, 'HODGKI') && (j==1 || j == 2 || j == 3 || j ==4)
            if tempHit(i)
                g = plot([0:2:2*length(temp{i})-1], temp{i} * 2000 / 65536, 'color', 'b');
            else
                g = plot([0:2:2*length(temp{i})-1], temp{i} * 2000 / 65536, 'color', 'r');
            end
        else
            if tempHit(i)
                g = plot([0:2:2*length(temp{i})-1], temp{i}, 'color', 'b');
            else
                g = plot([0:2:2*length(temp{i})-1], temp{i}, 'color', 'r');
            end
        end
        set(gca, 'FontSize', 18)
        g.Color(4) = 0.2;
        hold on
        axis([0 5000 -inf inf])
        title(['Vel in trial for ' trials(1).subject ' , session #' num2str(j)])
        xlabel('Time In Trial (ms)')
        ylabel('Velocity (deg/s)')
    end
end




% for j = 1:length(velStoreFull)
%     figure('units','normalized','outerposition',[0 0 1 1])
%     for i = 1:length(velStoreFull{j})
%         
%         temp = velStoreFull{j};
%         tempHit = hitAll{j};
%         
% 
%         if strcmp(trials(1).subject, 'HODGKI') && (j==1 || j == 2 || j == 3 || j ==4)
%             if tempHit(i)
%                 g = plot([0:2:2*length(temp{i})-1], temp{i} * 2000 / 65536, 'color', 'b');
%             else
%                 g = plot([0:2:2*length(temp{i})-1], temp{i} * 2000 / 65536, 'color', 'r');
%             end
%         else
%             if tempHit(i)
%                 g = plot([0:2:2*length(temp{i})-1], temp{i}, 'color', 'b', 'lineWidth', 1.5);
%             else
%                 g = plot([0:2:2*length(temp{i})-1], temp{i}, 'color', 'r', 'lineWidth', 1.5);
%             end
%         end
%         set(gca, 'FontSize', 18)
%         g.Color(4) = 0.3;
%         hold on
%         axis([0 5000 -inf inf])
%         title(['Velocity traces for turns per session for ' trials(1).subject ' , session #' num2str(j)])
%         xlabel('Time In Trial (ms)')
%         ylabel('Velocity (deg/s)')
%     end
% end
% figure
% for i = 1:length(totalMiss)
%     subplot(2,3,i)
%
%
figure('units','normalized','outerposition',[0 0 1 1])
for i = 1:length(totalMiss) - 1
    subplot(3,3, i)
    tempMiss = totalMiss{i};
    for j = 1:length(tempMiss)
        bar([1:1:length(tempMiss)], tempMiss)
        
    end
end