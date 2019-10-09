function plotSingleTraces(traces, limits, sampleTime, trialType, sessionData, saveFig, basesave)
figure('units','normalized','outerposition',[0 0 1 1])
numVelTraces = 1;
modCounter = 1;
Fs = 500;  % Sampling Frequency

N    = 3;        % Order
Fc   = 200;      % Cutoff Frequency
flag = 'scale';  % Sampling Flag
Beta = 0.5;      % Window Parameter

% Create the window vector for the design algorithm.
win = kaiser(N+1, Beta);

% Calculate the coefficients using the FIR1 function.
b  = fir1(N, Fc/(Fs/2), 'low', win, flag);
%Hd = dfilt.dffir(b);
while numVelTraces < length(traces)
    subplot(6,6,modCounter)
    if sessionData.protocolVersion == 20170618        
        h = plot([0:sampleTime:(sampleTime*length(traces{numVelTraces})-sampleTime)] + limits(1), 6*traces{numVelTraces});
        h.Color(4) = 0.5;
    else
        h = plot([0:sampleTime:(sampleTime*length(traces{numVelTraces})-sampleTime)] + limits(1), traces{numVelTraces}, 'b');
        h.Color(4) = 0.5;
        hold on
       % h = plot([0:sampleTime:(sampleTime*length(traces{numVelTraces})-sampleTime)] + limits(1), filter(b,1,traces{numVelTraces}), 'k');
        h.Color(4) = 0.5;
        hold on
        Fc = 150;
        b  = fir1(N, Fc/(Fs/2), 'low', win, flag);
        h = plot([0:sampleTime:(sampleTime*length(traces{numVelTraces})-sampleTime)] + limits(1), filter(b,1,traces{numVelTraces}), 'r');
        h.Color(4) = 0.5;
        hold on
        Fc = 100;
        b  = fir1(N, Fc/(Fs/2), 'low', win, flag);
        h = plot([0:sampleTime:(sampleTime*length(traces{numVelTraces})-sampleTime)] + limits(1), filter(b,1,traces{numVelTraces}), 'g');
        h.Color(4) = 0.5;
       %  legend({'No smoothing', 'N = 3, Fc = 180', 'N = 3, Fc = 150'})
    end
    title([trialType{1} ' ' num2str(numVelTraces)])
    xlabel('Time after trial onset (ms)')
    ylabel(trialType{2})
    axis([limits(1,:) limits(2,:)])
    hold on
    h = plot([0 0], limits(2,:), 'k--');% second row is y lim
    h.Color(4) = 0.3;
    hold on
            h = plot([-100 500], [75 75], 'k--');
        h.Color(4) = 0.3;
    if mod(numVelTraces, 36) == 0 % loop again until done
        modCounter = 1;
        if saveFig
            export_fig([basesave sessionData.subject ' ' regexprep(sessionData.date, '/', '-') ' ' sessionData.session ' separate kinematics'], '-append', '-pdf')
        end
        close all
        figure('units','normalized','outerposition',[0 0 1 1])
    else
        modCounter = modCounter + 1;
    end
    numVelTraces = numVelTraces + 1;
    if numVelTraces == length(traces) && mod(numVelTraces, 36) ~= 0
        if saveFig
            export_fig([basesave sessionData.subject ' ' regexprep(sessionData.date, '/', '-') ' ' sessionData.session ' separate kinematics'], '-append', '-pdf')
        end
    end
end