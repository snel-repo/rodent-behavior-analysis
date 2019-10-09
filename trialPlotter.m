function trialPlotter(trialData, saveDirectory)
figure('units', 'normalized', 'outerposition', [0 0 1 1])
subplot(5,1,1)
plot(trialData.posEncoder(:,1), trialData.posEncoder(:,2), 'LineWidth', 2)
axis([-inf max(trialData.state(:,1)) -inf inf])
title('Current Knob Position (w/ reference lines)')
xlabel('Time (s)')
ylabel('Position (deg)')
refline(0, 80)
refline(0, 100)
subplot(5,1,2)
plot(trialData.velEncoder(:,1), trialData.velEncoder(:,2), 'LineWidth', 2)
axis([-inf max(trialData.state(:,1)) -inf inf])
title('Current Knob Velocity')
xlabel('Time (s)')
ylabel('Velocity (rpm)')
subplot(5,1,4)
plot(trialData.pertCurrent(:,1), trialData.pertCurrent(:,2), 'LineWidth', 2)
axis([-inf max(trialData.state(:,1)) -inf inf])
title('Current to motor')
xlabel('Time (s)')
ylabel('Current (A)')
subplot(5,1,3)
plot(trialData.rawEncoder(:,1), -1*trialData.rawEncoder(:,2), 'LineWidth', 2)
hold on
% q = plot(trialData.filterEncoder(:,1), -1*trialData.filterEncoder(:,2), 'r', 'LineWidth', 2);
% q.Color(4) = 0.3;
xlabel('Time (s)')
ylabel('Voltage (V)')
%legend({'Raw Encoder', 'Filtered Encoder'})
title('Raw Encoder Data')
axis([-inf max(trialData.state(:,1)) -inf inf])
subplot(5,1,5)
plot(trialData.state(:,1), trialData.state(:,2), 'LineWidth', 2)
title('FSM Current State')
xlabel('Time (s)')
ylabel('State')
axis([0 max(trialData.state(:,1)) 0 4])
stateSaveFile = sprintf('%sState Data', saveDirectory);
save2pdf(stateSaveFile)

% figure('units', 'normalized', 'outerposition', [0 0 1 1])
% subplot(2,1,1)
% plot(trialData.rawEncoder(:,1), trialData.rawEncoder(:,2))
% hold on
% q1 = plot(trialData.filterEncoder(:,1), trialData.filterEncoder(:,2), 'r');
% q1.Color(4) = 0.3;
% xlabel('Time (s)')
% ylabel('Voltage (V)')
% legend({'Raw Encoder', 'Filtered Encoder'})
% title('Comparison of Raw and Filtered Encoder Data')
% 
% subplot(2,1,2)
% [freqRaw, amplitudeRaw] = computeSpectral(trialData.rawEncoder);
% plot(freqRaw, amplitudeRaw)
% hold on
% [freqFilt, amplitudeFilt] = computeSpectral(trialData.filterEncoder);
% q2 = plot(freqFilt, amplitudeFilt, 'r');
% q2.Color(4) = 0.3;
% 
% title('Spectral plot of encoder voltage')
% xlabel('Freq (Hz)')
% ylabel('Amplitude')
% legend({'Raw Encoder', 'Filtered Encoder'})
% axis([0 5 -inf inf])
% encoderSaveFile = sprintf('%sEncoder Data', saveDirectory);
% save2pdf(encoderSaveFile)
