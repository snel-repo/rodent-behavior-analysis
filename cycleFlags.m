function [allTrialFlags]=cycleFlags(in,varargin)
% [allFailFlags]=cycleFlags(in)  OR
% [allFailFlags]=cycleFlags(in,trialFlag)
%
% cycleFlags: 1st arg is the 'in' struct from analyzeTaskData
%             2nd arg (optional) is the fail flag number you want to plot:
%               (-1 is catch trial, 0 is successful, 1-19 are failures.)


%%%%%%%%%%%%%%%   INITIALIZE KNOWNS   %%%%%%%%%%%%%%%
trialIndex = 1; % defaults to plotting data of the first trial
[flagStruct] = makeFlagCellArray(in);
numberOfUniqueTrialFlagsInSession = length(flagStruct.flagsFound);

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

%%%%%%%%%%%%%%%%%% CREATE FIGURE INSTANCE  %%%%%%%%%%%%%%%%%%%%%
figName = 'Cycle Flags with Left/Right, Cycle Trials with Up/Down';
figCheck = findobj('Type','Figure','Name',figName); % check if figure exists

if ~isempty(figCheck)
    close(figCheck) % close if it exists, to create new one below
end

% create figure
fig = figure('units','normalized', ... % 'units','pixels','position',[100 100 1600 1000],...
    'outerposition',[0 0 1 1], ...
    'name',figName, ...
    'numbertitle','off', ...
    'keypressfcn',@keypress);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% Start Event Structure %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while 1
    
    %%%%%%%%%%%%% CHECK FOR OUT OF BOUND INDECES %%%%%%%%%%%%%%%%%    
    if flagCellArrayIndex < 1
        msg = msgbox("You are already viewing the first Trial Flag group.",'Error','error');
        pause(1); if exist('msg','var'); close(msg); end % display error message until user input, then delete msgbox
        flagCellArrayIndex = flagCellArrayIndex +1; continue
    elseif flagCellArrayIndex > numberOfUniqueTrialFlagsInSession
        msg = msgbox("You are already viewing the last Trial Flag group.",'Error','error');
        pause(1);  if exist('msg','var'); close(msg); end % display error message until user input, then delete msgbox
        flagCellArrayIndex = flagCellArrayIndex -1; continue
    elseif trialIndex < 1
        msg = msgbox("You are already viewing the first Trial.",'Error','error');
        pause(1);  if exist('msg','var'); close(msg); end % display error message until user input, then delete msgbox
        trialIndex = trialIndex +1;
    elseif trialIndex > length(flagStruct.flagCellArray{flagCellArrayIndex})
        msg = msgbox("You are already viewing the last Trial.",'Error','error');
        pause(1);  if exist('msg','var'); close(msg); end % display error message until user input, then delete msgbox
        trialIndex = trialIndex -1; continue
    end
    
    %%%%%%%%%%%% GET ARRAY INDEX FOR SELECTED FLAG %%%%%%%%%%%%%%%
    if isempty(flagCellArrayIndex)
        error('No trials found with this flag #.')
    else
        indexOfTrialYouWantToView = flagStruct.flagCellArray{flagCellArrayIndex}(trialIndex); % grid indexing of the struct, arrow keys adjust
    end
    
    %%%%%%%%%%%%  GET FILTERED DATA  %%%%%%%%%%%%%%
    %%% get BOTH filter types for plotting
    try
        temporaryTouchFlag = 0; % get exponential moving average touch
        [filtData, baseLine] = touchFiltVariableHandler(in,indexOfTrialYouWantToView,temporaryTouchFlag);
        temporaryTouchFlag = 1; % also get median filtered touch
        [filtData_med, ~] = touchFiltVariableHandler(in,indexOfTrialYouWantToView,temporaryTouchFlag);
        noTouchData = false;
    catch
        noTouchData = true;
    end
    
    %%%%%%%%%%%%%%%% GET MINS AND MAXES FOR PLOTS %%%%%%%%%%%%%%%
    %%% get maxes and mins for ploting limits
    if noTouchData
        forceRawNorm = sqrt( ... # get the norm of all forces
                in.trials(indexOfTrialYouWantToView).forceRawX.^2 + ...
                in.trials(indexOfTrialYouWantToView).forceRawY.^2 + ...
                in.trials(indexOfTrialYouWantToView).forceRawZ.^2 ...
                );
        minyForce = min(min([ ...
                            in.trials(indexOfTrialYouWantToView).forceRawX ...
                            in.trials(indexOfTrialYouWantToView).forceRawY ... 
                            in.trials(indexOfTrialYouWantToView).forceRawZ ...
                            forceRawNorm
                            ]));
        maxyForce = max(max([ ...
                            in.trials(indexOfTrialYouWantToView).forceRawX ...
                            in.trials(indexOfTrialYouWantToView).forceRawY ...
                            in.trials(indexOfTrialYouWantToView).forceRawZ ...
                            forceRawNorm
                            ]));
        rangeForce = maxyForce - minyForce;
    else
        minyTouch = min(min([filtData baseLine])); % get maxes and mins for ploting limits
        maxyTouch = max(max([filtData baseLine]));
        rangeTouch = maxyTouch - minyTouch;
    end
    minyKinematics = min(in.trials(indexOfTrialYouWantToView).pos);
    maxyKinematics = max(in.trials(indexOfTrialYouWantToView).pos);
    rangeKine = maxyKinematics-minyKinematics;    
    
    %%%%%%%%%%%%%%%%%%%%%% TOUCH STATUS %%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(5,1,2);
    plot(in.trials(indexOfTrialYouWantToView).touchStatus); ylim([0,1.1]); title('Touch Status, this trial')
    yticks([0,1])
    ylabel("Boolean State")
    
    %%%%%%%%%%%%%%%%%%%%%% TOUCH (or FORCE) PLOTS %%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(5,1,3);
    if noTouchData
        plot(in.trials(indexOfTrialYouWantToView).forceRawX); hold on;
        plot(in.trials(indexOfTrialYouWantToView).forceRawY);
        plot(in.trials(indexOfTrialYouWantToView).forceRawZ);    
        plot(forceRawNorm,'LineWidth', 1, 'Color', [0.5, 0.5, 0.5, 0.5]);
        if rangeForce~= 0
            ylim([minyForce-(rangeForce*0.1),maxyForce+(rangeForce*0.1)]);
        end
        title('Rat Interaction Cartesian Forces')
        leg = legend('L-R axis (X)','U-D axis (Y)','F-B axis (Z)','R^{3} Norm');
        set(leg,'location','northwest')
        ylabel('Force (mN)')
    else
        plot(filtData); hold on; plot(baseLine);
        plot(filtData_med,'color','k')
        if rangeTouch ~= 0
            ylim([minyTouch-(rangeTouch*0.1),maxyTouch+(rangeTouch*0.1)]);
        end
        title('Touch Capacitances with BaseLine')
        leg = legend('Exp. Mov. Ave.','BaseLine','Median Filtered');
        set(leg,'location','northwest')
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
    plot(in.trials(indexOfTrialYouWantToView).zeroVelFlag); % can remove this later if desired. It indicates velocity threshold crossings
    ylabel('State')
    % this is for plotting motor current
    currentStartIndex = find(in.trials(indexOfTrialYouWantToView).motorCurrent ~= 0,1);
    currentStopIndex = find(in.trials(indexOfTrialYouWantToView).motorCurrent(currentStartIndex : end) == 0,1) + currentStartIndex - 2;
    if ~isempty(currentStartIndex) && ~isempty(currentStopIndex) % make sure motor current is not empty (i.e. motor-free trial)
        % added this for motor current magnitude plotting
        yyaxis right; 
        plot(in.trials(indexOfTrialYouWantToView).motorCurrent, 'Color', 'magenta')
        try
            plot(in.trials(indexOfTrialYouWantToView).currentMeasEscon*1000,'LineWidth',2, 'LineStyle','-', 'Color', [.1, .8, .1, .9]) % scale measured current to match mA
            leg = legend('Trial State','Vel. Thresh. Cross','Motor Current Command','Measured Escon Current');
        catch
            leg = legend('Trial State','Vel. Thresh. Cross','Motor Current Command');
        end
        ylabel('Motor Current (mA)')
        set(gca,'ycolor','magenta'); ylim([0,max(in.trials(indexOfTrialYouWantToView).motorCurrent)*1.1]);
%         line([currentStartIndex currentStartIndex], [0 5],'Color','magenta');
%         line([currentStopIndex currentStopIndex], [0 5],'Color','magenta');
        set(leg,'location','northwest')
    else
        leg = legend('Trial State','Vel. Thresh. Cross');
        set(leg,'location','northwest')
    end
    
    %%%%%%%%%%%%%%%%%%%%%% KINEMATICS %%%%%%%%%%%%%%%%%%%%%%%%%
    subplot(5,1,5); plot(in.trials(indexOfTrialYouWantToView).pos);
    if rangeKine ~= 0 %trialFlag = 0;
        ylim([minyKinematics-(rangeKine*0.1),maxyKinematics+(rangeKine*0.1)]);
    end
    ylabel('Angle (Deg.)')
    xlabel('Time (2ms ticks)')
    yyaxis right; plot(in.trials(indexOfTrialYouWantToView).velRaw);
    try
        hold on; plot(in.trials(indexOfTrialYouWantToView).vel,'LineWidth',2,'LineStyle','-','Color',[0.80, 0.10, 0.040, 0.70]) % smoothed vel
        ylabel('Ang. Velocity (Deg./s)')
        leg = legend('Angle','Raw Angular Velocity', 'Smoothed Anglular Velocity');
    catch
         leg = legend('Postion (deg)','Velocity (deg/s)');
    end
    set(leg,'location','northwest')
    title('Knob Kinematics, this trial');
    
%     %%%%%%%%%%%%%%%%%%%%% FORCE %%%%%%%%%%%%%%%%%%%%%
%     subplot(5,1,6)
%     plot(in.trials(indexOfTrialYouWantToView).in.trials(indexOfTrialYouWantToView).forceRawX)
%     plot(in.trials(indexOfTrialYouWantToView).in.trials(indexOfTrialYouWantToView).forceRawY)
%     plot(in.trials(indexOfTrialYouWantToView).in.trials(indexOfTrialYouWantToView).forceRawZ)
    
    %%%%%%%%%%%%%%%%%%%% FAIL FLAG HISTOGRAMS %%%%%%%%%%%%%%%%%%%%%%
    subplot(5,1,1);
    allFailFlags = double([in.trials.flagFail]);
    currentFailFlag=allFailFlags(indexOfTrialYouWantToView);
    if flagStruct.flagsFound(1) == -1 % if catch trials were found
        allCatchIdx = flagStruct.flagCellArray{1};
        allCatchVector = nan(1,length(allFailFlags));
        allCatchVector(allCatchIdx) = -1;
        allTrialFlags = [allFailFlags; allCatchVector]; % shows all flags, with catch trials marked in the second row
    else
        allTrialFlags = allFailFlags;
    end
    H = histogram(allTrialFlags,[-1.5:1:19.5]); % define range of the histogram, includes -1 for catch trials
    xticks([-1:1:20])
    xlabel('Fail Flag #')
    ylabel('Trial Count')
    %     %%%%%%%%%%%%%%%%%%%%% FORCE %%%%%%%%%%%%%%%%%%%%%
%     subplot(5,1,6)
%     plot(in.trials(indexOfTrialYouWantToView).in.trials(indexOfTrialYouWantToView).forceRawX)
%     plot(in.trials(indexOfTrialYouWantToView).in.trials(indexOfTrialYouWantToView).forceRawY)
%     plot(in.trials(indexOfTrialYouWantToView).in.trials(indexOfTrialYouWantToView).forceRawZ)

    % highlight catch trial box, if this is a catch trial
    catchExist = logical(flagStruct.flagsFound(1) == -1);
    numTrialsThisFlag = length(flagStruct.flagCellArray{flagCellArrayIndex});
    if  catchExist && ismember(indexOfTrialYouWantToView,flagStruct.flagCellArray{1}) % if catch trials were found
        hilite = H.BinEdges(flagStruct.flagsFound(1)+2:flagStruct.flagsFound(1)+3);
        hilite = [hilite fliplr(hilite)];
        z = [0 0 repmat(H.Values(flagStruct.flagsFound(1)+2), 1, 2)];
        h_patch = patch(hilite, z, 'r', 'FaceAlpha', 0.5, 'LineStyle', ':', 'LineWidth', 1.5);
    end
    
    % highlight the fail flag that matches the current trial's category
    hilite = H.BinEdges(currentFailFlag+2:currentFailFlag+3); % offset (+2 and +3) adjusts indeces to align bin indeces with failFlag numbers)
    hilite = [hilite fliplr(hilite)];
    y = [0 0 repmat(H.Values(currentFailFlag+2), 1, 2)];
    h_patch = patch(hilite, y, 'green', 'FaceAlpha', 0.5, 'LineStyle', ':', 'LineWidth', 1.5);
    
    ratName = string(upper(in.trials(1).subject));
    % handle different titles, that flexibly change depending on user input
    if catchExist && ismember(indexOfTrialYouWantToView,flagStruct.flagCellArray{1}) && flagCellArrayIndex > 1 % checks if catch trials are present, and if we are trying to look at them
        title(strjoin([ratName ": Viewing Trial #" string(indexOfTrialYouWantToView) " [" string(trialIndex) "/" string(numTrialsThisFlag) "]" ", Viewing Flag Group: #" string(currentFailFlag) ", Catch Trial: YES"]))
    elseif catchExist && ismember(indexOfTrialYouWantToView,flagStruct.flagCellArray{1}) && flagCellArrayIndex == 1 % checks if catch trials are present, and if we are in the Catch Trial Flag Group
        title(strjoin([ratName ": Viewing Trial #" string(indexOfTrialYouWantToView) " [" string(trialIndex) "/" string(numTrialsThisFlag) "]" ", Viewing Flag Group: # -1, Catch Trial: YES"]))
    else
        title(strjoin([ratName ": Viewing Trial #" string(indexOfTrialYouWantToView) " [" string(trialIndex) "/" string(numTrialsThisFlag) "]" ", Viewing Flag Group: #" string(currentFailFlag) ", Catch Trial: NO"]))
    end
    
    try
        if get(fig, 'CurrentKey') ~= "escape"
            while true
                input = waitforbuttonpress; % get user input
                if input == 1 && any(strcmpi(get(fig, 'CurrentKey'),{'uparrow','downarrow','leftarrow','rightarrow','escape'})) % filter for arrow key presses and escape only
                    break
                end
            end
        end
    catch
        disp(strjoin(["Exiting current session for" ratName]))
        return
    end
end

    % subfunction for handling the keyboard inputs
    function [] = keypress(~,k) 
        switch k.Key
            case 'uparrow'
                trialIndex = trialIndex +1;
                clf
            case 'downarrow'
                trialIndex = trialIndex -1;
                clf
            case 'leftarrow'
                trialIndex = 1;
                flagCellArrayIndex = flagCellArrayIndex -1;
                clf
            case 'rightarrow'
                trialIndex = 1;
                flagCellArrayIndex = flagCellArrayIndex +1;
                clf
            case 'escape'
                close(fig)
            otherwise
        end
    end
end