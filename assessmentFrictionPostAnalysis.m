close all
%assessmentFrictionPostAnalyze
colorChoice = {'y', 'c', 'r', 'k', 'm', 'g'};
currentLevels = [10 12 14 16 18 20];
taskIndices = find(timeElapsedTask(:,2) == 2);
staticIndices = 1:1:taskIndices(2) - 1;
dynamicIndices = taskIndices(2): 1 : length(timeElapsedTask(:,2));
staticMotorCurrent = motorCurrent(staticIndices,2);
dynamicMotorCurrent = motorCurrent(dynamicIndices, 2);
currentLevelIndices = find(diff(motorCurrent(:,2)) >= 1 );
% first plot, static
figure
subplot(2,1,1)
plot(timeElapsedTask(staticIndices,2), motorCurrent(staticIndices,2))
title('Motor current for Static Task')
ylabel('Current(mA)')
xlabel('Time (ms)')
subplot(2,1,2)
plot(timeElapsedTask(staticIndices,2), vel(staticIndices, 2))
title('Knob velocity for Static Task')
ylabel('Velocity (deg/s)')
xlabel('Time (ms)')

figure
for i = 1:length(currentLevelIndices)
        plottingIndex = currentLevelIndices(i) + 1 : 1 : currentLevelIndices(i) + 14999;
        for j = 1:length(currentLevels)
            if currentLevels(j) == motorCurrent(plottingIndex(2),2)
              currentColor = colorChoice{j};  
            end
        end
                    if motorCurrent(plottingIndex(2),2) == 10
                s = 1;
            end
%     subplot(2,1,1)
%     plot(timeElapsedTask(plottingIndex,2), motorCurrent(plottingIndex,2), currentColor)
%     hold on
%     title('Motor current for Dynamic Task')
%     ylabel('Current(mA)')
%     xlabel('Time (ms)')

    plot(timeElapsedTask(plottingIndex,2), vel(plottingIndex, 2), currentColor)
    hold on
    title('Knob velocity for Dynamic Task')
    ylabel('Velocity (deg/s)')
    xlabel('Time (ms)')
    %legend({'20mA', '25mA', '30mA', '35mA', '40mA'})
    legend({'10mA', '12mA', '14mA', '16mA', '18mA', '20mA'})
end
