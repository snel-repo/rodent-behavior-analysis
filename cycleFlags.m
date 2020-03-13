function [allFailFlags]=cycleFlags(in,varargin)
% [allFailFlags]=cycleFlags(in)  OR
% [allFailFlags]=cycleFlags(in,trialFlag)
%
% cycleFlags: 1st arg is the 'in' struct from analyzeTaskData
%             2nd arg (optional) is the fail flag number you want to plot:
%               (-1 is catch trial, 0 is successful, 1-19 are failures.)


%%%%%%%%%%%%%%%   INITIALIZE KNOWNS   %%%%%%%%%%%%%%%
trialIndex = 1; % defaults to plotting data of the first trial
[flagStruct] = makeFlagCellArray(in);

%%%%%%%%%%%%%%% HANDLE INITIAL INPUTS %%%%%%%%%%%%%%%
if nargin>3
    error('Too many arguments.')
elseif nargin == 0
    error('You need to input the session data struct "in" as the 1st argument.')
elseif nargin==1
    disp('Plotting 1st trial data, by default.')
    trialFlag = 0; % default is to cycle through successful trials (flag #0)
elseif nargin==2
    trialFlag = varargin{1};
elseif nargin==3
    trialFlag = varargin{1};
    trialsIdxRange=findFlags(in,varargin{2});
    fprintf('Trials with flag #%g were found here:\n',trialFlag);
    disp(trialsIdxRange)
else
    error('unrecognized argument(s)')
end

flagCellArrayIndex = find(flagStruct.flagsFound==trialFlag,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% Start Event Structure %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

while 1
    
    %%%%%%%%%%%% GET ARRAY INDEX FOR SELECTED FLAG %%%%%%%%%%%%%%%
    if isempty(flagCellArrayIndex)
        error('No trials found with this flag #.')
    else
        indexOfTrialYouWantToView = flagStruct.flagCellArray{flagCellArrayIndex}(trialIndex); % grid indexing of the struct, arrow keys adjust
    end
    
    %%%%%%%%%%%%  GET FILTERED DATA  %%%%%%%%%%%%%%
    %%% get BOTH filter types for plotting
    temporaryTouchFlag = 0; % get exponential moving average touch
    [filtData, baseLine] = touchFiltVariableHandler(in,indexOfTrialYouWantToView,temporaryTouchFlag);
    temporaryTouchFlag = 1; % also get median filtered touch
    [filtData_med, ~] = touchFiltVariableHandler(in,indexOfTrialYouWantToView,temporaryTouchFlag);

    
    %%%%%%%%%%%%%%%% GET MINS AND MAXES FOR PLOTS %%%%%%%%%%%%%%%
    minyTouch = min(min([filtData baseLine])); % get maxes and mins for ploting limits
    maxyTouch = max(max([filtData baseLine]));
    rangeTouch = maxyTouch - minyTouch;
    minyKinematics = min(in.trials(indexOfTrialYouWantToView).pos);
    maxyKinematics = max(in.trials(indexOfTrialYouWantToView).pos);
    rangeKine = maxyKinematics-minyKinematics;
    
    %%%%%%%%%%%%%%%%%% CREATE FIGURE INSTANCE  %%%%%%%%%%%%%%%%%%%%%
    figCheck = get(groot,'CurrentFigure'); % check if figure exists
    if isempty(figCheck)
        fig = figure('units','normalized',... % create figure
            'position',[0.05 0.05 0.8 0.8],...
            'name','Cycle Through Flags with Up/Down, Trials with Left/Right',...
            'numbertitle','off',...
            'keypressfcn',@keypress);
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%% TOUCH STATUS %%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(5,1,2);
    plot(in.trials(indexOfTrialYouWantToView).touchStatus); ylim([0,1.1]); title('Touch Status, this trial')
    
    %%%%%%%%%%%%%%%%%%%%%% TOUCH PLOTS %%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(5,1,3);
    plot(filtData); hold on; plot(baseLine);
    plot(filtData_med,'color','k')
    if rangeTouch ~= 0
        ylim([minyTouch-(rangeTouch*0.1),maxyTouch+(rangeTouch*0.1)]);
    end
    title('Touch Capacitances with BaseLine')
    legend('Exp. Mov. Ave.','BaseLine','Median Filtered')
    
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
    
    waitforbuttonpress
end

    % subfunction for handling the keyboard inputs
    function [] = keypress(~,k) 
        switch k.Key
            case 'rightarrow'
                trialIndex = trialIndex +1;
                clf
            case 'leftarrow'
                trialIndex = trialIndex -1;
                clf
            case 'downarrow'
                trialIndex = 1;
                flagCellArrayIndex = flagCellArrayIndex -1;
                clf
            case 'uparrow'
                trialIndex = 1;
                flagCellArrayIndex = flagCellArrayIndex +1;
                clf
            otherwise
                disp('Press up/down arrows to cycle through flags')
                disp('Press L/R arrows to cycle through trials')
        end
    end
end