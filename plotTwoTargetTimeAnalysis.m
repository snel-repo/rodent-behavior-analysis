function plotTwoTargetTimeAnalysis(in)
%enable pause function
pause on;
pauseTime = 0.002;
%only use for now to plot one session
session = in(1);
%now have session, want to get all the trials in session
allTrials = session.trials;

%first find how many ticks is holding criteria (currently 60ms)
timeHoldMin = 30; %this is hard coded, change later
%timeHoldMin = allTrials(1).timeHoldMin;
%find theta target
thetaTarget = double(allTrials(1).thetaTarget); %can use the first one because it is he same for all trials, casted as double b/c need negative, is a uint16 which has no neg
%find holdPosMax
holdPosMax = 1; %hard coded, change to below line later
%holdPosMax = double(allTrials(1).holdPosMax);

%want to plot five subplots for the five possible cases:
% 1. The rat touches and releases less than 60ms (before the target shows up)

% 2. The rat touches and holds longer than 60ms (after the target shows up) but doesn't turn

% 3. The rat holds for 60ms then turns too small <thetaTarget (3 degrees)and lets
%    go

% 4. THe rat touches and turns before the target shows up (60ms)

% 5. The rat holds, then the target shows up, then turns enough (success!)
%so, first make figure and subplots and animated lines
figure('Name','TwoTargetTimeAnalysis');
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
ax1 = subplot(5,1,1);
ax2 = subplot(5,1,2);
ax3 = subplot(5,1,3);
ax4 = subplot(5,1,4);
ax5 = subplot(5,1,5);
an1 = animatedline(ax1);
an2 = animatedline(ax2);
an3 = animatedline(ax3);
an4 = animatedline(ax4);
an5 = animatedline(ax5, 'Color', [0.4660 0.6740 0.1880]);
%add a title
title(ax1,'Case 1: Touch and Release before timeHoldMin');
title(ax2,'Case 2: Touch and Release after timeHoldMin but No Turn');
title(ax3,'Case 3: Touch and Release after timeHoldMin but Turn Too Small');
title(ax4,'Case 4: Touch and Turn before timeHoldMin');
title(ax5,'Case 5: Touch, Hold, Then Turn (Success Case)');
%add xlabel
xlabel(ax1,'Ticks');
xlabel(ax2,'Ticks');
xlabel(ax3,'Ticks');
xlabel(ax4,'Ticks');
xlabel(ax5,'Ticks');
%add ylabel
ylabel(ax1,'Pos');
ylabel(ax2,'Pos');
ylabel(ax3,'Pos');
ylabel(ax4,'Pos');
ylabel(ax5,'Pos');
%link the axes
linkaxes([ax1 ax2 ax3 ax4 ax5], 'xy');

%draw lines for the holdPosMax, which is the bounds for what's counsidered
%a hold

xLim = timeHoldMin * 10;
%set xLim and yLim for all plots
yLim = thetaTarget + 3;
xlim(ax1,[0 xLim]);
xlim(ax2,[0 xLim]);
xlim(ax3,[0 xLim]);
xlim(ax4,[0 xLim]);
xlim(ax5,[0 xLim]);
ylim(ax1,[-yLim yLim]);
ylim(ax2,[-yLim yLim]);
ylim(ax3,[-yLim yLim]);
ylim(ax4,[-yLim yLim]);
ylim(ax5,[-yLim yLim]);

%create video
%myVideo = VideoWriter(convertStringsToChars(allTrials(1).subject(1) + "_" + date + "_" + allTrials(1).saveTag + ".mp4")); %open video file
%myVideo.FrameRate = 0.002;  %can adjust this, 5 - 10 works well for me
%open(myVideo)

% draw holdPosMax lines
line(ax1,[0 xLim],[holdPosMax holdPosMax],'LineStyle','--','Color','blue');

line(ax1,[0 xLim],[-holdPosMax -holdPosMax],'LineStyle','--','Color','blue');

line(ax2,[0 xLim],[holdPosMax holdPosMax],'LineStyle','--','Color','blue');
hold(ax2, 'on');
line(ax2,[0 xLim],[-holdPosMax -holdPosMax],'LineStyle','--','Color','blue');

line(ax3,[0 xLim],[holdPosMax holdPosMax],'LineStyle','--','Color','blue');
hold(ax3, 'on');
line(ax3,[0 xLim],[-holdPosMax -holdPosMax],'LineStyle','--','Color','blue');

line(ax4,[0 xLim],[holdPosMax holdPosMax],'LineStyle','--','Color','blue');
hold(ax4, 'on');
line(ax4,[0 xLim],[-holdPosMax -holdPosMax],'LineStyle','--','Color','blue');

line(ax5,[0 xLim],[holdPosMax holdPosMax],'LineStyle','--','Color','blue');
hold(ax5, 'on');
line(ax5,[0 xLim],[-holdPosMax -holdPosMax],'LineStyle','--','Color','blue');

%draw thetaTargetLines
line(ax1,[0 xLim],[thetaTarget thetaTarget],'LineStyle','--','Color','red');
line(ax1,[0 xLim],[-thetaTarget -thetaTarget],'LineStyle','--','Color','red');

line(ax2,[0 xLim],[thetaTarget thetaTarget],'LineStyle','--','Color','red');
line(ax2,[0 xLim],[-thetaTarget -thetaTarget],'LineStyle','--','Color','red');

line(ax3,[0 xLim],[thetaTarget thetaTarget],'LineStyle','--','Color','red');
line(ax3,[0 xLim],[-thetaTarget -thetaTarget],'LineStyle','--','Color','red');

line(ax4,[0 xLim],[thetaTarget thetaTarget],'LineStyle','--','Color','red');
line(ax4,[0 xLim],[-thetaTarget -thetaTarget],'LineStyle','--','Color','red');

line(ax5,[0 xLim],[thetaTarget thetaTarget],'LineStyle','--','Color','red');
line(ax5,[0 xLim],[-thetaTarget -thetaTarget],'LineStyle','--','Color','red');

%draw vertical timeHoldMin line
line(ax1,[timeHoldMin timeHoldMin], [-yLim yLim],'Color','black');
line(ax2,[timeHoldMin timeHoldMin], [-yLim yLim],'Color','black');
line(ax3,[timeHoldMin timeHoldMin], [-yLim yLim],'Color','black');
line(ax4,[timeHoldMin timeHoldMin], [-yLim yLim],'Color','black');
line(ax5,[timeHoldMin timeHoldMin], [-yLim yLim],'Color','black');

%next want to align all the trials to the initial touch
%first make a cell that holds knobPosition for each trial
knobPos = {};
touchStatus = {};
formattedTouchStatus = {};
state = {};
%make a for-loop to access each trial
for i = 1:numel(allTrials)
    %for each trial want to get the knobPos and put into cell array
    knobPos{i} = allTrials(i).pos;
    touchStatus{i} = allTrials(i).touchStatus;
    state{i} = allTrials(i).state;
    %for each trial want to find where the first touch is so,
    %first find when state is 3
    entersState3Index = find(state{i} == 3, 1, 'first');
    %format touchStatus vector to be from beginning of state 3 to end
    formattedTouchStatus{i} = touchStatus{i}(entersState3Index : end);
    %now find where formmatedtouchStatus is first 1, that is where you want to align
    %pos
    firstTouchIndex = find(formattedTouchStatus{i} == 1, 1, 'first') + entersState3Index - 1; %add enterState3Index b/c index for formattedTouch gets reset to 0 when actual index is not that
    %format touch status to start at touch
    formattedTouchStatus{i} = touchStatus{i}(firstTouchIndex : end);
    %now find where it releases after it first touches
    endTouchIndex = find(formattedTouchStatus{i} == 0, 1, 'first') + firstTouchIndex - 2;
    %now use firstTouchIndex and endTouchIndex to format pos vector
    knobPos{i} = knobPos{i}(firstTouchIndex : endTouchIndex);
end
%create a frame counter
fcount = 1;
%now have knobPos aligned to initial touch and the pos ends after the rat lets go!
for i = 1:numel(knobPos)
    %keyboard
    if numel(knobPos{i}) < timeHoldMin && all(knobPos{i} < holdPosMax & knobPos{i} > -holdPosMax)
        %CASE 1
        for x = 1:numel(knobPos{i})
            addpoints(an1,x,knobPos{i}(x));
            drawnow limitrate
            pause(pauseTime);
            %frame(fcount) = getframe(gcf); %get frame
            %fcount = fcount+1;
        end
    else
        %CASE 2,3,4, or 5
        if numel(knobPos{i}) < timeHoldMin && all(knobPos{i} < holdPosMax & knobPos{i} > -holdPosMax)
            %CASE 2
            for x = 1:numel(knobPos{i})
                addpoints(an2,x,knobPos{i}(x));
                drawnow limitrate
                pause(pauseTime);
                %frame(fcount) = getframe(gcf); %get frame
                %fcount = fcount+1;
            end
        else
            %CASE 3,4, or 5
            %error is that vector is less than timeHoldMin but exceeds
            %holdPosMax so it enters else statement, so use case4EndInd to
            %check to make sure if this happens, we dont go out of bounds
            %and instead to the end of the vector
            case4EndInd = timeHoldMin - 1;
            if numel(knobPos{i}) < timeHoldMin
                case4EndInd = numel(knobPos{i});
            end
            if any(knobPos{i}(1:case4EndInd) > holdPosMax | knobPos{i}(1:case4EndInd) < -holdPosMax)
                %CASE 4
                for x = 1:numel(knobPos{i})
                    addpoints(an4,x,knobPos{i}(x));
                    drawnow limitrate
                    pause(pauseTime);
                    %frame(fcount) = getframe(gcf); %get frame
                    %fcount = fcount+1;
                end
            else
                %CASE 3 or 5
                if all(knobPos{i} < holdPosMax & knobPos{i} > -holdPosMax)
                    %CASE 3
                    for x = 1:numel(knobPos{i})
                        addpoints(an3,x,knobPos{i}(x));
                        drawnow limitrate
                        pause(pauseTime);
                        %frame(fcount) = getframe(gcf); %get frame
                        %fcount = fcount+1;
                    end
                else
                    %CASE 5
                    for x = 1:numel(knobPos{i})
                        %current issue is when end of first line on plot,
                        %the last point is connectted to the firstt point
                        %of the next animated line, may need multiple
                        %animated lines.
                        addpoints(an5,x,knobPos{i}(x));
                        drawnow limitrate
                        pause(pauseTime);
                        %frame(fcount) = getframe(gcf); %get frame
                        %fcount = fcount+1;
                    end
                end
            end
        end
    end
end
display('done')
%writeVideo(myVideo,frame);
%close(myVideo) 
end