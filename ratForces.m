%function ratForces(in, ratName, sessionDateTimeAndSaveTag, pngFlag, pngPath, failFlag)
function ratForces(varargin)
    in = varargin{1};
    ratName = varargin{2};
    sessionDateTimeAndSaveTag = varargin{3};
    pngFlag = varargin{4};
    pngPath = varargin{5};
    %varargin{6} is an optional failFlag param that tells the function to plot
    %only the forces with that failFlag
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

    %function plots the forces of all the trials in a session that have

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
        f = figure('visible','off','DisplayName',strcat("Knob Forces for ", ratName, " for Session ", sessionDateTimeAndSaveTag));
        plot3(nan,nan,nan); % initialize 3d
        if ~exist(pngPath,'dir')
            mkdir(pngPath)
            system(['chmod 1777 ', pngPath]) % give folder access to all users
        end
    elseif strcmp(pngFlag,'nopng')
        %f = figure('Name',"HoldPosMax Analysis " + ratName + " " + sessionDateTimeAndSaveTag);
        f = figure('Name', strcat("Knob Forces for ", ratName, " for Session ", sessionDateTimeAndSaveTag));
        plot3(nan,nan,nan); % initialize 3d
    end
    
    set(gcf, 'OuterPosition', [10, 10, 1090, 1090]);
    hold on; axis equal; grid on
    xlabel('Right-Left Axis');
    ylabel('Forward-Backward Axis');
    zlabel('Up-Down Axis');
    
    title(strcat("Knob Forces for ", ratName, " for Session ", sessionDateTimeAndSaveTag));
%     line([minHoldTime minHoldTime], [-holdPosMax-1 holdPosMax+1], 'LineWidth', 4, 'Color',[1,0,0,.8]);
%     line([0 minHoldTime], [-holdPosMax -holdPosMax], 'LineWidth', 4, 'Color', [.8, .6, 0, 0.4]);
%     line([0 minHoldTime], [holdPosMax holdPosMax], 'LineWidth', 4, 'Color', [.8, .6, 0, 0.4], 'HandleVisibility', 'off');
    
    % pre-allocate variables
    touchStatus = cell(length(allTrials),1);
    touchStatusModified = cell(length(allTrials),1);
    forceAlignedX = cell(length(allTrials),1);
    forceAlignedZ = cell(length(allTrials),1);
    forceAlignedY = cell(length(allTrials),1);
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

%         endXForForce = endOfHoldingPeriod + 400;
%         try
%             forcesAligned{i} = allTrials(i).pos(firstTouch:endXForForce);
%         catch
%             try
        forceAlignedX{i} = allTrials(i).forceRawX(firstTouch:lastTouchRelease);
        forceAlignedZ{i} = allTrials(i).forceRawZ(firstTouch:lastTouchRelease);
        forceAlignedY{i} = -allTrials(i).forceRawY(firstTouch:lastTouchRelease);
%             catch
%                 forcesAligned{i} = allTrials(i).pos(firstTouch:end);
%             end
%         end

        %if (allTrials(i).flagFail == failFlag && failFlag ~= 0)allTrials(i).flagFail
        if failFlag == 255 % this allows plotting ALL fail flags if set to 255
            if (allTrials(i).flagFail == 0)
                plot3(forceAlignedX{i},forceAlignedZ{i},forceAlignedY{i}, 'LineWidth', 2, 'Color', [0, 0, 0, 0.4]);
            else
                plot3(forceAlignedX{i},forceAlignedZ{i},forceAlignedY{i}, 'LineWidth', 1, 'Color', [.5, 0, 0, 0.4]);
            end
        elseif failFlag >= 0 && failFlag < 255
            if (allTrials(i).flagFail == 0)
                plot3(forceAlignedX{i},forceAlignedZ{i},forceAlignedY{i}, 'LineWidth', 2, 'Color', [0, 0, 0, 0.4]);
            elseif allTrials(i).flagFail == failFlag
                plot3(forceAlignedX{i},forceAlignedZ{i},forceAlignedY{i}, 'LineWidth', 1, 'Color', [.5, 0, 0, 0.4]);
            end
        %elseif (allTrials(i).catchTrialFlag)
        %    plot(forcesAligned{i}, '--', 'Color', [0,0,0,0.4]);
        end    

%         currentStartIndex = find(allTrials(i).motorCurrent ~= 0,1);

        try
%             line([currentStartIndex-firstTouch currentStartIndex-firstTouch], [-holdPosMax-2 holdPosMax+2], 'Color', 'blue');
        catch
        end
    end
    
%     xticks = get(gca, 'XTickLabel'); % get axis labels
%     set(gca, 'XTickLabel', cellstr(num2str(cellfun(@(x) prod([str2double(x) 2]),xticks)))); % scale labels by 2 to get milliseconds from the 2ms tics
    
    % fix nasty legend
    L(1) = plot3(nan, nan, nan, 'LineWidth', 2, 'Color', [0, 0, 0, 0.4]);
    L(2) = plot3(nan, nan, nan, 'LineWidth', 1, 'Color', [.5, 0, 0, 0.4]);
    legend(L, {'Successful Forces', char(strcat("failFlag",string(failFlag), " Forces"))}); %, 'motorCurrentStart');
    if ~strcmp(pngFlag,'nopng')
        sessionTimeStamp = char(string(in.trials(1).dateTimeTag));
        fileName = char(strcat(ratName(1), "_force_failFlag", string(failFlag),"_", sessionTimeStamp,".png"));
        fname = char(pngPath);
        saveas(f,fullfile(fname, fileName),'png')
        close(f)
    end
    
end
