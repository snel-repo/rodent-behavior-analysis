changeIdx = 1;
changePts = [];
trial.vel = [0; diff(trial.pos)];
for i = 1:length(trial.vel) - 1
    if (trial.vel(i) ~= trial.vel(i+1)) && ((trial.vel(i) == 0) || (trial.vel(i+1) == 0))
        changePts(changeIdx) = i;
        changeIdx = changeIdx + 1;
    end
end

close all
plot(trial.pos, 'lineWidth', 2)
hold on
plot(trial.touchRaw, 'lineWidth', 2)
changeTouch = trial.touchRaw(changePts);
plot(changePts, changeTouch, 'o', 'lineWidth', 2)
legend({'Knob Position', 'Filtered Touch Data', 'Velocity Change Pts'}, 'location', 'best')
title('Test Touch Data (Rat)')
xlabel('Time (ms)')
ylabel('Position (deg) or Touch Data')
grid on
grid minor
set(gca, 'FontSize', 24)
