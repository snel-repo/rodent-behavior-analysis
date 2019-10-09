% plot encoder block
close all
figure
msTimer = 2;
sampleTime = 2e-3;
subplot(3,1,1)
plot(encoderData(:,1), encoderData(:,2))
title('Position of encoder test')
xlabel('Time (ms)')
ylabel('Position (deg)')
subplot(3,1,2)
encoderVel = diff(encoderData(:,2)) / sampleTime;
plot(encoderData(2:end,1), encoderVel)
title('Velocity of encoder test')
xlabel('Time (ms)')
ylabel('Velocity (deg/s)')
subplot(3,1,3)
encoderAccel = diff(encoderVel) / sampleTime;
plot(encoderData(3:end,1), encoderAccel)
title('Acceleration of encoder test')
xlabel('Time (ms)')
ylabel('Acceleration (deg/s/s)')