function plotBadGoodTouches(in)
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
    goodTouch{isess} = zeros(1, numel(trialState));
    anyTouch{isess} = false(1, numel(trialState));
    isGoodTouch{isess} = false(1, numel(trialState));
    goodTouchTime{isess} = NaN(1, numel(trialState));
    for x = 1:numel(trialState) %loops through each field, where each field is named 1,2,3,...
        tick = 1;
        %    badTouch = 0;
        if sum(touchStatus{x}) ~= 0
            anyTouch{isess}(x) = true;
        end}
        
        while tick <= length(trialState{x}) %loops through each row in the field
            if tick > 1 && trialState{x}(tick) ~= 3 %if the object is not displayed
                if touchStatus{x}(tick) == 1 && touchStatus{x}(tick - 1) == 0 %if it is the final tick of a touch
                    badTouch{isess}(x) = badTouch{isess}(x) + 1;
                end
            elseif trialState{x}(tick) == 3
                if touchStatus{x}(tick) == 1 && touchStatus{x}(tick - 1) == 0
                    goodTouch{isess}(x) = goodTouch{isess}(x) + 1;
                    tmp = find(trialState{x} == 3);
                    goodTouchTime{isess}(x) = tick - tmp(1);
                    isGoodTouch{isess}(x) = true;
                end
            end
            tick = tick + 1;
        end
        %plot(x,badTouch(x));
        %hold on;
    end

end

keyboard

%% plot session summary
figure
baseX = [1,2,3];
g = cell(3,1);
g{1} = 'Good Touches';
g{2} = 'Bad Touches';
g{3} = 'No Touch';


%c = linspace(1,10,length(baseX));
c = [0,1,0;1,0,0;0,0,0];
for i = 1:numel(badTouch)
    bad = sum(badTouch{i});
    good = sum(goodTouch{i});
    noTouch = sum(~anyTouch{i});
    sz = 100;
    %scatter((5*(i-1)+baseX), [bad,good,noTouch], sz, c, 's');
    gscatter((5*(i-1)+baseX), [good,bad,noTouch], g, 'grk', 's', 10);
    if i == 1
        legend('Location','northwestoutside')
    end
    
    hold on
end
ylabel('Num of Touches')
xticks(((1:numel(badTouch))-1)*5 + 2);
xticklabels({'Sess 1', 'Sess 2', 'Sess 3', 'Sess 4'})
%%



keyboard
%%
all_badTouches = cat(2, badTouch{:});
all_anyTouches = cat(2, anyTouch{:});
x = 1:numel(all_badTouches);

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

%%
all_goodTimes = cat(2, goodTouchTime{:});
all_isGoodTouch = cat(2, isGoodTouch{:});
x = 1:numel(all_isGoodTouch);
%%
zeroX = zeros(1, numel(x));
figure
scatter(x(all_isGoodTouch), 2*all_goodTimes(all_isGoodTouch), 'b', 'filled')
hold on
ylabel('Reaction Time for Touching (ms)')
scatter(x(~all_isGoodTouch), zeroX(~all_isGoodTouch), 'r', 'filled')
xticks(sessionTick);
xticklabels({'Sess 1', 'Sess 2', 'Sess 3'})
xlabel('Trials')
%title('Reaction Time for Touching across sessions')
set(gcf, 'Position', [50, 200, 1800, 600])

