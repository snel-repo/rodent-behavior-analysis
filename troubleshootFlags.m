function [allFailFlags]=troubleshootFlags(in,currentTrial,varargin)
% troubleshotFlags: 1st arg is the 'in' struct
%                   2nd arg is trial you want to look at
%                   3rd arg (optional) is filter type to be plotted (0=ex,1=med)

    allFailFlags = [in.trials.flagFail]; 
    currentFailFlag=allFailFlags(currentTrial) %intentionally displayed
    if nargin==2
        touchTypeFlag=0; % default will plot exponential moving average
    elseif nargin==3
        touchTypeFlag=varargin{1};
    else 
        error('Too many arguments.')
    end
    [filtData, baseLine] = touchFiltVariableHandler(in,currentTrial,touchTypeFlag);
    
    %%%%%%%%%%%%%%%% GET MINS AND MAXES FOR PLOTS %%%%%%%%%%%%%%%
    minyTouch = min(min([filtData baseLine])); % get maxes and mins for ploting limits
    maxyTouch = max(max([filtData baseLine]));
    rangeTouch = maxyTouch - minyTouch;
    minyKinematics = min(in.trials(currentTrial).pos);
    maxyKinematics = max(in.trials(currentTrial).pos);
    rangeKine = maxyKinematics-minyKinematics;
    
    %%%%%%%%%%%%%%%%%%%%%% TOUCH STATUS %%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(5,1,2);
    plot(in.trials(currentTrial).touchStatus); ylim([0,1.1]); title('Touch Status, this trial')
    
    %%%%%%%%%%%%%%%%%%%%%% TOUCH PLOTS %%%%%%%%%%%%%%%%%%%%%%%%%
    dThresh=10; difference = baseLine-filtData; % define threshold, get difference array
    subplot(5,1,3); 
    yyaxis left; plot(filtData); hold on; plot(baseLine);
    ylim([minyTouch-(rangeTouch*0.1),maxyTouch+(rangeTouch*0.1)]);
    yyaxis right; plot(difference); % difference bet. baseline and touchFilt
    plot(dThresh*ones(1,length(baseLine)),'LineStyle','--'); 
    title('Touch Capacitance w/ baseline (Blue) and Difference w/ threshold (Orange), this trial')
    legend('EMA','BaseLine','BL - EMA','Threshold');
    
    %%%%%%%%%%%%%%%%%%%%%% PLOT TRIAL STATE & MOTOR CURRENT %%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(5,1,4); plot(in.trials(currentTrial).state); ylim([0,6]) 
    title('Trial state (blue) and Motor Current (magenta), this trial'); hold('on');
    
    % this is for plotting motor current
    currentStartIndex = find(in.trials(currentTrial).motorCurrent ~= 0,1);
    currentStopIndex = find(in.trials(currentTrial).motorCurrent(currentStartIndex : end) == 0,1) + currentStartIndex - 2;
    if ~isempty(currentStartIndex) || ~isempty(currentStopIndex) % make sure not empty
        % added this for motor current magnitude plotting
        yyaxis right; plot(in.trials(currentTrial).motorCurrent, 'Color', 'magenta')
        set(gca,'ycolor','magenta')
        line([currentStartIndex currentStartIndex], [0 5],'Color','magenta');
        line([currentStopIndex currentStopIndex], [0 5],'Color','magenta');
    end
    
    %%%%%%%%%%%%%%%%%%%%%% KINEMATICS %%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(5,1,5); plot(in.trials(currentTrial).pos); 
    ylim([minyKinematics-(rangeKine*0.1),maxyKinematics+(rangeKine*0.1)]);
    title('Knob Position (blue) and Velocity (orange), this trial');
    yyaxis right; plot(in.trials(currentTrial).velRaw)
    legend('Postion (deg)','Velocity (deg/s)')
    
    %%%%%%%%%%%%%%%%%%%%%% HISTOGRAMS %%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(5,1,1);
    H = histogram(allFailFlags,[-0.5:1:19.5]); 
    title('All fail codes from entire session, current fail code group highlighted')
    uniqueFails = unique(allFailFlags); % get unique flags
    hilite = H.BinEdges(currentFailFlag+1:currentFailFlag+2);
    hilite = [hilite fliplr(hilite)];
    y = [0 0 repmat(H.Values(currentFailFlag+1), 1, 2)];
    h_patch = patch(hilite, y, 'green', 'FaceAlpha', 0.5, 'LineStyle', ':');
    keyboard
    
end