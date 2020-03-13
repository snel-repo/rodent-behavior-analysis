function [allFailFlags]=viewFlags(in,varargin)
% [allFailFlags]=viewFlags(in)  OR
% [allFailFlags]=viewFlags(in,indexOfTrialYouWantToView)  OR
% [allFailFlags]=viewFlags(in,indexOfTrialYouWantToView,trialFlag)  OR
% [allFailFlags]=viewFlags(in,indexOfTrialYouWantToView,trialFlag,touchTypeFlag)
%
% viewFlags: 1st arg is the 'in' struct from analyzeTaskData
%            2nd arg (optional) is trial number you want to look at
%            3rd arg (optional) is the fail flag number you want to plot:
%               (-1 is catch trial, 0 is successful, 1-19 are failures.)
%            4th arg (optional) is filter type to be plotted (0=ex,1=med, 2=both)
    
    %%%%%%%%%%%%%%% HANDLE INPUTS %%%%%%%%%%%%%%%
    if nargin>4 
        error('Too many arguments.')
    elseif nargin == 0
        error('You need to input the session data struct "in" as the 1st argument.')
    elseif nargin==1
        disp('Plotting 1st trial data, by default.')
        touchTypeFlag = 0; % default will plot exponential moving average
        indexOfTrialYouWantToView = 1;
    elseif nargin==2
        touchTypeFlag = 0; % default will plot exponential moving average
        indexOfTrialYouWantToView = varargin{1};
    elseif nargin==3
        touchTypeFlag = 0; % default will plot exponential moving average
        indexOfTrialYouWantToView = varargin{1};
        trialFlag = varargin{2};
        trialsIdxRange=findFlags(in,varargin{2});
        fprintf('Trials with flag #%g were found here:\n',trialFlag);
        disp(trialsIdxRange)
    elseif nargin==4
        indexOfTrialYouWantToView = varargin{1};
        trialFlag = varargin{2};
        touchTypeFlag=varargin{3};
        trialsIdxRange=findFlags(in,varargin{2});
        fprintf('Trials with flag #%g were found here:\n',trialFlag);
        disp(trialsIdxRange)
    else
        error('unrecognized argument(s)')
    end
    
    if touchTypeFlag == 2 % get BOTH filter types for plotting
        temporaryTouchFlag = 0; % get exponential moving average touch
        [filtData, baseLine] = touchFiltVariableHandler(in,indexOfTrialYouWantToView,temporaryTouchFlag);
        temporaryTouchFlag = 1; % also get median filtered touch
        [filtData_med, ~] = touchFiltVariableHandler(in,indexOfTrialYouWantToView,temporaryTouchFlag);
    elseif touchTypeFlag == 0 || touchTypeFlag == 1
        [filtData, baseLine] = touchFiltVariableHandler(in,indexOfTrialYouWantToView,touchTypeFlag);
    end 
    
    %%%%%%%%%%%%%%%% GET MINS AND MAXES FOR PLOTS %%%%%%%%%%%%%%%
    minyTouch = min(min([filtData baseLine])); % get maxes and mins for ploting limits
    maxyTouch = max(max([filtData baseLine]));
    rangeTouch = maxyTouch - minyTouch;
    minyKinematics = min(in.trials(indexOfTrialYouWantToView).pos);
    maxyKinematics = max(in.trials(indexOfTrialYouWantToView).pos);
    rangeKine = maxyKinematics-minyKinematics;
    

    figure('units','normalized',...
        'position',[0.05 0.05 0.8 0.8]);
    
    %%%%%%%%%%%%%%%%%%%%%% TOUCH STATUS %%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(5,1,2);
    plot(in.trials(indexOfTrialYouWantToView).touchStatus); ylim([0,1.1]); title('Touch Status, this trial')
    
    %%%%%%%%%%%%%%%%%%%%%% TOUCH PLOTS %%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(5,1,3);
    plot(filtData); hold on; plot(baseLine);
    if rangeTouch ~= 0
    ylim([minyTouch-(rangeTouch*0.1),maxyTouch+(rangeTouch*0.1)]);
    end
    legend('Filtered Touch','BaseLine'); title('Touch Capacitances with BaseLine')
    
    if touchTypeFlag == 2
        plot(filtData_med,'color','k')
        legend('Exp. Mov. Ave.','BaseLine','Median Filtered')
    end
    
    %%% Use below code if you want to plot the difference (BL - touchFilt)
    %dThresh=10; difference = baseLine-filtData; % define threshold, get difference array
    %yyaxis right; plot(difference); % difference bet. baseline and touchFilt
    %plot(dThresh*ones(1,length(baseLine)),'LineStyle','--'); 
    %title('Touch Capacitance w/ baseline (Blue) and Difference w/ threshold (Orange), this trial')
    %legend('EMA','BaseLine','BL - EMA','Threshold');
    
    %%%%%%%%%%%%%%%%%%%%%% PLOT TRIAL STATE & MOTOR CURRENT %%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(5,1,4); plot(in.trials(indexOfTrialYouWantToView).state); ylim([0,max(in.trials(indexOfTrialYouWantToView).state)+1]) 
    title('Trial structure for this trial'); hold('on');
    
    % this is for plotting motor current
    currentStartIndex = find(in.trials(indexOfTrialYouWantToView).motorCurrent ~= 0,1);
    currentStopIndex = find(in.trials(indexOfTrialYouWantToView).motorCurrent(currentStartIndex : end) == 0,1) + currentStartIndex - 2;
    if ~isempty(currentStartIndex) || ~isempty(currentStopIndex) % make sure not empty
        % added this for motor current magnitude plotting
        yyaxis right; plot(in.trials(indexOfTrialYouWantToView).motorCurrent, 'Color', 'magenta')
        set(gca,'ycolor','magenta'); ylim([0,max(in.trials(indexOfTrialYouWantToView).motorCurrent)*1.1]);
        line([currentStartIndex currentStartIndex], [0 5],'Color','magenta');
        line([currentStopIndex currentStopIndex], [0 5],'Color','magenta');
        legend('Trial State','Motor Current (mA)')
    else
        legend('Trial State')
    end
    
    %%%%%%%%%%%%%%%%%%%%%% KINEMATICS %%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(5,1,5); plot(in.trials(indexOfTrialYouWantToView).pos);
    if rangeKine ~= 0
    ylim([minyKinematics-(rangeKine*0.1),maxyKinematics+(rangeKine*0.1)]);
    end
    title('Knob Kinematics, this trial');
    yyaxis right; plot(in.trials(indexOfTrialYouWantToView).velRaw)
    legend('Postion (deg)','Velocity (deg/s)')
    
    %%%%%%%%%%%%%%%%%%%% FAIL FLAG HISTOGRAMS %%%%%%%%%%%%%%%%%%%%%%
    subplot(5,1,1);
    allFailFlags = [in.trials.flagFail]; 
    currentFailFlag=allFailFlags(indexOfTrialYouWantToView) %intentionally displayed
    H = histogram(allFailFlags,[-0.5:1:19.5]); 
    title('All fail codes from entire session, current fail code group highlighted')
    uniqueFails = unique(allFailFlags); % get unique flags
    hilite = H.BinEdges(currentFailFlag+1:currentFailFlag+2);
    hilite = [hilite fliplr(hilite)];
    y = [0 0 repmat(H.Values(currentFailFlag+1), 1, 2)];
    h_patch = patch(hilite, y, 'green', 'FaceAlpha', 0.5, 'LineStyle', ':');
    
end