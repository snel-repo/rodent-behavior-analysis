for i = 1 : length(trials)
a = double(trials(i).touchRaw);
velPos = abs(trials(i).velRaw) - 15 > 0;
    padLen = max(0, length(a) - length(velPos));
    velNonZero = padarray(velPos, padLen, 0, 'post');
    diffVelPos = [0 diff(velPos)'];
    [filt_signal, s_filt] = twoSampleLP(a, 0.3);
    dFilt = [0 diff(filt_signal)];
    smoothingFactor = 0.03;
    [baseline, touchTrue, diagnostic] = baselineLP(filt_signal, smoothingFactor, velNonZero);
    diff_signal = filt_signal - baseline;
close all
figure('units','normalized','outerposition',[0 0 1 1])
subplot(2,1,1)
plot(filt_signal)
title(num2str(i))
hold on
plot(baseline)
subplot(2,1,2)
plot(trials(i).filt)
hold on
plot(trials(i).baseline)
pause(2)
end