function touchDetectCode(trials, sessionData, trialNum, varargin)
% Author: Tony Corsten 07/03/18, tony.corsten93@gmail.com
% Updated: 9/8/18
% This code analyzes touch data from the mpr121 to determine an effective filtering /
% thresholding method. The variable inputs are as follows:
% touchDetectCode(trials, trialNumber, defaultTouchThresh)
% trials is the struct array of trial data
% trialNumber is the trial number in the session to be analyzed
% defaultTouchThresh is the scalar multiplier on the threshold, which is multiplied by the standard deviation to determine an adaptive thresholding method.
pdfNum = 1;
% assign default
if length(varargin) >= 1
    defaultTouchThresh = varargin{1};
else
    defaultTouchThresh = -1;
end

if trialNum == 0
    trialSelect = 1:length(trials);
    figure('units','normalized','outerposition',[0 0 1 1], 'visible', 'off')
else
    trialSelect = trialNum;
    figure('units', 'normalized', 'outerposition', [0 0 1 1])
end

for j = trialSelect
    a = double(trials(j).touchRaw);
    if ((~trialNum && j ~= 1) || j == length(trials))
        filename{pdfNum} =  [pwd '\pdfs\' 'filteredTouchPlotsWide2_' sessionData.subject '_' regexprep(sessionData.date, '/', '') num2str(j)];
        eval(['export_fig '  filename{pdfNum} ' -pdf'])
        fprintf('Saving file %s / %s....\n', num2str(pdfNum), num2str(length(trials)));
        pdfNum = pdfNum + 1;
        close all
        figure('units','normalized','outerposition',[0 0 1 1], 'visible', 'off')
    elseif trialNum
        close all
        figure('units','normalized','outerposition',[0 0 1 1])
    end
    
    velPos = abs(trials(j).velRaw) - 15 > 0;
    padLen = max(0, length(a) - length(velPos));
    velNonZero = padarray(velPos, padLen, 0, 'post');
    diffVelPos = [0 diff(velPos)'];
    [filt_signal, s_filt] = twoSampleLP(a, 0.4);
    dFilt = [0 diff(filt_signal)];
    smoothingFactor = 0.4;
    [baseline, touchTrue] = baselineLP(filt_signal, smoothingFactor, velNonZero);
    diff_signal = filt_signal - baseline;
    s = calc_stdev(diff_signal, 0.1, 0.05);
    
    % stdAllDiff = std(diff_signal);
    touchThresh = defaultTouchThresh * s;
    %touchThresh = -1;
    touchHit = (diff_signal < touchThresh) & (diff_signal < -1);
    touchHit = diff_signal < -3;
    %touchHit = diff_signal < defaultTouchThresh;
    diffTouch = [0 diff(touchHit)];
    touchAreas = calcActiveRegions(diffTouch, 6, 10);
    
    velAreas = calcActiveRegions(diffVelPos, 3, 2);
    opacityPlot = 0.25;
    %% plot raw and filtered signal
    subplot(3,1,1);
    plot(a, 'lineStyle', '-', 'lineWidth', 1.2)
    hold on
    plot(filt_signal, 'lineStyle', '--', 'lineWidth', 1.5)
    plot(baseline, 'lineStyle', ':', 'lineWidth', 2)
    
    currYlim = ylim;
    if ~isempty(touchAreas)
        for i = 1:length(touchAreas(:,1))
            rectangle('position', [touchAreas(i, 1) currYlim(1) (touchAreas(i,2) - touchAreas(i,1)) currYlim(2)], 'FaceColor', [1 0 0 opacityPlot], 'lineStyle', 'none');
        end
    end
    for i = 1:length(velAreas(:,1))
        rectangle('position', [velAreas(i, 1) currYlim(1) (velAreas(i,2) - velAreas(i,1)) currYlim(2)], 'FaceColor', [0 0 1 opacityPlot], 'lineStyle', 'none');
    end
    
    line(NaN,NaN,'LineWidth',2,'LineStyle','-','Color',[1 0 0 opacityPlot]); % line for legend, touch region
    line(NaN,NaN,'LineWidth',2,'LineStyle','-','Color',[0 0 1 opacityPlot]); % line for legend, non-zero vel region
    %plot(baseline - s_filt * 4, 'lineStyle', ':', 'lineWidth', 1.5, 'color', 'g', 'HandleVisibility', 'off')
    legend({'Raw', 'Filtered Signal', 'Baseline',  'Touch Region', 'Nonzero Vel'}, 'location', 'NorthEast')
    ylim(currYlim)
    title(['Touch sensor data detection trial ' num2str(j)])
    xlabel('Samples')
    ylabel('Touch Sensor Data')
    set(gca, 'FontSize', 16)
    
    %% plot derivative of filtered signal 
    subplot(3,1,2)
    plot(dFilt, 'lineWidth', 2)
    title('Derivative of filtered signal')
    xlabel('Samples')
    ylabel('dFiltered touch')
    set(gca, 'FontSize', 16)
    
    %% plot difference signal
    subplot(3,1,3);
    plot(diff_signal, 'lineWidth', 1.2)
    hold on
    currYlim = ylim;
    if ~isempty(touchAreas)
        for i = 1:length(touchAreas(:,1))
            rectangle('position', [touchAreas(i, 1) currYlim(1) (touchAreas(i,2) - touchAreas(i,1)) (currYlim(2) - currYlim(1))], 'FaceColor', [1 0 0 opacityPlot], 'lineStyle', 'none');
        end
    end
    for i = 1:length(velAreas(:,1))
        rectangle('position', [velAreas(i, 1) currYlim(1) (velAreas(i,2) - velAreas(i,1)) (currYlim(2) - currYlim(1))], 'FaceColor', [0 0 1 opacityPlot], 'lineStyle', 'none');
    end
    line(NaN,NaN,'LineWidth',2,'LineStyle','-','Color',[1 0 0 opacityPlot]);
    line(NaN,NaN,'LineWidth',2,'LineStyle','-','Color',[0 0 1 opacityPlot]);
    touchThresh(touchThresh > -1) = -1;
    h=  refline(0, -3);
    h.Color = 'g';
    %plot(touchThresh, 'lineStyle', ':', 'lineWidth', 1.5, 'color', 'g')
    %         refline(0, -1)
    legend({'Difference Signal', 'Touch Region', 'Non-zero Vel', 'Threshold'}, 'location', 'NorthEast')
    ylim(currYlim)
    title('Subtracted touch data (filtered and baseline)')
    xlabel('Samples')
    ylabel('Touch Sensor Data Difference')
    set(gca, 'FontSize', 16)
end

%% combine all pdfs 

% use trial 3 for turning example (0.6 - 0.9)
% use trial 4 for holding example 
% use trial 12 for multiple hold and turns for changing baseline (0 - 1.1)
% use trial 18 for better holding example (2.35 - 2.9)
% use trial 20 for BEST holding example (1.1 - 1.6)
if ~trialNum
    filename = cellfun(@(x) [x '.pdf'], filename, 'UniformOutput', false);
    append_pdfs( [pwd '\pdfs\' 'filteredTouchPlotsWide2_' sessionData.subject '_' regexprep(sessionData.date, '/', '') '.pdf'], filename{:})
    delete(filename{:})
end
%'lineWidth', 2
%% FOR PLOT ONLY
plt = Plot(0:.002:0.002*(length(a)-1),a);
plt.BoxDim = [17 8];
%plt.Title = 'Raw touch sensor signal with knob hold and release only (no turning)';
plt.XLabel = 'Time (s)';
plt.YLabel = 'Touch sensor value (proportional to capacitance)';
hold on 

%   if ~isempty(touchAreas)
%         for i = 1:length(touchAreas(:,1))
%             rectangle('position', [touchAreas(i, 1) * 0.002, currYlim(1), 0.002*(touchAreas(i,2) - touchAreas(i,1)), (currYlim(2) - currYlim(1))], 'FaceColor', [1 0 0 opacityPlot], 'lineStyle', 'none');
%         end
%     end
plt.LineWidth = [2.5];
plt.XLim = [1.1 1.6];
plt.YLim = [148 175];
%plt.YLim = [146 170];
set(gca, 'XTickLabel', [0 : 0.05 : 0.5])
plt.Colors = {[0 0 0]};
 plt.LineStyle = {':'};
plt.YGrid = 'on';
 currYlim = ylim;
%     lege = legend({'Raw Touch Signal'});
%  lege.Position = [0.7 0.73 0.2 0.07];
%  lege.Box = 'off';
%  plt.Legend = {'Touch Sensor Signal', 'Non-Zero Knob Velocity'};

%% FOR NON-ZERO VELOCITY ONLY
plt = Plot(0:.002:0.002*(length(a)-1),a, NaN, NaN);
plt.BoxDim = [17 8];
%plt.Title = 'Raw touch sensor signal with knob hold and release only (no turning)';
plt.XLabel = 'Time (s)';
plt.YLabel = 'Touch sensor value (proportional to capacitance)';
hold on 

%   if ~isempty(touchAreas)
%         for i = 1:length(touchAreas(:,1))
%             rectangle('position', [touchAreas(i, 1) * 0.002, currYlim(1), 0.002*(touchAreas(i,2) - touchAreas(i,1)), (currYlim(2) - currYlim(1))], 'FaceColor', [1 0 0 opacityPlot], 'lineStyle', 'none');
%         end
%     end
plt.LineWidth = [2.5 15];
plt.XLim = [0.6 0.9];
%plt.YLim = [146 170];
% set(gca, 'XTickLabel', [0 : 0.2 : 1.1])
set(gca, 'XTickLabel', [0 : 0.05 : 0.5])
plt.Colors = {[0 0 0], [214/255 214/255 214/255]};
 plt.LineStyle = {':', '-'};
plt.YGrid = 'on';
 currYlim = ylim;
    for i = 1:length(velAreas(:,1))
        rectangle('position', [0.002*velAreas(i, 1) - 0.002 currYlim(1) 0.002*(velAreas(i,2) - velAreas(i,1)) - 0.002 (currYlim(2) - currYlim(1))], 'FaceColor', [0.2 0.2 0.2 0.2], 'lineStyle', 'none');
    end
    lege = legend({'Raw Touch Signal', 'Non-Zero Knob Velocity'});
 lege.Position = [0.76 0.78 0.2 0.07];
 lege.Box = 'off';
%  plt.Legend = {'Touch Sensor Signal', 'Non-Zero Knob Velocity'};


%% FOR TOUCH ONLY
plt = Plot(0:.002:0.002*(length(a)-1),a, 0:.002:0.002*(length(a)-1), filt_signal, 0:.002:0.002*(length(a)-1), baseline, NaN, NaN );
plt.BoxDim = [17 8];
%plt.Title = 'Raw touch sensor signal with knob hold and release only (no turning)';
plt.XLabel = 'Time (s)';
plt.YLabel = 'Touch sensor value (arbitrary units)';
hold on 
plt.LineWidth = [2.5 2.5 2.5 15];
plt.XLim = [1.1 1.6];
plt.YLim = [148 175];
% set(gca, 'XTickLabel', [0 : 0.2 : 1.1])
set(gca, 'XTickLabel', [0 : 0.05 : 0.5])
plt.Colors = {[0 0 0], [0/255 119/255 3/255], [181/255 0/255 0/255], [204/255 204/255 255/255], [204/255 204/255 1], [209/255 183/255 229/255]};
 plt.LineStyle = {':', '-'};
plt.YGrid = 'on';
 currYlim = ylim;
 if ~isempty(touchAreas)
        for i = 1:length(touchAreas(:,1))
            rectangle('position', [touchAreas(i, 1) * 0.002 - 0.002, currYlim(1), 0.002*(touchAreas(i,2) - touchAreas(i,1)) - 0.002, (currYlim(2) - currYlim(1))], 'FaceColor', [0 0 1 0.2], 'lineStyle', 'none');
        end
    end

        lege = legend({'Raw Touch Signal', 'Lowpass (2-Sample) Filtered Signal', 'Estimated Baseline Signal', 'Touch Active Region'});
 lege.Position = [0.72 0.78 0.2 0.07];
 q = get(gca, 'Children');
 %q(end+1:end+length(q) - 4) = q(1:);
% q(1) = [];
q = [q(end-3 : end); q(1:end-4)];
 set(gca, 'Children', q)
 lege.Box = 'off';

%% FOR TOUCH + VEL
plt = Plot(0:.002:0.002*(length(a)-1),a, 0:.002:0.002*(length(a)-1), filt_signal, 0:.002:0.002*(length(a)-1), baseline, NaN, NaN, NaN, NaN, NaN, NaN);
plt.BoxDim = [17 8];
%plt.Title = 'Raw touch sensor signal with knob hold and release only (no turning)';
plt.XLabel = 'Time (s)';
plt.YLabel = 'Touch sensor value (arbitrary units)';
hold on 
plt.LineWidth = [2.5 2.5 2.5 15];
plt.XLim = [0.6 0.9];
%plt.YLim = [146 170];
% set(gca, 'XTickLabel', [0 : 0.2 : 1.1])
 set(gca, 'XTickLabel', [0 : 0.05 : 0.5])
plt.Colors = {[0 0 0], [0/255 119/255 3/255], [181/255 0/255 0/255], [204/255 204/255 255/255], [214/255 214/255 214/255], [171/255 171/255 212/255]};
 plt.LineStyle = {':', '-'};
plt.YGrid = 'on';
 currYlim = ylim;
    for i = 1:length(velAreas(:,1))
        rectangle('position', [0.002*velAreas(i, 1) - 0.002 currYlim(1) 0.002*(velAreas(i,2) - velAreas(i,1))-0.002 (currYlim(2) - currYlim(1))], 'FaceColor', [0.2 0.2 0.2 0.2], 'lineStyle', 'none');
    end
%     if ~isempty(touchAreas)
%         for i = 1:length(touchAreas(:,1))
%             rectangle('position', [0.002*touchAreas(i, 1) currYlim(1) 0.002*(touchAreas(i,2) - touchAreas(i,1)) (currYlim(2) - currYlim(1))], 'FaceColor', [1 0 0 0.2], 'lineStyle', 'none');
%         end
%     end
  if ~isempty(touchAreas)
        for i = 1:length(touchAreas(:,1))
            rectangle('position', [touchAreas(i, 1) * 0.002 - 0.002, currYlim(1), 0.002*(touchAreas(i,2) - touchAreas(i,1)) - 0.002, (currYlim(2) - currYlim(1))], 'FaceColor', [0 0 1 0.2], 'lineStyle', 'none');
        end
    end
        lege = legend({'Raw Touch Signal', 'Lowpass (2-Sample) Signal', 'Estimated Baseline Signal', 'Touch Active Region', 'Non-Zero Velocity Region', 'Touch and Velocity Overlap'});
 lege.Position = [0.72 0.77 0.2 0.07];
 q = get(gca, 'Children');
 %q(end+1:end+length(q) - 4) = q(1:);
% q(1) = [];
q = [q(end-5 : end); q(1:end-6)];
 set(gca, 'Children', q)
 lege.Box = 'off';
 
 
 plt = Plot(0:.002:0.002*(length(a)-1), diff_signal, 0:.002:0.002*(length(a)-1), -3 * ones(length(a),1), NaN, NaN, NaN, NaN, NaN, NaN);
plt.BoxDim = [17 8];
%plt.Title = 'Raw touch sensor signal with knob hold and release only (no turning)';
plt.XLabel = 'Time (s)';
plt.YLabel = 'Touch sensor value (proportional to capacitance)';
hold on 
 currYlim = ylim;
  if ~isempty(touchAreas)
        for i = 1:length(touchAreas(:,1))
            rectangle('position', [touchAreas(i, 1) * 0.002 - 0.002, currYlim(1), 0.002*(touchAreas(i,2) - touchAreas(i,1)) - 0.002, (currYlim(2) - currYlim(1))], 'FaceColor', [0 0 1 0.2], 'lineStyle', 'none');
        end
  end
       for i = 1:length(velAreas(:,1))
        rectangle('position', [0.002*velAreas(i, 1) - 0.002 currYlim(1) 0.002*(velAreas(i,2) - velAreas(i,1))-0.002 (currYlim(2) - currYlim(1))], 'FaceColor', [0.2 0.2 0.2 0.2], 'lineStyle', 'none');
    end
plt.LineWidth = [2.5, 2.5, 15, 15 , 15];
plt.XLim = [0.6 0.9];
%plt.YLim = [148 175];
%plt.YLim = [146 170];
%set(gca, 'XTickLabel', [0 : 0.2 : 1.1])
set(gca, 'XTickLabel', [0 : 0.05 : 0.5])
plt.Colors = {[0 0 0], [1 0 0],  [204/255 204/255 255/255], [214/255 214/255 214/255], [171/255 171/255 212/255]};
 plt.LineStyle = {'-', ':', '-'};
plt.YGrid = 'on';

    lege = legend({'Baseline - Filtered Signal', 'Touch Detection Threshold',  'Touch Active Region',  'Non-Zero Velocity Region', 'Touch and Velocity Overlap'});
 lege.Position = [0.4 0.71 0.2 0.07];
 lege.Box = 'off';
 q = get(gca, 'Children');
q = [q(end-4 : end); q(1:end-5)];
 set(gca, 'Children', q)
 
 
 %% FOR DIFF SIGNAL TOUCH ONLY
 plt = Plot(0:.002:0.002*(length(a)-1), diff_signal, 0:.002:0.002*(length(a)-1), -3 * ones(length(a),1), NaN, NaN);
plt.BoxDim = [17 8];
%plt.Title = 'Raw touch sensor signal with knob hold and release only (no turning)';
plt.XLabel = 'Time (s)';
plt.YLabel = 'Touch sensor value (proportional to capacitance)';
hold on 

plt.LineWidth = [2.5, 2.5, 15];
plt.XLim = [1.1 1.6];

%plt.YLim = [148 175];
plt.YLim = [-14 5];
%set(gca, 'XTickLabel', [0 : 0.2 : 1.1])
 currYlim = ylim;
  if ~isempty(touchAreas)
        for i = 1:length(touchAreas(:,1))
            rectangle('position', [touchAreas(i, 1) * 0.002 - 0.002, currYlim(1), 0.002*(touchAreas(i,2) - touchAreas(i,1)) - 0.002, (currYlim(2) - currYlim(1))], 'FaceColor', [0 0 1 0.2], 'lineStyle', 'none');
        end
  end
set(gca, 'XTickLabel', [0 : 0.05 : 0.5])
plt.Colors = {[0 0 0], [1 0 0],  [204/255 204/255 255/255]};
 plt.LineStyle = {'-', ':', '-'};
plt.YGrid = 'on';

    lege = legend({'Baseline - Filtered Signal', 'Touch Detection Threshold',  'Touch Active Region'});
 lege.Position = [0.4 0.71 0.2 0.07];
 lege.Box = 'off';
 q = get(gca, 'Children');
q = [q(end-2 : end); q(1:end-3)];
 set(gca, 'Children', q)
s  = 1;