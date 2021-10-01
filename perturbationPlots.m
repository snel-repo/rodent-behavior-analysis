%function ratKinematics(in, ratName, sessionDateTimeAndSaveTag, pngFlag, pngPath, failFlag)
function perturbationPlots(varargin)
    in = varargin{1};
    ratName = varargin{2};
    sessionDateTimeAndSaveTag = varargin{3};
    pngFlag = varargin{4};
    pngPath = varargin{5};
    %varargin{6} is an optional failFlag param that tells the function to plot
    %only the kinematics with that failFlag
    if (nargin == 6)
        failFlag = varargin{6};
    else
        failFlag = uint8(255); % default failure flag, display ALL failures along with successes
    end

    %-------------------------------------------------------------
    % CHANGE THIS TO YOUR PATH
    % or if you have snel/share permissions, just comment it out
    %pngPath = "/snel/home/jwang945/PNG_plots";
    %-------------------------------------------------------------

    %function plots the kinematics of all the trials in a session that have

    %variables to adjust if needed

    minHoldTimeMilliseconds = 100; % enter here in milliseconds
    minHoldTime = floor(minHoldTimeMilliseconds*0.5000)+2; % add two ticks for the Simulink model loop delay
    holdPosMax = 10; % enter max degrees allowed during turn

    %only use 1 for now to plot one session
    session = in(1);
    
    % get catch trial indexes
%     allFailFlags = double([in.trials.flagFail]);
    [flagStruct] = makeFlagCellArray(in);
    if flagStruct.flagsFound(1) == -1 % if catch trials were found
        allCatchIdx = flagStruct.flagCellArray{1};
%         allCatchVector = nan(1,length(allFailFlags));
%         allCatchVector(allCatchIdx) = -1;
%         allTrialFlags = [allFailFlags; allCatchVector]; % shows all flags, with catch trials marked in the second row
%     else
%         allTrialFlags = allFailFlags;
    end
    
    %now have session, want to get all the trials in session
    allTrials = session.trials;
    %so, first make figure and subplots

    if ~strcmp(pngFlag,'nopng')
        %f = figure('visible','off','Name',"HoldPosMax Analysis " + ratName + " " + sessionDateTimeAndSaveTag);
        f = figure('visible','off','Name',strcat("Knob Kinematics for ", ratName, " for Session ", sessionDateTimeAndSaveTag));
        if ~exist(pngPath,'dir')
            mkdir(pngPath)
            system(['chmod 1777 ', pngPath]) % give folder access to all users
        end
    elseif strcmp(pngFlag,'nopng')
        %f = figure('Name',"HoldPosMax Analysis " + ratName + " " + sessionDateTimeAndSaveTag);
        f = figure('Name', strcat("Knob Kinematics for ", ratName, " for Session ", sessionDateTimeAndSaveTag));
    end 
    
    
   

    
    % pre-allocate variables
    touchStatus = cell(length(allTrials),1);
    touchStatusModified = cell(length(allTrials),1);
    kinematicsAligned = cell(length(allTrials),1);
    state = cell(length(allTrials),1);
    trialTime = cell(length(allTrials),1);

    
    
    for i = 1:numel(allTrials)
        touchStatus{i} = allTrials(i).touchStatus;
        state{i} = allTrials(i).state;
        state3Start = find(state{i} == 3, 1);
        state3End = find(state{i} == 3, 1, 'last');
        touchStatusModified{i} = touchStatus{i}(state3Start:state3End);


        % align to first touch
        firstTouch = find(touchStatusModified{i}, 1) + state3Start - 1;
        lastTouchRelease = find(diff(touchStatusModified{i})-1,1,'last') + state3Start -1;
%         endOfHoldingPeriod = firstTouch + minHoldTime;

%         endXForKine = endOfHoldingPeriod + 400;
%         try
%             kinematicsAligned{i} = allTrials(i).pos(firstTouch:endXForKine);
%         catch
%             try
        kinematicsAligned{i} = allTrials(i).pos(firstTouch:lastTouchRelease);
        trialTime{i} = allTrials(i).trialData_time(firstTouch:lastTouchRelease) - allTrials(i).trialData_time(firstTouch);
%             catch
%                 kinematicsAligned{i} = allTrials(i).pos(firstTouch:end);
%             end
%         end
    end

    catchTrialIdxs = [allTrials.catchTrialFlag];
    
    nonCatchTrialIdxs = ~catchTrialIdxs;
    
    hitTrialIdxs = [allTrials.hitTrial];
    
    hitCatchTrialsIdxs = uint8(catchTrialIdxs) .* uint8(hitTrialIdxs);
    hitNonCatchTrialsIdxs = uint8(nonCatchTrialIdxs) .* uint8(hitTrialIdxs);
    
    HR_c = sum(hitCatchTrialsIdxs) / sum(catchTrialIdxs);
    HR_nc = sum(hitNonCatchTrialsIdxs) / sum(nonCatchTrialIdxs);
    
    %% plot data

    set(gcf, 'OuterPosition', [10, 10, 1290, 1290]);
    
    ax1 = subplot(2,1,1); hold('on');
    
    subplot(2,1,1); 
    
    for i = 1:numel(allTrials)
        %if (allTrials(i).flagFail == failFlag && failFlag ~= 0)allTrials(i).flagFail
        if ismember(i,allCatchIdx) % failFlag == 255 % this allows plotting ALL fail flags if set to 255
            if (allTrials(i).flagFail == 0)
                plot(trialTime{i}, kinematicsAligned{i}, 'LineWidth', 2, 'Color', [0, 0, 0, 0.4]);
            else
                plot(trialTime{i}, kinematicsAligned{i}, 'LineWidth', 1, 'Color', [.5, 0, 0, 0.4]);
            end
        end    
    end

    xlabel('Time (ms)');
    ylabel('Angle (degrees)');
    title(strcat("(Catch trials) Kinematics for ", ratName, " for Session ", sessionDateTimeAndSaveTag, " - HR: ", string(HR_c)));
    line([minHoldTime minHoldTime], [-holdPosMax-1 holdPosMax+1], 'LineWidth', 4, 'Color',[1,0,0,.8]);
    line([0 minHoldTime], [-holdPosMax -holdPosMax], 'LineWidth', 4, 'Color', [.8, .6, 0, 0.4]);
    line([0 minHoldTime], [holdPosMax holdPosMax], 'LineWidth', 4, 'Color', [.8, .6, 0, 0.4], 'HandleVisibility', 'off');

    % fix nasty legend
    L(1) = plot(nan, nan, 'LineWidth', 4, 'Color',[1,0,0,.8]);
    L(2) = plot(nan, nan, 'LineWidth', 4, 'Color',[.8, .6, 0, 0.4]);
    L(3) = plot(nan, nan, 'LineWidth', 2, 'Color', [0, 0, 0, 0.4]);
    L(4) = plot(nan, nan, 'LineWidth', 1, 'Color', [.5, 0, 0, 0.4]);
    legend(L, {'End of Hold Period', 'Max Allowed Angle During Hold', 'Successful Kinematics', char(strcat("failFlag",string(failFlag), " Kinematics"))}); %, 'motorCurrentStart');
       
    
    ax2 = subplot(2,1,2); hold('on');
    
    for i = 1:numel(allTrials)
        %if (allTrials(i).flagFail == failFlag && failFlag ~= 0)allTrials(i).flagFail
        if ~ismember(i,allCatchIdx) % failFlag == 255 % this allows plotting ALL fail flags if set to 255
            if (allTrials(i).flagFail == 0)
                plot(trialTime{i}, kinematicsAligned{i}, 'LineWidth', 2, 'Color', [0, 0, 0, 0.4]);
            else
                plot(trialTime{i}, kinematicsAligned{i}, 'LineWidth', 1, 'Color', [.5, 0, 0, 0.4]);
            end
        end    
    end
    
    xlabel('Time (ms)');
    ylabel('Angle (degrees)');
    title(strcat("(Non-catch trials) Kinematics for ", ratName, " for Session ", sessionDateTimeAndSaveTag, " - HR: ", string(HR_nc)));
    line([minHoldTime minHoldTime], [-holdPosMax-1 holdPosMax+1], 'LineWidth', 4, 'Color',[1,0,0,.8]);
    line([0 minHoldTime], [-holdPosMax -holdPosMax], 'LineWidth', 4, 'Color', [.8, .6, 0, 0.4]);
    line([0 minHoldTime], [holdPosMax holdPosMax], 'LineWidth', 4, 'Color', [.8, .6, 0, 0.4], 'HandleVisibility', 'off'); 

    % fix nasty legend
    L(1) = plot(nan, nan, 'LineWidth', 4, 'Color',[1,0,0,.8]);
    L(2) = plot(nan, nan, 'LineWidth', 4, 'Color',[.8, .6, 0, 0.4]);
    L(3) = plot(nan, nan, 'LineWidth', 2, 'Color', [0, 0, 0, 0.4]);
    L(4) = plot(nan, nan, 'LineWidth', 1, 'Color', [.5, 0, 0, 0.4]);
    legend(L, {'End of Hold Period', 'Max Allowed Angle During Hold', 'Successful Kinematics', char(strcat("failFlag",string(failFlag), " Kinematics"))}); %, 'motorCurrentStart');

    
    linkaxes([ax1,ax2],'xy')
    
%     xticks = get(gca, 'XTickLabel'); % get axis labels
%     set(gca, 'XTickLabel', cellstr(num2str(cellfun(@(x) prod([str2double(x) 2]),xticks)))); % scale labels by 2 to get milliseconds from the 2ms tics
%     
    
    if ~strcmp(pngFlag,'nopng')
        sessionTimeStamp = char(string(in.trials(1).dateTimeTag));
        fileName = char(strcat(ratName(1), "_kine_failFlag", string(failFlag),"_", sessionTimeStamp,".png"));
        fname = char(pngPath);
        saveas(f,fullfile(fname, fileName),'png')
        close(f)
    end
    
end