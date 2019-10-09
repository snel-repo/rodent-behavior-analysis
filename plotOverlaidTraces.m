function plotOverlaidTraces(traces, eventData, protocolVersion, limits, sampleTime, trialType)

% Fs = 500;  % Sampling Frequency
% 
% N    = 3;        % Order
% Fc   = 180;      % Cutoff Frequency
% flag = 'scale';  % Sampling Flag
% Beta = 0.5;      % Window Parameter
% 
% % Create the window vector for the design algorithm.
% win = kaiser(N+1, Beta);
% 
% % Calculate the coefficients using the FIR1 function.
% b  = fir1(N, Fc/(Fs/2), 'low', win, flag);

Fs = 500;  % Sampling Frequency

N    = 3;        % Order
Fc   = 100;      % Cutoff Frequency
flag = 'scale';  % Sampling Flag
Beta = 0.5;      % Window Parameter

% Create the window vector for the design algorithm.
win = kaiser(N+1, Beta);

% Calculate the coefficients using the FIR1 function.
b  = fir1(N, Fc/(Fs/2), 'low', win, flag);

figure('units','normalized','outerposition',[0 0 1 1])
for numTraces = 1:length(traces)
        if protocolVersion == 20170618
        h = plot([limits(1,1):sampleTime:(limits(1,2)*length(traces)-sampleTime)], 6*traces{numTraces}, 'g', 'lineWidth', 2);
        h.Color(4) = 0.3;
        hold on
    else
        h = plot([0:sampleTime:sampleTime*length(traces{numTraces})-sampleTime]+ limits(1), filter(b, 1,traces{numTraces}), 'g', 'lineWidth', 2);
        h.Color(4) = 0.3;
        hold on
        end
        scatter(eventData{numTraces,1}, eventData{numTraces, 2}, 40, 'r', 'filled')
end
    title(['Overlaid traces for ' trialType{1} ' trials'])
    xlabel('Time after trial onset (ms)')
    axis([limits(1,:) limits(2,:)])
    ylabel(trialType{2})
    h = plot([0 0], limits(2,:), 'k--', 'lineWidth', 2);% second row is y lim
    h.Color(4) = 0.3;
    
