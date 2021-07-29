%function ratKinematics(in, ratName, sessionDateTimeAndSaveTag, pngFlag, pngPath, failFlag)
function ratKinematics(varargin)
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

    %set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
    set(gcf, 'OuterPosition', [10, 10, 1290, 730]);
    hold('on');
    xlabel('Time (ms)');
    ylabel('Angle (degrees)');
    title(strcat("Knob Kinematics for ", ratName, " for Session ", sessionDateTimeAndSaveTag));
    line([minHoldTime minHoldTime], [-holdPosMax-1 holdPosMax+1], 'LineWidth', 4, 'Color',[1,0,0,.8]);
    line([0 minHoldTime], [-holdPosMax -holdPosMax], 'LineWidth', 4, 'Color', [.8, .6, 0, 0.4]);
    line([0 minHoldTime], [holdPosMax holdPosMax], 'LineWidth', 4, 'Color', [.8, .6, 0, 0.4], 'HandleVisibility', 'off');
    
    % pre-allocate variables
    touchStatus = cell(length(allTrials),1);
    touchStatusModified = cell(length(allTrials),1);
    kinematicsAligned = cell(length(allTrials),1);
    state = cell(length(allTrials),1);

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
%             catch
%                 kinematicsAligned{i} = allTrials(i).pos(firstTouch:end);
%             end
%         end

        %if (allTrials(i).flagFail == failFlag && failFlag ~= 0)allTrials(i).flagFail
        if failFlag == 255 % this allows plotting ALL fail flags if set to 255
            if (allTrials(i).flagFail == 0)
                plot(kinematicsAligned{i}, 'LineWidth', 2, 'Color', [0, 0, 0, 0.4]);
            else
                plot(kinematicsAligned{i}, 'LineWidth', 1, 'Color', [.5, 0, 0, 0.4]);
            end
        elseif failFlag >= 0 && failFlag < 255
            if (allTrials(i).flagFail == 0)
                plot(kinematicsAligned{i}, 'LineWidth', 2, 'Color', [0, 0, 0, 0.4]);
            elseif allTrials(i).flagFail == failFlag
                plot(kinematicsAligned{i}, 'LineWidth', 1, 'Color', [.5, 0, 0, 0.4]);
            end
        %elseif (allTrials(i).catchTrialFlag)
        %    plot(kinematicsAligned{i}, '--', 'Color', [0,0,0,0.4]);
        end    

        currentStartIndex = find(allTrials(i).motorCurrent ~= 0,1);

        try
            %line([currentStartIndex-firstTouch currentStartIndex-firstTouch], [-holdPosMax-2 holdPosMax+2], 'Color', 'blue');
        catch
        end
    end
    
    xticks = get(gca, 'XTickLabel'); % get axis labels
    set(gca, 'XTickLabel', cellstr(num2str(cellfun(@(x) prod([str2double(x) 2]),xticks)))); % scale labels by 2 to get milliseconds from the 2ms tics
    
    % fix nasty legend
    L(1) = plot(nan, nan, 'LineWidth', 4, 'Color',[1,0,0,.8]);
    L(2) = plot(nan, nan, 'LineWidth', 4, 'Color',[.8, .6, 0, 0.4]);
    L(3) = plot(nan, nan, 'LineWidth', 2, 'Color', [0, 0, 0, 0.4]);
    L(4) = plot(nan, nan, 'LineWidth', 1, 'Color', [.5, 0, 0, 0.4]);
    legend(L, {'End of Hold Period', 'Max Allowed Angle During Hold', 'Successful Kinematics', char(strcat("failFlag",string(failFlag), " Kinematics"))}); %, 'motorCurrentStart');
    if ~strcmp(pngFlag,'nopng')
        sessionTimeStamp = char(string(in.trials(1).dateTimeTag));
        fileName = char(strcat(ratName(1), "_kine_failFlag", string(failFlag),"_", sessionTimeStamp,".png"));
        fname = char(pngPath);
        saveas(f,fullfile(fname, fileName),'png')
        close(f)
    end
    
end
