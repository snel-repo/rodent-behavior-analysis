function quickKinViewer(sessionData, saveFig)
basesave = 'Z:\SimulinkCode\sldrt-code\training_figures\';
close all
figure('units','normalized','outerposition',[0 0 1 1])
numVelTraces = 1;
modCounter = 1;
limits = [-100 500; -100 500];

%----PLOT VELOCITY OF MISSED PERTURATION TRIALS----%
plotSingleTraces(sessionData.velMissPert, limits, sessionData.sampleTime, {'Failed Pert Trial', 'Velocity (deg/s)'}, sessionData, saveFig, basesave);
plotSingleTraces(sessionData.velMissNoPert, limits, sessionData.sampleTime, {'Failed Unpert Trial', 'Velocity (deg/s)'}, sessionData, saveFig, basesave);
plotSingleTraces(sessionData.velHitPert, limits, sessionData.sampleTime, {'Successful Pert Trial', 'Velocity (deg/s)'}, sessionData, saveFig, basesave);
plotSingleTraces(sessionData.velHitNoPert, limits, sessionData.sampleTime, {'Successful Unpert Trial', 'Velocity (deg/s)'}, sessionData, saveFig, basesave);


%----PLOT VELOCITY MISS NO PERT ALL OVERLAID-----%
plotOverlaidTraces(sessionData.velMissNoPert, sessionData.noPertMissTime, sessionData.protocolVersion, limits, 2, {'unperturbed missed', 'Velocity (deg / s)'})
if saveFig
    export_fig([basesave sessionData.subject ' ' regexprep(sessionData.date, '/', '-') ' ' sessionData.session ' separate kinematics'], '-append', '-pdf')
end
plotOverlaidTraces(sessionData.velMissPert, sessionData.pertMissTime, sessionData.protocolVersion, limits, 2, {'perturbed missed', 'Velocity (deg / s)'})
if saveFig
    export_fig([basesave sessionData.subject ' ' regexprep(sessionData.date, '/', '-') ' ' sessionData.session ' separate kinematics'], '-append', '-pdf')
end
plotOverlaidTraces(sessionData.velHitNoPert, sessionData.noPertHitTime, sessionData.protocolVersion,limits, 2, {'unperturbed hit', 'Velocity (deg / s)'})
if saveFig
    export_fig([basesave sessionData.subject ' ' regexprep(sessionData.date, '/', '-') ' ' sessionData.session ' separate kinematics'], '-append', '-pdf')
end

plotOverlaidTraces(sessionData.velHitPert, sessionData.pertHitTime, sessionData.protocolVersion, limits, 2, {'perturbed hit', 'Velocity (deg / s)'})
if saveFig
    export_fig([basesave sessionData.subject ' ' regexprep(sessionData.date, '/', '-') ' ' sessionData.session ' separate kinematics'], '-append', '-pdf')
end
close all