%postAccelTest
close all
figure
accelPlot =  [0; diff(vel(:,2)) / 2e-3];
plot(vel(:,1), vel(:,2), vel(:,1), accelPlot, vel(:,1), smooth(accelPlot), 'lineWidth', 2)
title('Acceleration Tests')
xlabel('Time (s)')
ylabel('Vel or Accel (deg / s or deg / s^2)')
legend({'Velocity', 'Raw acceleration', 'Smoothed acceleration'})
set(gca, 'FontSize', 24)
avgAccel = mean(smoothAccel(20:150));a