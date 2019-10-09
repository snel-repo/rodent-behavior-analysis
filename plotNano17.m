function plotNano17(in)
plt = Plot(in.time, in.G0, in.time, in.G1, in.time, in.G2, in.time, in.G3, in.time, in.G4, in.time, in.G5);
plt.BoxDim = [8 8];
plt.LineWidth = [1.5*ones(1,6)];
plt.XLabel = 'Time (s)';
plt.YLabel = 'Nano17 Load Cell Voltage (V)';
lege = legend({'Gauge G0', 'Gauge G1', 'Gauge G2', 'Gauge G3', 'Gauge G4', 'Gauge G5'});
lege.Position = [0.42 0.8 0.2 0.07];
% lege.Position = [0.72 0.77 0.2 0.07];
% plt.YLim = [-0.4 2];

%% for step torque
plt = Plot(in.time(1:350),in.G0All(end - 474 : end - 125), in.time(1:350), in.G1All(end - 474 : end - 125), in.time(1:350), in.G2All(end - 474 : end - 125), in.time(1:350), in.G3All(end - 474 : end - 125), in.time(1:350), in.G4All(end - 474 : end - 125), in.time(1:350), in.G5All(end - 474 : end - 125));
plt.BoxDim = [8 8];
plt.LineWidth = [1.5*ones(1,6)];
plt.XLim = [0 0.7];
plt.YLim = [-1 2.5];
plt.XLabel = 'Time (s)';
plt.YLabel = 'Nano17 Load Cell Voltage (V)';
lege = legend({'Gauge G0', 'Gauge G1', 'Gauge G2', 'Gauge G3', 'Gauge G4', 'Gauge G5'});
lege.Position = [0.39 0.8 0.2 0.07];
% lege.Position = [0.72 0.77 0.2 0.07];
% plt.YLim = [-0.4 2];


plt = Plot(in.time(1:350),in.TzPredictedAll(end - 474 : end - 125), in.time(1:350),-in.TzZeroAll(end - 474 : end - 125), NaN, NaN);
plt.BoxDim = [8 8];
plt.LineWidth = [1.8 1.8 15];
plt.XLim = [0 0.7];
currYLim = ylim;
rectangle('position', [0.205 currYLim(1) 0.025/2 ceil(currYLim(2) - currYLim(1))], 'FaceColor', [0.8 0 0 0.2], 'lineStyle', 'none');
rectangle('position', [0.45 currYLim(1) 0.25 ceil(currYLim(2)  - currYLim(1))], 'FaceColor', [0.8 0 0 0.2], 'lineStyle', 'none');
plt.Colors = {[0 0 0],[191/255 0/255 28/255],  [245/255 204/255 204/255]};
%plt.YLim = [-1 2.5];
plt.XLabel = 'Time (s)';
plt.YLabel = 'Torque (mNm)';
lege = legend({'Predicted motor axis torque', 'Measured motor axis torque (Tz)', 'Test setup transient region'});
q = get(gca, 'children');
q = [q(3:5); q(1:2)];
set(gca, 'children', q)
lege.Position = [0.25 0.8 0.2 0.07];
% lege.Position = [0.72 0.77 0.2 0.07];
% plt.YLim = [-0.4 2];

%% zeroed gauge voltages
 subG0All = in.G0All - mean(in.G0All(1:100));
 subG1All = in.G1All - mean(in.G1All(1:100));
 subG2All = in.G2All - mean(in.G2All(1:100));
 subG3All = in.G3All - mean(in.G3All(1:100));
 subG4All =in.G4All - mean(in.G4All(1:100));
 subG5All = in.G5All - mean(in.G5All(1:100));
 
 plt = Plot(in.time(1:350),subG5All(end - 474 : end - 125), in.time(1:350), subG3All(end - 474 : end - 125), in.time(1:350), subG1All(end - 474 : end - 125), in.time(1:350), subG4All(end - 474 : end - 125), in.time(1:350), subG2All(end - 474 : end - 125), in.time(1:350), subG0All(end - 474 : end - 125));
plt.BoxDim = [8 8];
plt.LineWidth = [1.5*ones(1,6)];
plt.XLim = [0 0.7];
%plt.YLim = [-1 2.5];
plt.XLabel = 'Time (s)';
plt.YLabel = 'Nano17 Load Cell Voltage (V)';
plt.Colors = {[1 0.5 0.1], [0.17 0.17 0.17], [0.93 0 0], [0.44 0 0.99], [0 0.57 0], [0.16 0.44 1]};
lege = legend({'Gauge G5' , 'Gauge G3' ,'Gauge G1' ,'Gauge G4', 'Gauge G2', 'Gauge G0'});
lege.Position = [0.4 0.75 0.2 0.07];
reorderLegend([1 4 2 5 3 6])
% lege.Position = [0.72 0.77 0.2 0.07];
% plt.YLim = [-0.4 2];

plt = Plot(in.time(1:2500), in.G0(end-2499: end), in.time(1:2500),in.G1(end-2499: end), in.time(1:2500), in.G2(end-2499: end), in.time(1:2500), in.G3(end-2499: end), in.time(1:2500),in.G4(end-2499: end), in.time(1:2500), in.G5(end-2499: end));
plt.BoxDim = [8 8];
plt.LineWidth = [3*ones(1,6)];
plt.XLabel = 'Time (s)';
plt.YLabel = 'Nano17 Load Cell Voltage (V)';
lege = legend({'Gauge G0', 'Gauge G1', 'Gauge G2', 'Gauge G3', 'Gauge G4', 'Gauge G5'});
lege.Position = [0.42 0.715 0.2 0.07];
% lege.Position = [0.72 0.77 0.2 0.07];
% plt.YLim = [-0.4 2];
 s = 1;
 
 %plt = Plot(NaN, NaN); 
 hold on
 opacityPlot = 0.5;
 subG0 = in.G0-mean(in.G0Zero);
 subG1 = in.G1-mean(in.G1Zero);
 subG2 = in.G2-mean(in.G2Zero);
 subG3 = in.G3-mean(in.G3Zero);
 subG4 = in.G4-mean(in.G4Zero);
 subG5 = in.G5-mean(in.G5Zero);
%plt =  Plot(in.time, subG5, in.time, subG3, in.time, subG1, in.time, subG4, in.time, subG2, in.time, subG0);
plt =  Plot(in.time(1:2500), subG5(end-2499: end), in.time(1:2500), subG3(end-2499: end), in.time(1:2500), subG1(end-2499: end),in.time(1:2500), subG4(end-2499: end), in.time(1:2500), subG2(end-2499: end), in.time(1:2500), subG0(end-2499: end));
%Plot(in.time,subG0, in.time, subG1, in.time, subG2, in.time, subG3, in.time, subG4, in.time, subG5);
% plot(in.time, in.G0-mean(in.G0Zero), 'Color', [0.16 0.44 1 opacityPlot], 'lineWidth', 2)
% plot(in.time, in.G1-mean(in.G1Zero), 'Color', [0.93 0 0 opacityPlot], 'lineWidth', 2)
% plot(in.time, in.G2-mean(in.G2Zero), 'Color', [0 0.57 0 opacityPlot], 'lineWidth', 2)
% plot(in.time, in.G3-mean(in.G3Zero), 'Color', [0.17 0.17 0.17 opacityPlot], 'lineWidth', 2)
% plot(in.time, in.G4-mean(in.G4Zero), 'Color', [0.44 0 0.99 opacityPlot], 'lineWidth', 2)
% plot(in.time, in.G5-mean(in.G5Zero), 'Color', [1 0.5 0.1 opacityPlot], 'lineWidth', 2);
plt.Colors = {[1 0.5 0.1], [0.17 0.17 0.17], [0.93 0 0], [0.44 0 0.99], [0 0.57 0], [0.16 0.44 1]};
plt.BoxDim = [8 8];
plt.LineWidth = [1.5*ones(1,6)];
plt.XLabel = 'Time (s)';
plt.YLim = [-.08 .1];
plt.YLabel = 'Nano17 Load Cell Voltage (V)';
lege = legend({'Gauge G5' , 'Gauge G3' ,'Gauge G1' ,'Gauge G4', 'Gauge G2', 'Gauge G0'});
lege.Position = [0.7 0.8 0.2 0.07];
reorderLegend([1 4 2 5 3 6])
% lege.Position = [0.72 0.77 0.2 0.07];sss
% plt.YLim = [-0.4 2];

plt = Plot(in.time(1:2500), in.TzPredicted(end-2499:end), in.time(1:2500), in.TzZero(end-2499:end));
plt.BoxDim = [8 8];
plt.LineWidth = [1.8*ones(1,6)];
plt.LineStyle = {'-', '--'};
plt.XLabel = 'Time (s)';
plt.YLabel = 'Torque (mNm)';
plt.Colors = {[0 0 0],[191/255 0/255 28/255]};
plt.YLim = [-3 3.5];
lege = legend({'Predicted motor axis torque', 'Measured motor axis torque (Tz)'});
lege.Position = [0.45 0.86 0.15 0.07];

plt = Plot(in.time(1:2500), in.current(end-2499:end) / 4 * 150);
plt.BoxDim = [8 8];
plt.LineWidth = [1.8*ones(1,6)];
plt.XLabel = 'Time (s)';
plt.YLabel = 'Current (mA)';
plt.Colors = {[0.6 0.6 0.6]};

lege = legend({'Current to motor'});
lege.Position = [0.73 0.83 0.1 0.07];
lege.Box = 'off';
s = 1;

plt = Plot( in.time(1:2500), in.TzPredicted(end-2499:end), in.time(1:2500), in.TzCurrent(end-2499:end), in.time(1:2500), in.TzZero(end-2499:end));
plt.BoxDim = [8 8];
plt.LineWidth = [1.8*ones(1,6)];
plt.XLabel = 'Time (s)';
plt.YLabel = 'Torque (mNm)';
plt.YLim = [-3 4];
plt.Colors = {[0 0 0], [0.6 0.6 0.6], [191/255 0/255 28/255]};
plt.LineStyle = {'-', '--', '--'};
lege = legend({'Predicted Tz', 'Estimated Tz from Current', 'Measured Tz'});
lege.Position = [0.43 0.83 0.1 0.07];

tz = (in.TzZero(end-2499:end));
tzP =  (in.TzCurrent(end-2499:end));
tzE = (in.TzPredicted(end-2499:end));
t =  in.time(1:2500);
s = 1;
[~, idx] = max(tz);
%preT = 32 + (32*4)*1;
%postT = 32*3 + (32*4)*1;
preT = 40;
postT = 120;
plt = Plot(t(idx - preT: idx + postT), tzP(idx - preT: idx + postT), t(idx - preT: idx + postT), tzE(idx - preT: idx + postT), t(idx - preT: idx + postT), tz(idx - preT: idx + postT));
plt.BoxDim = [8 8];
plt.LineWidth = [1.8*ones(1,6)];
plt.XLabel = 'Time (s)';
plt.YLabel = 'Torque (mNm)';
%plt.YLim = [-3 4];
plt.Colors = {[0 0 0], [0.6 0.6 0.6], [191/255 0/255 28/255]};
plt.LineStyle = {'-', '--', '--'};
lege = legend({'Predicted Tz', 'Estimated Tz from Current', 'Measured Tz'});
lege.Position = [0.65 0.83 0.1 0.07];
%

normTz = 2*((tz - min(tz)) / ( max(tz) - min(tz))) - 1;
normTzE = 2 * ((tzE - min(tzE)) / ( max(tzE) - min(tzE))) - 1;
normTzP = 2* ((tzP - min(tzP)) / ( max(tzP) - min(tzP))) - 1;


plt = Plot(t(idx - preT: idx + postT), normTzP(idx - preT: idx + postT), t(idx - preT: idx + postT), normTzE(idx - preT: idx + postT), t(idx - preT: idx + postT), normTz(idx - preT: idx + postT));
plt.BoxDim = [8 8];
plt.LineWidth = [1.8*ones(1,6)];
plt.XLabel = 'Time (s)';
plt.YLabel = 'Min-Max Normalized Current';
%plt.YLim = [-3 4];
plt.Colors = {[0 0 0], [0.6 0.6 0.6], [191/255 0/255 28/255]};
plt.LineStyle = {'-', '--', '--'};
lege = legend({'Predicted Tz', 'Estimated Tz from Current', 'Measured Tz'});
lege.Position = [0.27 0.15 0.1 0.07];

[acor,lag] = xcorr(tzP, tz);
[~,I] = max(abs(acor));
lagDiff = lag(I);

plt = Plot(t(idx - preT: idx + postT), normTzP(idx - preT: idx + postT), t(idx - preT: idx + postT), normTzE(idx - preT: idx + postT), t(idx - preT: idx + postT), normTz(idx - preT + 4: idx + postT+4));
plt.BoxDim = [8 8];
plt.LineWidth = [1.8*ones(1,6)];
plt.XLabel = 'Time (s)';
plt.YLabel = 'Min-Max Normalized Current';
%plt.YLim = [-3 4];
plt.Colors = {[0 0 0], [0.6 0.6 0.6], [191/255 0/255 28/255]};
plt.LineStyle = {'-', '--', '--'};
lege = legend({'Predicted Tz', 'Estimated Tz from Current', 'Measured Tz'});
lege.Position = [0.27 0.15 0.1 0.07];

plt = Plot(t(idx - preT: idx + postT), tzP(idx - preT: idx + postT), t(idx - preT: idx + postT), tzE(idx - preT: idx + postT), t(idx - preT: idx + postT), tz(idx - preT + 4: idx + postT+4));
plt.BoxDim = [8 8];
plt.LineWidth = [1.8*ones(1,6)];
plt.XLabel = 'Time (s)';
plt.YLabel = 'Current (mA)';
%plt.YLim = [-3 4];
plt.Colors = {[0 0 0], [0.6 0.6 0.6], [191/255 0/255 28/255]};
plt.LineStyle = {'-', '--', '--'};
lege = legend({'Predicted Tz', 'Estimated Tz from Current', 'Measured Tz'});
lege.Position = [0.1 0.2 0.1 0.07];

plt = Plot(2*lag, acor);
plt.BoxDim = [8 8];
plt.LineWidth = [1.8*ones(1,6)];
plt.XLim = [-5000 5000];
plt.XLabel = 'Cross-correlation Lag (ms)';
plt.YLabel = 'Cross-correlation value (mNm^2)';
%plt.YLim = [-3 4];
plt.Colors = {[0 0 0]};
plt.LineStyle = {'-'};

plt = Plot(2*lag, acor, [-6 -6], [-2500 max(acor)]);
plt.BoxDim = [8 8];
plt.LineWidth = [1.8*ones(1,6)];
plt.XLabel = 'Cross-correlation Lag (ms)';
plt.YLabel = 'Cross-correlation value (mNm^2)';
%plt.YLim = [-3 4];
plt.XLim = [-100 100];
plt.Colors = {[0 0 0], [0.4 0.4 0.4]};
plt.LineStyle = {'-', ':'};
in.TzPredictedEx = abs(in.TzPredictedEx);
in.TzEx = abs(in.TzEx);
plt = Plot(in.TzPredictedEx(:, 5), in.TzEx(:,5),in.TzPredictedEx(:, 7), in.TzEx(:,7),in.TzPredictedEx(:, 8), in.TzEx(:,8), in.TzPredictedEx(:, 10), in.TzEx(:,10), in.TzPredictedEx(:, 15), in.TzEx(:,15));
plt.BoxDim = [8 8];
plt.Colors = {[0.8 0.8 0.8], [0.65 0.65 0.65], [0.5 0.5 0.5], [0.3 0.3 0.3], [0 0 0]};
plt.XLabel = 'Command torque (mNm)';
plt.YLabel = 'Measured torque (mNm)';
lege = legend({'10ms Post command','14ms Post command','16ms Post command', '20ms Post command','30ms Post command'});
lege.Position = [0.3 0.72 0.1 0.07];
lege.Box = 'off';
 
x = [ones(length(in.TzPredictedEx(:,10)), 1) in.TzPredictedEx(:,10)];
y = in.TzEx(:,10);
b = x\y;
fitLine =  in.TzPredictedEx(:,10) * b(2) + b(1);
Rsq2 = 1 - sum((y - fitLine).^2)/sum((y - mean(y)).^2);

plt = Plot(in.TzPredictedEx(:, 10), in.TzEx(:,10), in.TzPredictedEx(:,10), fitLine);
plt.BoxDim = [8 8];
plt.Colors = {[0 0 0] [0.5 0.5 0.5]};
plt.LineStyle = {'-', ':'};
plt.XLabel = 'Command torque (mNm)';
plt.YLabel = 'Measured torque (mNm)';
lege = legend({'20ms Post command', 'Linearly regressed fit'});
lege.Position = [0.3 0.72 0.1 0.07];
lege.Box = 'off';
hold on
text(2, 1.5, ['R^2 = ' num2str(Rsq2)], 'FontSize', 18)

plt = Plot(NaN, NaN, NaN, NaN);
plt.LineWidth = 1.8;
plt.Colors = {[1 0 0], [0 0 0]};
hold ons
plt.LineStyle = {'-', ':'};
plot(NaN, NaN, 'lineWidth', 15, 'color', [0.2 0.2 0.2 0.4]);
plt.BoxDim = [8 8];
plt.XLabel = 'Time (s)';
plt.YLabel = 'Measured torque (mNm)';
hold on
opacityPlot = 1 / length(in.TzEx(:,1));
for i = 1:3:length(in.TzEx(:,1))
       % plot(in.time(1:125), abs(in.TzPredictedEx(i,:)), 'lineWidth', 1.8, 'color', [0 0 0], 'lineStyle', '--')
      plot(in.time(1:123), -in.TzCurrentEx(i,3:end), 'lineWidth', 1.8, 'color', [0 0 0], 'lineStyle', ':')
    plot(in.time(1:125), -in.TzEx(i,:), 'lineWidth', 1.8, 'color', [1 0 0 opacityPlot * i])

end
currYlim = ylim;
% rectangle('position', [0.0095 currYlim(1) 0.001 ceil(currYlim(2))], 'FaceColor', [0.8 0.8 0.8], 'lineStyle', 'none');
% rectangle('position', [0.0135 currYlim(1) 0.001 ceil(currYlim(2))], 'FaceColor', [0.65 0.65 0.65], 'lineStyle', 'none');
% rectangle('position', [0.0155 currYlim(1) 0.001 ceil(currYlim(2))], 'FaceColor',  [0.5 0.5 0.5], 'lineStyle', 'none');
% rectangle('position', [0.0195 currYlim(1) 0.001 ceil(currYlim(2))], 'FaceColor', [0.3 0.3 0.3], 'lineStyle', 'none');
% rectangle('position', [0.0295 currYlim(1) 0.001 ceil(currYlim(2))], 'FaceColor', [0 0 0], 'lineStyle', 'none');
lege = legend({'Measured torque at various command levels', 'Estimated torque from measured current'});
lege.Position = [0.58 0.82 0.1 0.07];
lege.Box = 'off';
plt.YLim = [0 3.7];
plt.XLim = [0 0.11];
%plt.YGrid = 'on';
q = get(gca, 'Children');
q = [q(6:end-2); q(1:5); q(end-1:end)];
set(gca, 'Children', q)
s = 1;