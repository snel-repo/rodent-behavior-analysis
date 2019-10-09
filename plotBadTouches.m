function plotBadTouches(in)
%keyboard

%%
badTouch = {};
anyTouch = {};
sessionTick = zeros(1, numel(in));

for isess = 1:numel(in)
    if isess == 1
        sessionTick(isess) = 1;
    else
        sessionTick(isess) = numel(badTouch{isess - 1}) + sessionTick(isess - 1);
    end
    
    oneSession = in(isess);
    allTrials = oneSession.trials;
    touchStatus = {};
    trialState = {};
    %keyboard
    for i = 1:numel(allTrials)
        touchStatus{i} = allTrials(i).touchStatus;
        trialState{i} = allTrials(i).state;
    end
    %keyboard
    %%
    badTouch{isess} = zeros(1, numel(trialState));
    anyTouch{isess} = false(1, numel(trialState));
    for x = 1:numel(trialState) %loops through each field, where each field is named 1,2,3,...
        tick = 1;
        %    badTouch = 0;
        if sum(touchStatus{x}) ~= 0
            anyTouch{isess}(x) = true;
        end
        
        while tick <= length(trialState{x}) %loops through each row in the field
            
            if tick > 1 && trialState{x}(tick) ~= 3 %if the object is not displayed
                if touchStatus{x}(tick) == 1 && touchStatus{x}(tick - 1) == 0 %if it is the final tick of a touch
                    badTouch{isess}(x) = badTouch{isess}(x) + 1;
                end
            end
            tick = tick + 1;
        end
        %plot(x,badTouch(x));
        %hold on;
    end

end

%%
all_badTouches = cat(2, badTouch{:});
all_anyTouches = cat(2, anyTouch{:});
x = 1:numel(all_badTouches);
keyboard
%%
figure
scatter(x(all_anyTouches), all_badTouches(all_anyTouches), 'g', 'filled')
hold on
scatter(x(~all_anyTouches), all_badTouches(~all_anyTouches), 'r', 'filled')
ylabel('Num of bad touches')
xticks(sessionTick);
xticklabels({'Sess 1', 'Sess 2', 'Sess 3'})
xlabel('Trials')
title('Bad touches across sessions')
set(gcf, 'Position', [50, 200, 1800, 600])


