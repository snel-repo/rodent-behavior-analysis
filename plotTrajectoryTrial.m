function plotTrajectoryTrial(extractedTrial, pert)

figure
for i = 1:length(extractedTrial)
    subplot(3,1,1)
    hold on
    if pert(i) == 1
        q1 =     plot(extractedTrial{i, 1}, 'b');
    else
        q2 =    plot(extractedTrial{i, 1}, 'r');
    end
    
    subplot(3,1,2)
    hold on
    if pert(i) == 1
        g1 =    plot(extractedTrial{i, 2}, 'b');
    else
        g2 =     plot(extractedTrial{i, 2}, 'r');
    end
    
    subplot(3,1,3) % plot perturbation current
    hold on
    if pert(i) == 1
        c1 =     plot(extractedTrial{i, 3}, 'b');
    end
end

subplot(3,1,1)
xlabel('Time (ms)')
ylabel('Turn Angle (deg)')
title('Turn Angle Trajectories for Rewarded Trials')
legend([q1 q2], 'Perturbed', 'Unperturbed')

subplot(3,1,2)
xlabel('Time (ms)')
ylabel('Velocity (rpm)')
title('Turn Angle Velocity for Rewarded Trials')
legend([g1 g2], 'Perturbed', 'Unperturbed')


subplot(3,1,3)
xlabel('Time (ms)')
ylabel('Perturbation Voltage (max 10V)')
title('Perturbation Magnitude for Rewarded Trials')