close all
clear all
Tc = 36;  % torque constant

esconCurrentMax = 150; % mA motor current max
offset = 1;
duration = 125;
%this is the calibration matrix from the cal file. DO NOT EDIT THIS FOR THE
%NANO17!!!
calMat = [-0.001164159738, -0.007913902402, -0.163237437606, -2.984951734543, 0.122058771551, 2.961691617966;...
    -0.015060968697, 3.593142986298, -0.081949695945, -1.766523957253, -0.084904193878, -1.691629886627;...
    3.388910055161, -0.153048768640, 3.438704490662, -0.049121677876, 3.393568515778, -0.068142056465;...
    -0.405230194330, 21.994832992554, 18.211835861206, -11.002400398254, -19.728195190430, -10.057474136353;...
    -21.785396575928, 1.017708778381, 12.334293365479, 18.126163482666, 10.298816680908, -18.345146179199;...
    0.078768886626, 12.894908905029, 0.705196738243, 12.492894172669, 0.475057303905, 13.389413833618];

%% preprocess data to reduce noise
q = uigetdir([], 'Select Nano17 triallogger directory');
g = dir(q);
dataDates = {g(3:end).name};
selectDirs = listdlg('promptString', 'Select dates with appropriate data', 'listString', dataDates);
nano17saveTags = [];
for i = 1:length(selectDirs)
    tmp = dir([q '\' dataDates{selectDirs(i)} '\1']);
    tmp = {tmp(3:end).name};
    nano17saveTags = [nano17saveTags tmp];
end
selectDirs = listdlg('promptString', 'Select saveTags with relevant data', 'listString', dataDates);

x = dir;
y ={x.name};
y = y(3:end-1);
cleanData = extractNano17GaugeData(y, duration);


%% fix noise issues by averaging all trials
G0 = nanmean(cleanData.G0);
G1 = nanmean(cleanData.G1);
G2 = nanmean(cleanData.G2);
G3 = nanmean(cleanData.G3);
G4 = nanmean(cleanData.G4);
G5 = nanmean(cleanData.G5);
fprintf('std values:\nG0: %s\nG1: %s\nG2: %s\nG3: %s\nG4: %s\nG5: %s\n', num2str(std(G0)), num2str(std(G1)), num2str(std(G2)), num2str(std(G3)), num2str(std(G4)), num2str(std(G5)))

%% define non-struct variables for constants for cleaner referencing
voltage = mode(cleanData.voltage);
voltageMax = cleanData.voltageMax;
voltageStep = cleanData.voltageStep;
totalVoltageStep = voltageMax / voltageStep + 1;
sampleTime = cleanData.sampleTime;
voltageArray = [0:voltageStep:voltageMax];
TzArray = (voltageArray / 10) * esconCurrentMax / 1000 * Tc;
stepOn = repelem(repmat([0 1], 1, floor((length(G0) / duration) / 2)), duration);
% stepOn = [stepOn repelem(1, rem((length(G0) / duration), 2), duration)];
stepOn = find(stepOn);
diffStep = find([0 diff(stepOn)] > 0); % finds indices of when step is activated
TzPredicted = (voltage / 10) * (esconCurrentMax / 1000) * Tc;
timeArray = [0:2:2*length(G0)-1];

%% resolve forces, torques
Fx(:,2) = G0 .* calMat(1,1) + G1 .* calMat(1,2) + G2 .* calMat(1,3) + G3 .* calMat(1,4) + G4 .* calMat(1,5) + G5 .* calMat(1,6);
Fy(:,2) = G0 .* calMat(2,1) + G1 .* calMat(2,2) + G2 .* calMat(2,3) + G3 .* calMat(2,4) + G4 .* calMat(2,5) + G5 .* calMat(2,6);
Fz(:,2) = G0 .* calMat(3,1) + G1 .* calMat(3,2) + G2 .* calMat(3,3) + G3 .* calMat(3,4) + G4 .* calMat(3,5) + G5 .* calMat(3,6);
Tx(:,2) = G0 .* calMat(4,1) + G1 .* calMat(4,2) + G2 .* calMat(4,3) + G3 .* calMat(4,4) + G4 .* calMat(4,5) + G5 .* calMat(4,6);
Ty(:,2) = G0 .* calMat(5,1) + G1 .* calMat(5,2) + G2 .* calMat(5,3) + G3 .* calMat(5,4) + G4 .* calMat(5,5) + G5 .* calMat(5,6);
Tz(:,2) = G0 .* calMat(6,1) + G1 .* calMat(6,2) + G2 .* calMat(6,3) + G3 .* calMat(6,4) + G4 .* calMat(6,5) + G5 .* calMat(6,6);

%% subtract mean of first few measurements to tare values
zeroVoltIdx = find(voltage == 0, 1);
zeroVoltRange = zeroVoltIdx + 10 : zeroVoltIdx + 70;
FxZero = Fx(:,2) - mean(Fx(zeroVoltRange, 2));
FyZero = Fy(:,2) - mean(Fy(zeroVoltRange, 2));
FzZero = Fz(:,2) - mean(Fz(zeroVoltRange, 2));
TxZero = Tx(:,2) - mean(Tx(zeroVoltRange, 2));
TyZero = Ty(:,2) - mean(Ty(zeroVoltRange, 2));
TzZero = Tz(:,2) - mean(Tz(zeroVoltRange, 2));

%% extract only active regions (when Step is on)
FxEx = reshape(FxZero(stepOn), duration, totalVoltageStep)';
FyEx = reshape(FyZero(stepOn), duration, totalVoltageStep)';
FzEx = reshape(FzZero(stepOn), duration, totalVoltageStep)';
TxEx = reshape(TxZero(stepOn), duration, totalVoltageStep)';
TyEx = reshape(TyZero(stepOn), duration, totalVoltageStep)';
TzEx = reshape(TzZero(stepOn), duration, totalVoltageStep)';

%% determine when time-specific points are reached (first time torque value reached, max, steady state)
[~, maxIndices] = max(TzEx, [], 2);
TzDiff = [zeros(totalVoltageStep, 1), diff(TzEx, [], 2)];
TzDiffMean = mean(TzDiff);
steadyState = [];
spread = 3; % how many additional points to check
for i = 1:length(TzDiffMean) - spread
    if all(abs(TzDiffMean(i : i + spread)) < 0.1)
        steadyState(i) = 1;
    else
        steadyState(i) = 0;
    end
    if (i == length(TzDiffMean) - spread) && steadyState(i)
        steadyState = [steadyState ones(1, spread)];
    elseif (i == length(TzDiffMean) - spread) && ~steadyState(i)
        steadyState = [steadyState, zeros(1, spread)];
    end
end

steadyStateRegions = calcActiveRegions(diff([0 steadyState]), 0, 0);
steadyStateTime = sampleTime * steadyStateRegions;

% find when torque first exceeds expected torque value
% for i = 1:length(TzEx(:,1))
%     timeTorque(i) = find(TzEx(i, :) > TzArray(i), 1);
% end
% timeTorque = timeTorque(2:end); % ignore 0V
%% compute time-specific stats
% stats.timeSS = steadyStateTime(1);
% stats.SSerror = TzArray(2:end)' -  mean(TzEx(2:end, steadyStateRegions(1 : 2)), 2);
% stats.SSerrorPerc = mean(TzEx(2:end, steadyStateRegions(1 : 2)), 2) ./ TzArray(2:end)';
% stats.SStorque = mean(TzEx(:, steadyStateRegions(1:2)), 2);
%stats.timeTorque = mean(sampleTime * timeTorque);

%% close plots
close all
%% plot raw strain gauge measurements
figure('units','normalized','outerposition',[0 0 1 1])
plot(timeArray, G0, timeArray, G1, timeArray, G2, timeArray, G3, timeArray, G4, timeArray, G5)
title('Raw strain gauge measurements')
xlabel('Time (ms')
ylabel('Strain gauge voltage (V)')
legend({'G0', 'G1', 'G2', 'G3', 'G4', 'G5'}, 'location', 'WestOutside')
set(gca, 'FontSize', 18)
xlim([-inf inf])
%% plot overlaid torque curves
figure('units','normalized','outerposition',[0 0 1 1])
hold on
opacityStep = 1 / (totalVoltageStep);
for i = 1:length(TzEx(:,1))
    plot(0:sampleTime:duration * sampleTime - sampleTime, TzEx(i,:), 'color', [0 0 1 opacityStep * i] , 'lineWidth', 2, 'HandleVisibility', 'off')
end
currYlim = ylim;
if ~isempty(steadyStateRegions)
    for i = 1:length(steadyStateTime(:,1))
        steadyStateArea = rectangle('position', [steadyStateTime(i, 1) currYlim(1) (steadyStateTime(i,2) - steadyStateTime(i,1)) ceil(currYlim(2))],...
            'FaceColor', [1 0 0 0.2], 'lineStyle', 'none');
    end
end
torquePlots = line(NaN,NaN,'LineWidth',2,'LineStyle','-','Color','b');
steadyStateLine = line(NaN,NaN,'LineWidth',2,'LineStyle','-','Color',[1 0 0 0.2]);
legend({'Measured Torque', 'Calculated Steady-state Torque Region'})
ylim(currYlim);
title('Overlaid torque curves')
xlabel('Time (ms')
ylabel('Torque (mNm)')
set(gca, 'FontSize', 18)
%% plot instantaneous torque N ms after voltage command
figure('units','normalized','outerposition',[0 0 1 1])
hold on
TzOffset = [];
for i = [1 5 9 17 33]
    plot(voltageArray, TzEx(:, i), 'lineWidth', 2)
end
plot(voltageArray, TzArray, 'lineWidth', 3, 'lineStyle', '--', 'Color', 'k')
legend({'0ms', '8ms', '16ms',  '32ms', '64ms', 'Predicted'}, 'location', 'Northwest')
title('Instantaneous torque measurements for different times post voltage command onset')
xlabel('Voltage (V)')
ylabel('Torque (mNm')
set(gca, 'FontSize', 18)
axis('tight')
%% plot complete sequence torque
figure('units','normalized','outerposition',[0 0 1 1])
subplot(2,1,1)
plot(timeArray, TzZero, timeArray, TzPredicted, timeArray, TxZero, timeArray, TyZero, timeArray, TxZero + abs(TyZero) + abs(TzZero))
title('All trials averaged torque measurements (w/ Tx, Ty, Tz)')
xlabel('Time (ms)')
ylabel('Torque (mNm')
legend({'Measured Tz', 'Predicted Tz', 'Measured Tx', 'Measured Ty', 'Sum abs(Tx + Ty + Tz)'}, 'location', 'Northwest')
set(gca, 'FontSize', 18)
axis('tight')

subplot(2,1,2)
plot(timeArray, TzZero, timeArray, TzPredicted)
title('All trials averaged torque measurements (Tz Only)')
xlabel('Time (ms)')
ylabel('Torque (mNm')
legend({'Measured Tz', 'Predicted Tz'}, 'location', 'Northwest')
set(gca, 'FontSize', 18)
axis('tight')

%% plot SS error
figure('units','normalized','outerposition',[0 0 1 1])
subplot(2,1,1)
plot(voltageArray(2:end), stats.SSerror, 'lineWidth', 2)
title('Steady state error for voltages')
xlabel('Voltage (V)')
ylabel('Torque (mNm')

subplot(2,1,2)
plot(voltageArray(2:end), stats.SSerrorPerc, 'lineWidth', 2)
title('Steady state error (fraction) for voltages')
xlabel('Voltage (V)')
ylabel('Torque (mNm')

%% plot expected vs actual torque at SS
figure('units', 'normalized', 'outerposition', [0 0 1 1])
plot(TzArray, stats.SStorque, 'lineWidth', 2)
xlabel('Predicted Torque')
ylabel('Measured Torque')
title('Steady-state Torque Average vs. Predicted Torque')