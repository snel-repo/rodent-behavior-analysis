function [y] = extractNano17GaugeData(dataDir, durationIn)
for i = 1:length(dataDir)
    x = load(dataDir{i});
% x = preprocessNano17(x);
    
    startTimes = find([0; diff(x.trial.stepOn) == 1]);
    endTimes = find([0; diff(x.trial.stepOn) == -1]);
    endTimes = [1; endTimes];
    sortedSE = sort([startTimes; endTimes]);
    
    duration = uint32(durationIn /  (x.trial.sampleTime(1) / 1e-3));
    durationOff = 125;
    x.trial.G0 = removePLI(x.trial.G0, 500, 4, [60, 0.01, 0.5], [0.1, 2, 4], 0.5, 60);
    x.trial.G1 = removePLI(x.trial.G1, 500, 4, [60, 0.01, 0.5], [0.1, 2, 4], 0.5, 60);
    x.trial.G2 = removePLI(x.trial.G2, 500, 4, [60, 0.01, 0.5], [0.1, 2, 4], 0.5, 60);
    x.trial.G3 = removePLI(x.trial.G3, 500, 4, [60, 0.01, 0.5], [0.1, 2, 4], 0.5, 60);
    x.trial.G4 = removePLI(x.trial.G4, 500, 4, [60, 0.01, 0.5], [0.1, 2, 4], 0.5, 60);
    x.trial.G5 = removePLI(x.trial.G5, 500, 4, [60, 0.01, 0.5], [0.1, 2, 4], 0.5, 60);
    matPos = 1;
    if ~isempty(startTimes) &&  (startTimes(end) + duration) <= length(x.trial.G0)
        for j = 1:length(startTimes)
            y.G0Raw(i, matPos : matPos + duration-1) = x.trial.G0(startTimes(j) : startTimes(j) + duration - 1);
            y.G1Raw(i, matPos : matPos + duration-1) = x.trial.G1(startTimes(j) : startTimes(j) + duration - 1);
            y.G2Raw(i, matPos : matPos + duration-1) = x.trial.G2(startTimes(j) : startTimes(j) + duration - 1);
            y.G3Raw(i, matPos : matPos + duration-1) = x.trial.G3(startTimes(j) : startTimes(j) + duration - 1);
            y.G4Raw(i, matPos : matPos + duration-1) = x.trial.G4(startTimes(j) : startTimes(j) + duration - 1);
            y.G5Raw(i, matPos : matPos + duration-1) = x.trial.G5(startTimes(j) : startTimes(j) + duration - 1);
            y.voltageRaw(i, matPos : matPos + duration-1) = x.trial.voltage(startTimes(j) : startTimes(j) + duration - 1);
            y.stepOnRaw(i, matPos : matPos + duration-1) = x.trial.stepOn(startTimes(j) : startTimes(j) + duration - 1);
            y.currentRaw(i, matPos : matPos + duration-1) = x.trial.current(startTimes(j) : startTimes(j) + duration - 1);
            y.velRaw(i, matPos : matPos + duration-1) = x.trial.vel(startTimes(j) : startTimes(j) + duration - 1);
            y.posRaw(i, matPos : matPos + duration-1) = x.trial.pos(startTimes(j) : startTimes(j) + duration - 1);
            if isfield(x, 'stepDivisor')
                y.stepDivisorRaw(i, matPos : matPos + duration-1) = x.trial.stepDivisor(startTimes(j) : startTimes(j) + duration - 1);
            end
            y.timerStepRaw(i, matPos : matPos + duration-1) = x.trial.timerStep(startTimes(j) : startTimes(j) + duration - 1);
            matPos = matPos + duration;
        end
        
        matPos = 1;
        for j = 1:length(sortedSE)
            if any(sortedSE(j) == startTimes)
                y.G0RawAll(i, matPos : matPos + duration-1) = x.trial.G0(sortedSE(j) : sortedSE(j) + duration - 1);
                y.G1RawAll(i, matPos : matPos + duration-1) = x.trial.G1(sortedSE(j) : sortedSE(j) + duration - 1);
                y.G2RawAll(i, matPos : matPos + duration-1) =  x.trial.G2(sortedSE(j) : sortedSE(j) + duration - 1);
                y.G3RawAll(i, matPos : matPos + duration-1) = x.trial.G3(sortedSE(j) : sortedSE(j) + duration - 1);
                y.G4RawAll(i, matPos : matPos + duration-1) = x.trial.G4(sortedSE(j) : sortedSE(j) + duration - 1);
                y.G5RawAll(i, matPos : matPos + duration-1) = x.trial.G5(sortedSE(j) : sortedSE(j) + duration - 1);
                y.voltageRawAll(i, matPos : matPos + duration-1) = x.trial.voltage(sortedSE(j) : sortedSE(j) + duration - 1);
                y.stepOnRawAll(i, matPos : matPos + duration-1) = x.trial.stepOn(sortedSE(j) : sortedSE(j) + duration - 1);
                y.currentRawAll(i, matPos : matPos + duration-1) = x.trial.current(sortedSE(j) : sortedSE(j) + duration - 1);
                matPos = matPos + duration;
            else
                y.G0RawAll(i, matPos : matPos + durationOff-1) = x.trial.G0(sortedSE(j) : sortedSE(j) + durationOff - 1);
                y.G1RawAll(i, matPos : matPos + durationOff-1) = x.trial.G1(sortedSE(j) : sortedSE(j) + durationOff - 1);
                y.G2RawAll(i, matPos : matPos + durationOff-1) = x.trial.G2(sortedSE(j) : sortedSE(j) + durationOff - 1);
                y.G3RawAll(i, matPos : matPos + durationOff-1) = x.trial.G3(sortedSE(j) : sortedSE(j) + durationOff - 1);
                y.G4RawAll(i, matPos : matPos + durationOff-1) = x.trial.G4(sortedSE(j) : sortedSE(j) + durationOff - 1);
                y.G5RawAll(i, matPos : matPos + durationOff-1) = x.trial.G5(sortedSE(j) : sortedSE(j) + durationOff - 1);
                y.voltageRawAll(i, matPos : matPos + durationOff -1) = x.trial.voltage(sortedSE(j) : sortedSE(j) + durationOff - 1);
                y.stepOnRawAll(i, matPos : matPos + durationOff -1) = x.trial.stepOn(sortedSE(j) : sortedSE(j) + durationOff - 1);
                y.currentRawAll(i, matPos : matPos + durationOff -1) = x.trial.current(sortedSE(j) : sortedSE(j) + durationOff  - 1);
                matPos = matPos + durationOff;
            end
            
        end
    else
        fprintf(['Skipping ' x.trial.trialIdStr '\n'])
    end
    y.G0ZeroRaw(i, 1:50) = x.trial.G0(1:50); % there is always a step OFF before a step ON
    y.G1ZeroRaw(i, 1:50) = x.trial.G1(1:50); % there is always a step OFF before a step ON
    y.G2ZeroRaw(i, 1:50) = x.trial.G2(1:50); % there is always a step OFF before a step ON
    y.G3ZeroRaw(i, 1:50) = x.trial.G3(1:50); % there is always a step OFF before a step ON
    y.G4ZeroRaw(i, 1:50) = x.trial.G4(1:50); % there is always a step OFF before a step ON
    y.G5ZeroRaw(i, 1:50) = x.trial.G5(1:50); % there is always a step OFF before a step ON
end
y.voltageMax = x.trial.voltageMax(1);
y.voltageStep = x.trial.voltageStep(1);
y.sampleTime = x.trial.sampleTime(1) / 1e-3;
y.voltage = mode(y.voltageRaw,1);
if isfield(y, 'stepDivisorRaw')
    y.stepDivisor = mode(y.stepDivisorRaw,1);
end
y.totalVoltageStep =  y.voltageMax / y.voltageStep + 1;
y.stepOn = find(repelem(repmat([0 1], 1, floor((length(y.G0Raw(1,:)) / duration) / 2)), duration));
y.stepOnReal = mode(y.stepOnRaw,1);
y.duration = duration;
y.timeArray = [0:2:2*length(y.G0Raw(1,:))-1];
y.torqueConstant = x.trial.torqueConstant(1);
y.timerStep = mode(y.timerStepRaw,1);

y.G0 = nanmean(y.G0Raw,1);
y.G1 = nanmean(y.G1Raw,1);
y.G2 = nanmean(y.G2Raw,1);
y.G3 = nanmean(y.G3Raw,1);
y.G4 = nanmean(y.G4Raw,1);
y.G5 = nanmean(y.G5Raw,1);
y.vel = nanmean(y.velRaw,1);
y.pos = nanmean(y.posRaw,1);
y.current = nanmean(y.currentRaw,1);

y.G0All = nanmean(y.G0RawAll,1);
y.G1All = nanmean(y.G1RawAll,1);
y.G2All = nanmean(y.G2RawAll,1);
y.G3All = nanmean(y.G3RawAll,1);
y.G4All = nanmean(y.G4RawAll,1);
y.G5All = nanmean(y.G5RawAll,1);
y.currentAll = nanmean(y.currentRawAll,1);
y.voltageAll = mode(y.voltageRawAll,1);
y.stepOnAll = mode(y.stepOnRawAll,1);

y.G0Zero = nanmean(y.G0All(1:100));
y.G1Zero = nanmean(y.G1All(1:100));
y.G2Zero = nanmean(y.G2All(1:100));
y.G3Zero = nanmean(y.G3All(1:100));
y.G4Zero = nanmean(y.G4All(1:100));
y.G5Zero = nanmean(y.G5All(1:100));

y.G0Sub = y.G0 - y.G0Zero;
y.G1Sub = y.G1 - y.G1Zero;
y.G2Sub = y.G2 - y.G2Zero;
y.G3Sub = y.G3 - y.G3Zero;
y.G4Sub = y.G4 - y.G4Zero;
y.G5Sub = y.G5 - y.G5Zero;

y.G0AllSub= y.G0All - y.G0Zero;
y.G1AllSub = y.G1All - y.G1Zero;
y.G2AllSub = y.G2All - y.G2Zero;
y.G3AllSub = y.G3All - y.G3Zero;
y.G4AllSub = y.G4All - y.G4Zero;
y.G5AllSub = y.G5All - y.G5Zero;

y.saveTag = x.trial.saveTag;
y.time = 0.002*(0:1:length(y.G0)-1);

