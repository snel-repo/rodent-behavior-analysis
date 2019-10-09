function [y] = nano17FTCalc(y, calMat, currentMax)

y.Fx = y.G0Sub .* calMat(1,1) + y.G1Sub .* calMat(1,2) + y.G2Sub .* calMat(1,3) + y.G3Sub .* calMat(1,4) + y.G4Sub .* calMat(1,5) + y.G5Sub .* calMat(1,6);
y.Fy = y.G0Sub .* calMat(2,1) + y.G1Sub .* calMat(2,2) + y.G2Sub .* calMat(2,3) + y.G3Sub .* calMat(2,4) + y.G4Sub .* calMat(2,5) + y.G5Sub .* calMat(2,6);
y.Fz = y.G0Sub .* calMat(3,1) + y.G1Sub .* calMat(3,2) + y.G2Sub .* calMat(3,3) + y.G3Sub .* calMat(3,4) + y.G4Sub .* calMat(3,5) + y.G5Sub .* calMat(3,6);
y.Tx = y.G0Sub .* calMat(4,1) + y.G1Sub .* calMat(4,2) + y.G2Sub .* calMat(4,3) + y.G3Sub .* calMat(4,4) + y.G4Sub .* calMat(4,5) + y.G5Sub .* calMat(4,6);
y.Ty = y.G0Sub .* calMat(5,1) + y.G1Sub .* calMat(5,2) + y.G2Sub .* calMat(5,3) + y.G3Sub .* calMat(5,4) + y.G4Sub .* calMat(5,5) + y.G5Sub .* calMat(5,6);
y.Tz = y.G0Sub .* calMat(6,1) + y.G1Sub .* calMat(6,2) + y.G2Sub .* calMat(6,3) + y.G3Sub .* calMat(6,4) + y.G4Sub .* calMat(6,5) + y.G5Sub .* calMat(6,6);

y.FxAll = y.G0AllSub .* calMat(1,1) + y.G1AllSub .* calMat(1,2) + y.G2AllSub .* calMat(1,3) + y.G3AllSub .* calMat(1,4) + y.G4AllSub .* calMat(1,5) + y.G5AllSub .* calMat(1,6);
y.FyAll = y.G0AllSub .* calMat(2,1) + y.G1AllSub .* calMat(2,2) + y.G2AllSub .* calMat(2,3) + y.G3AllSub .* calMat(2,4) + y.G4AllSub .* calMat(2,5) + y.G5AllSub .* calMat(2,6);
y.FzAll = y.G0AllSub .* calMat(3,1) + y.G1AllSub .* calMat(3,2) + y.G2AllSub .* calMat(3,3) + y.G3AllSub .* calMat(3,4) + y.G4AllSub .* calMat(3,5) + y.G5AllSub .* calMat(3,6);
y.TxAll = y.G0AllSub .* calMat(4,1) + y.G1AllSub .* calMat(4,2) + y.G2AllSub .* calMat(4,3) + y.G3AllSub .* calMat(4,4) + y.G4AllSub .* calMat(4,5) + y.G5AllSub .* calMat(4,6);
y.TyAll = y.G0AllSub .* calMat(5,1) + y.G1AllSub .* calMat(5,2) + y.G2AllSub .* calMat(5,3) + y.G3AllSub .* calMat(5,4) + y.G4AllSub .* calMat(5,5) + y.G5AllSub .* calMat(5,6);
y.TzAll = y.G0AllSub .* calMat(6,1) + y.G1AllSub .* calMat(6,2) + y.G2AllSub .* calMat(6,3) + y.G3AllSub .* calMat(6,4) + y.G4AllSub .* calMat(6,5) + y.G5AllSub .* calMat(6,6);

%flip signs
y.Fx = -y.Fx;
y.Fy = -y.Fy;
y.Fz = -y.Fz;
y.Tx = -y.Tx;
y.Ty = -y.Ty;
y.Tz = -y.Tz;

y.FxAll = -y.FxAll;
y.FyAll = -y.FyAll;
y.FzAll = -y.FzAll;
y.TzAll = -y.TzAll;
y.TyAll = -y.TyAll;
y.TxAll = -y.TxAll;

y.TzCurrent = ((y.current / 4) * currentMax / 1000 * y.torqueConstant);
y.TzCurrentAll = ((y.currentAll / 4) * currentMax / 1000 * y.torqueConstant);


% zeroVoltIdx = find(y.voltageAll == 0, 1);
% y.zeroVoltRange = zeroVoltIdx + 10 : zeroVoltIdx + 70;
% 
% y.FxZero = y.Fx - mean(y.FxAll(y.zeroVoltRange));
% y.FyZero = y.Fy - mean(y.FyAll(y.zeroVoltRange));
% y.FzZero = y.Fz - mean(y.FzAll(y.zeroVoltRange));
% y.TxZero = y.Tx - mean(y.TxAll(y.zeroVoltRange));
% y.TyZero = y.Ty - mean(y.TyAll(y.zeroVoltRange));
% y.TzZero = y.Tz - mean(y.TzAll(y.zeroVoltRange));
% 
% 
% 
% y.FxZeroAll = y.FxAll - mean(y.FxAll(y.zeroVoltRange));
% y.FyZeroAll = y.FyAll - mean(y.FyAll(y.zeroVoltRange));
% y.FzZeroAll = y.FzAll - mean(y.FzAll(y.zeroVoltRange));
% y.TxZeroAll = y.TxAll - mean(y.TxAll(y.zeroVoltRange));
% y.TyZeroAll = y.TyAll - mean(y.TyAll(y.zeroVoltRange));
% y.TzZeroAll = y.TzAll - mean(y.TzAll(y.zeroVoltRange));


y.FxEx = reshape(y.Fx, y.duration, y.totalVoltageStep)';
y.FyEx = reshape(y.Fy, y.duration, y.totalVoltageStep)';
y.FzEx = reshape(y.Fz, y.duration, y.totalVoltageStep)';
y.TxEx = reshape(y.Tx, y.duration, y.totalVoltageStep)';
y.TyEx = reshape(y.Ty, y.duration, y.totalVoltageStep)';
y.TzEx = reshape(y.Tz, y.duration, y.totalVoltageStep)';
y.currentEx = reshape(y.current, y.duration, y.totalVoltageStep)';
y.TzCurrentEx = reshape(y.TzCurrent, y.duration, y.totalVoltageStep)';
y.posEx = reshape(y.pos, y.duration, y.totalVoltageStep)';
y.posEx = y.posEx - y.posEx(:,1);
y.velEx = reshape(y.vel, y.duration, y.totalVoltageStep)';
y.velEx = y.velEx - y.velEx(:,1);
y.voltageEx = reshape(y.voltage, y.duration, y.totalVoltageStep)';
y.timerStepEx = reshape(y.timerStep, y.duration, y.totalVoltageStep)';
y.stepOnRealEx = reshape(y.stepOnReal, y.duration, y.totalVoltageStep)';
 y.voltLevels = 1:y.voltageStep: y.voltageMax;
 y.torqueLevels = (y.voltLevels/ 10) .* (currentMax / 1000) .* y.torqueConstant;
y.TzPredictedEx = (y.voltageEx/ 10) .* (currentMax / 1000) .* y.torqueConstant;
y.TzPredicted = (y.voltage / 10) * (currentMax / 1000) * y.torqueConstant;
y.TzPredictedAll  = (y.voltageAll / 10) * (currentMax / 1000) * y.torqueConstant;
y.plotTime = 0:y.sampleTime:y.duration * y.sampleTime - y.sampleTime;

% for i = 1:length(y.voltLevels)
%     % y.FxSR(i) = stepinfo(y.FxEx(i,:), y.plotTime, y.torqueLevels(i));
%     % y.FySR(i) = stepinfo(y.FyEx(i,:), y.plotTime, y.torqueLevels(i));
%     % y.FzSR(i) = stepinfo(y.FzEx(i,:), y.plotTime, y.torqueLevels(i));
%     % y.TxSR(i) = stepinfo(y.TxEx(i,:), y.plotTime, y.torqueLevels(i));
%     % y.TySR(i) = stepinfo(y.TyEx(i,:), y.plotTime, y.torqueLevels(i));
%     y.TzSR(i) = stepinfo(y.TzEx(i,:), y.plotTime, mean(y.TzEx(i,end-50:end)), 'SettlingTimeThreshold', 0.125);
%     y.TzSRCurrent(i) = stepinfo(y.TzCurrentEx(i,:), y.plotTime, y.torqueLevels(i), 'settlingTimeThreshold', 0.05);
% end

