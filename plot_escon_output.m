%plot_escon_data
maxV = -4;
maxA = 0.5;
maxS = 500;
close all
figure
subplot(3,1,1)
dt = 2e-3;
time = rawspeed(:,1);

plotSpeed = ((rawspeed(:,2) / maxV) * maxS);
pos2 = cumsum(plotSpeed*(dt/(60)));
pos_corr = cumsum(plotSpeed*(dt/(60))        -1.7121e-05);


err = diff(plotSpeed);
plot(time, pos_corr*360, 'LineWidth', 2)
title('Error Corrected Angle of Motor')
xlabel('Time (s)')
ylabel('Angle (deg)')
subplot(3,1,2)
plot(time, plotSpeed, 'LineWidth', 2)
title('Rotational speed of motor')
xlabel('Time (s)')
ylabel('Speed (rpm)')
subplot(3,1,3)
plot(time(2:end), err, 'LineWidth', 2)
title('Rotational acceleration of motor')
xlabel('Time (s)')
ylabel('err')
figure
subplot(2,1,1)
plot(time, pos2*360, 'LineWidth', 2)
title('Motor position')
xlabel('Time (s)')
ylabel('Angle (deg)')
text(.1, .9, ['Mean: ' num2str(mean(pos2*360))], 'Units', 'normalized')
text(.1, .85, ['Max: ' num2str(max(pos2*360))], 'Units', 'normalized')
subplot(2,1,2)
plot(time, pos_corr*360, 'LineWidth', 2)
title('Corrected motor position')
text(.1, .9, ['Mean: ' num2str(mean(pos_corr*360))], 'Units', 'normalized')
text(.1, .85, ['Max: ' num2str(max(pos_corr*360))], 'Units', 'normalized')
xlabel('Time (s)')
ylabel('Angle (deg)')
% figure
% plotCurrent = (current(:,2) / maxV) * maxA;
% plot(current(:,1), plotCurrent)
% title('Current to motor')
% xlabel('Time (s)')
% ylabel('Current (A)')
