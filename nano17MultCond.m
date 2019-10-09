close all
clear all
Tc = 36;  % torque constant
figNum = 1; % starts the array of figures
esconCurrentMax = 150; % mA motor current max
offset = 1;
duration = 250;%625*64;
%this is the calibration matrix from the cal file. DO NOT EDIT THIS FOR THE
%NANO17!!!
% The calibration matrix is a 6x6 and is multiplied by the raw strain gauge
% data (6x1). The output is a 6x1 resolved forces and torques matrix. 
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
nano17meta.saveTags = [];
nano17meta.folder = [];
nano17meta.dir = [];
nano17meta.fullDir = [];
for i = 1:length(selectDirs)
    tmp = dir([q '\' dataDates{selectDirs(i)} '\1']);
    tmpName = {tmp(3:end).name};
    tmpFolder = {tmp(3:end).folder};
    nano17meta.saveTags = [nano17meta.saveTags tmpName];
    tmpF =[];
    [tmpF{1:length(tmpName)}] = deal(dataDates{selectDirs(i)});
    tmpSlash = [];
    [tmpSlash{1:length(tmpName)}] = deal('\');
    nano17meta.folder = [nano17meta.folder tmpF];
    nano17meta.dir = [nano17meta.dir [tmpFolder]];
    nano17meta.fullDir = [nano17meta.fullDir strcat(tmpFolder,tmpSlash, tmpName)];
end
[tmpMeta{1:length(nano17meta.saveTags)}] = deal(': ');
selectTags = listdlg('promptString', 'Select saveTags with relevant data', 'listString', strcat(nano17meta.folder, tmpMeta, nano17meta.saveTags));

extractTags = nano17meta.saveTags(selectTags);
extractTags = strrep(extractTags, '_', '\_');
extractDirs = nano17meta.fullDir(selectTags);

%% Construct data structures for nano17 analysis 
for i = 1:length(extractDirs)
    x = dir(extractDirs{i});
    y ={x.name};
    y = y(3:end-1);
    tmpY = [];
    [tmpY{1:length(y)}] = deal([extractDirs{i} '\']);
    yFull = strcat(tmpY, y);
    struct1 = extractNano17GaugeData(yFull, duration);
    struct2 = nano17FTCalc(struct1, calMat, esconCurrentMax);
    cleanData(i) = struct2;
end
choice = input('Choose an option:\n1 - Torque plots only\n2 - Torque + Step Response Plots\n3 - Torque + Step Response + Raw / Misc Plots\n4 - Torque + Raw / Misc Plots\nSelection: ');
ind = input('\nIndividual torque plots (y/n)?: ', 's');

if strcmp(ind, 'y')
    %% plot overlaid individual torque levels
    for i = 1:length(cleanData(1).voltLevels)
        fig(figNum) = figure('units','normalized','outerposition',[0 0 1 1]);
        figNum = figNum + 1;
        for j = 1:length(cleanData)
            plot(cleanData(j).plotTime, cleanData(j).TzEx(i,:) , 'lineWidth', 2)
            hold on
            plot(cleanData(j).plotTime, cleanData(j).TzCurrentEx(i,:), 'lineWidth', 2)
            hold on
        end
                plot(cleanData(j).plotTime, cleanData(j).TzPredictedEx(i,:), 'lineWidth', 2, 'color', 'r', 'linestyle', '--')

        legend([extractTags 'Torque estimated from current meas.' 'Command Torque'])
        title(['Torque output max command of ' num2str(cleanData(j).torqueLevels(i)) 'mNm'])
        xlabel('Time (ms)')
        ylabel('Torque (mNm)')
        set(gca, 'FontSize', 18)
        %
    end
end
%% plot overlaid torques for individual conditions (one plot for ALL conditons)
fig(figNum) = figure('units','normalized','outerposition',[0 0 1 1]);
figNum = figNum + 1;
colors = lines(length(cleanData));
for i = 1:length(cleanData)
    torquePlots = line(NaN,NaN,'LineWidth',2,'LineStyle','-','Color', colors(i,:));
    hold on
end
steadyStateLine = line(NaN,NaN,'LineWidth',2,'LineStyle','-','Color', 'r');

for i = 1:length(cleanData(1).voltLevels)
    for j = 1:length(cleanData)
        plot(cleanData(j).plotTime, cleanData(j).TzEx(i,:) , 'lineWidth', 2, 'color', colors(j, :))
        hold on
        plot(cleanData(j).plotTime, cleanData(j).TzPredictedEx(i,:), 'lineWidth', 2, 'color', 'r', 'linestyle', '--')
    end
end
legend([extractTags 'Command Torque'])
title(['Overlaid torques curves for all conditions'])
xlabel('Time (ms)')
ylabel('Torque (mNm)')
set(gca, 'FontSize', 24)


%% plot overlaid torques for individual conditions (separate plots per condition)
for i = 1:length(cleanData)
    fig(figNum) = figure('units','normalized','outerposition',[0 0 1 1]);
    figNum = figNum + 1;
    for j = 1:length(cleanData(1).voltLevels)
        plot(cleanData(i).plotTime, cleanData(i).TzEx(j,:) , 'lineWidth', 2, 'color', 'b')
        hold on
        plot(cleanData(i).plotTime, cleanData(i).TzCurrentEx(j,:), 'lineWidth', 2, 'color', [0 0.5 0]) % plot estimated torque from current
        plot(cleanData(i).plotTime,  cleanData(i).TzPredictedEx(j,:), 'lineWidth', 2, 'color', 'r', 'linestyle', '--')
    end
    legend({'Measured Torque', 'Torque estimated from current meas.',  'Command Torque'})
    title(['Torque output for ' extractTags{i}])
    xlabel('Time (ms)')
    ylabel('Torque (mNm)')
    set(gca, 'FontSize', 18)
    %
end

%% plot predicted torques from current for individual conditions (one plot for ALL conditons)
fig(figNum) = figure('units','normalized','outerposition',[0 0 1 1]);
figNum = figNum + 1;
colors = lines(length(cleanData));
for i = 1:length(cleanData)
    torquePlots = line(NaN,NaN,'LineWidth',2,'LineStyle','-','Color', colors(i,:));
    hold on
end
steadyStateLine = line(NaN,NaN,'LineWidth',2,'LineStyle','-','Color', 'r');

for i = 1:length(cleanData(1).voltLevels)
    for j = 1:length(cleanData)
        plot(cleanData(j).plotTime, cleanData(j).TzCurrentEx(i,:) , 'lineWidth', 2, 'color', colors(j, :))
        hold on
        plot(cleanData(j).plotTime,  cleanData(j).TzPredictedEx(i,:), 'lineWidth', 2, 'color', 'r', 'linestyle', '--')
    end
end
legend([extractTags 'Command Torque'])
title(['Overlaid predicted torques (from measured current) for all conditions'])
xlabel('Time (ms)')
ylabel('Torque (mNm)')
set(gca, 'FontSize', 24)

fig(figNum) = figure('units','normalized','outerposition',[0 0 1 1]);
figNum = figNum + 1;
plot(cleanData(1).timeArray, cleanData(1).TzPredicted)
hold on
for i = 1:length(cleanData)
    plot(cleanData(i).timeArray, cleanData(i).TzZero, cleanData(i).timeArray, cleanData(i).TxZero, cleanData(i).timeArray, cleanData(i).TyZero, ...
        cleanData(i).timeArray, cleanData(i).TzZero + cleanData(i).TyZero + cleanData(j).TxZero)
end
legend({'Predicted Tz', 'Tz Meas', 'Tx Meas', 'Ty Meas', 'Tx + Ty + Tz Meas'})

if choice == 2 || choice == 3
    %% plot stats related to step-responses
    %% Rise TIme for measured torque
    fig(figNum) = figure('units','normalized','outerposition',[0 0 1 1]);
    figNum = figNum + 1;
    for j = 1:length(cleanData)
        plot(cleanData(j).torqueLevels(2:end), [cleanData(j).TzSR(2:end).RiseTime] , 'lineWidth', 2,  'marker', 'o')
        hold on
    end
    legend(extractTags)
    title(['Rise Time comparisons at different commanded torque levels'])
    xlabel('Commanded torque (mNm)')
    ylabel('Rise Time (10 - 90%) (ms)')
    set(gca, 'FontSize', 24)
    
    
    %% Peak torque (measured torque)
    fig(figNum) = figure('units','normalized','outerposition',[0 0 1 1]);
    figNum = figNum + 1;
    for j = 1:length(cleanData)
        plot(cleanData(j).torqueLevels(2:end), [cleanData(j).TzSR(2:end).Peak] , 'lineWidth', 2,  'marker', 'o')
        hold on
    end
    legend(extractTags, 'location', 'SouthEast')
    title(['Peak torque comparisons at different commanded torque levels'])
    xlabel('Commanded torque (mNm)')
    ylabel('Torque (mNm)')
    set(gca, 'FontSize', 24)
    
    
    %% Overshoot (measured torque)
    fig(figNum) = figure('units','normalized','outerposition',[0 0 1 1]);
    figNum = figNum + 1;
    for j = 1:length(cleanData)
        plot(cleanData(j).torqueLevels(2:end), [cleanData(j).TzSR(2:end).Overshoot] , 'lineWidth', 2,  'marker', 'o')
        hold on
    end
    legend(extractTags)
    title(['Overshoot percentage comparisons at different commanded torque levels'])
    xlabel('Commanded torque (mNm)')
    ylabel('Overshoot (%)')
    set(gca, 'FontSize', 24)
    
    
    %% Peak Time (measured torque)
    fig(figNum) = figure('units','normalized','outerposition',[0 0 1 1]);
    figNum = figNum + 1;
    for j = 1:length(cleanData)
        plot(cleanData(j).torqueLevels(2:end), [cleanData(j).TzSR(2:end).PeakTime] , 'lineWidth', 2,  'marker', 'o')
        hold on
    end
    legend(extractTags)
    title(['Peak Time comparisons at different commanded torque levels'])
    xlabel('Commanded torque (mNm)')
    ylabel('Peak Time (ms)')
    set(gca, 'FontSize', 24)
    
    %% Settling Time (measured torque)
    fig(figNum) = figure('units','normalized','outerposition',[0 0 1 1]);
    figNum = figNum + 1;
    for j = 1:length(cleanData)
        plot(cleanData(j).torqueLevels(2:end), [cleanData(j).TzSR(2:end).SettlingTime] , 'lineWidth', 2,  'marker', 'o')
        hold on
    end
    legend(extractTags)
    title(['Settling Time comparisons at different commanded torque levels'])
    xlabel('Commanded torque (mNm)')
    ylabel('Settling Time (10% SS Error) (ms)')
    set(gca, 'FontSize', 24)
    
    %% Rise Time (calculated torque from current measurements)
    fig(figNum) = figure('units','normalized','outerposition',[0 0 1 1]);
    figNum = figNum + 1;
    for j = 1:length(cleanData)
        plot(cleanData(j).torqueLevels(2:end), [cleanData(j).TzSRCurrent(2:end).RiseTime] , 'lineWidth', 2,  'marker', 'o')
        hold on
    end
    legend(extractTags, 'location', 'SouthEast')
    title(['Rise Time for commanded current comparisons at different commanded current levels'])
    xlabel('Commanded torque (mNm)')
    ylabel('Rise Time (10 - 90%) (ms)')
    set(gca, 'FontSize', 24)
    
    %% Settling Time (measured torque)
    fig(figNum) = figure('units','normalized','outerposition',[0 0 1 1]);
    figNum = figNum + 1;
    for j = 1:length(cleanData)
        plot(cleanData(j).torqueLevels(2:end), [cleanData(j).TzSRCurrent(2:end).SettlingTime] , 'lineWidth', 2,  'marker', 'o')
        hold on
    end
    legend(extractTags, 'location', 'North')
    title(['Settling Time for commanded current comparisons at different commanded current levels'])
    xlabel('Commanded torque (mNm)')
    ylabel('Settling Time (10% SS Error) (ms)')
    set(gca, 'FontSize', 24)
    % if ~isempty(steadyStateRegions)
    %     for i = 1:length(steadyStateTime(:,1))
    %         steadyStateArea = rectangle('position', [steadyStateTime(i, 1) currYlim(1) (steadyStateTime(i,2) - steadyStateTime(i,1)) ceil(currYlim(2))],...
    %             'FaceColor', [1 0 0 0.2], 'lineStyle', 'none');
    %     end
    % end
end

if choice == 3 || choice == 4
    for i = 1:length(cleanData)
        fig(figNum) = figure('units','normalized','outerposition',[0 0 1 1]);
        figNum = figNum + 1;
        plot(cleanData(i).G0)
        hold on
        plot(cleanData(i).G1)
        plot(cleanData(i).G2)
        plot(cleanData(i).G3)
        plot(cleanData(i).G4)
        plot(cleanData(i).G5)
        title(['Single plot strain gauge measurements for ' extractTags{i}])
        xlabel('Time (ms)')
        ylabel('V')
        
        fig(figNum) = figure('units','normalized','outerposition',[0 0 1 1]);
        figNum = figNum + 1;
        subplot(3,2,1)
        plot(cleanData(i).G0)
        title('G0 Measurements')
        xlabel('Time (ms)')
        ylabel('V')
        subplot(3,2,2)
        plot(cleanData(i).G1)
        title('G1 Measurements')
        xlabel('Time (ms)')
        ylabel('V')
        subplot(3,2,3)
        plot(cleanData(i).G2)
        title('G2 Measurements')
        xlabel('Time (ms)')
        ylabel('V')
        subplot(3,2,4)
        plot(cleanData(i).G3)
        title('G3 Measurements')
        xlabel('Time (ms)')
        ylabel('V')
        subplot(3,2,5)
        plot(cleanData(i).G4)
        title('G4 Measurements')
        xlabel('Time (ms)')
        ylabel('V')
        subplot(3,2,6)
        plot(cleanData(i).G5)
        title('G5 Measurements')
        xlabel('Time (ms)')
        ylabel('V')
        suptitle(['Separated strain gauge measurements for ' extractTags{i}])
    end
    
    %% plot instantaneous torque N ms after voltage command
    fig(figNum) = figure('units','normalized','outerposition',[0 0 1 1]);
    figNum = figNum + 1;
    hold on
    for i = 1:6
        n(i) = 2^i;
        subplot(3,2, i);
        for j = 1:length(cleanData)
            plot(cleanData(j).voltLevels, cleanData(j).TzEx(:,n(i)), 'linewidth', 2)
            hold on
        end
        set(gca,'linestyleorder',{'-',':','-.','--','*','+'})
        plot(cleanData(j).voltLevels, cleanData(j).TzPredictedEx(:,n(i)), 'linewidth', 2, 'linestyle', '--', 'color', 'k')
        set(gca, 'FontSize', 12)
        title(['t = ' num2str(n(i) * cleanData(j).sampleTime) 'ms'])
        xlabel('Command Voltage (V)')
        ylabel('Torque (mNm)')
    end
    suptitle(['Instantaneous torque measurements at various timepoints'])
    legend([extractTags 'Commanded Torque'], 'location', 'NorthWest')
end

% fig(figNum) = figure('units','normalized','outerposition',[0 0 1 1]);
% figNum = figNum + 1;
% for i = 1:length(cleanData)
%     plot(cleanData(i).posEx(end,:))
%     hold on
% end
% title('Position of motor for highest voltage command level')
% xlabel('Time (ms)')
% ylabel('Position (deg)')
% legend(extractTags)
%
% fig(figNum) = figure('units','normalized','outerposition',[0 0 1 1]);
% figNum = figNum + 1;
% for i = 1:length(cleanData)
%     subplot(2,1,i)
%     plot(60*cleanData(i).posEx(end,:), 'lineWidth', 2)
%     hold on
%     plot(cleanData(i).TzEx(end,:), 'lineWidth', 2)
%     title(['Torque plotted w/ overlaid position (NOT TO SCALE) of motor ' extractTags{i}])
%     xlabel('Time (ms)')
%     ylabel('Torque')
%     legend({'Position', 'Torque'})
% end


s = input('Write figures to disk (y/n)?: ', 's');

if strcmp(s, 'y')
    q = uigetdir([], 'Select save directory for figures');
    s = input('\nInput filename for saving: ', 's');
    fprintf('\n')
    saveDir = [q '\' s '.pdf'];
    for i = 1:figNum-1
        set(0, 'CurrentFigure', fig(i))
        fprintf('Writing plot %s / %s to disk.\n', num2str(i), num2str(figNum-1))
        export_fig(saveDir, '-pdf', '-append')
    end
    close all
else
    fprintf('Exiting without writing to disk.\n')
end
% ylim(currYlim);
% title('Overlaid torque curves')
% xlabel('Time (ms')
% ylabel('Torque (mNm)')
% set(gca, 'FontSize', 18)
% %% plot instantaneous torque N ms after voltage command
% fig(figNum) = figure('units','normalized','outerposition',[0 0 1 1]);
% hold on
% TzOffset = [];
% for i = [1 5 9 17 33]
%     plot(voltageArray, TzEx(:, i), 'lineWidth', 2)
% end
% plot(voltageArray, TzPredicted, 'lineWidth', 3, 'lineStyle', '--', 'Color', 'k')
% legend({'0ms', '8ms', '16ms',  '32ms', '64ms', 'Predicted'}, 'location', 'Northwest')
% title('Instantaneous torque measurements for different times post voltage command onset')
% xlabel('Voltage (V)')
% ylabel('Torque (mNm')
% set(gca, 'FontSize', 18)
% axis('tight')
% %% plot complete sequence torque
% fig(figNum) = figure('units','normalized','outerposition',[0 0 1 1]);
% subplot(2,1,1)
% plot(timeArray, TzZero, timeArray, TzPredicted, timeArray, TxZero, timeArray, TyZero, timeArray, TxZero + abs(TyZero) + abs(TzZero))
% title('All trials averaged torque measurements (w/ Tx, Ty, Tz)')
% xlabel('Time (ms)')
% ylabel('Torque (mNm')
% legend({'Measured Tz', 'Predicted Tz', 'Measured Tx', 'Measured Ty', 'Sum abs(Tx + Ty + Tz)'}, 'location', 'Northwest')
% set(gca, 'FontSize', 18)
% axis('tight')
%
% subplot(2,1,2)
% plot(timeArray, TzZero, timeArray, TzPredicted)
% title('All trials averaged torque measurements (Tz Only)')
% xlabel('Time (ms)')
% ylabel('Torque (mNm')
% legend({'Measured Tz', 'Predicted Tz'}, 'location', 'Northwest')
% set(gca, 'FontSize', 18)
% axis('tight')
%
% %% plot SS error
% fig(figNum) = figure('units','normalized','outerposition',[0 0 1 1]);
% subplot(2,1,1)
% plot(voltageArray(2:end), stats.SSerror, 'lineWidth', 2)
% title('Steady state error for voltages')
% xlabel('Voltage (V)')
% ylabel('Torque (mNm')
%
% subplot(2,1,2)
% plot(voltageArray(2:end), stats.SSerrorPerc, 'lineWidth', 2)
% title('Steady state error (fraction) for voltages')
% xlabel('Voltage (V)')
% ylabel('Torque (mNm')
%
% %% plot expected vs actual torque at SS
% figure('units', 'normalized', 'outerposition', [0 0 1 1])
% plot(TzPredicted, stats.SStorque, 'lineWidth', 2)
% xlabel('Command Torque')
% ylabel('Measured Torque')
% title('Steady-state Torque Average vs. Command Torque')
