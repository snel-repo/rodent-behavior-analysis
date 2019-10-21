function plotDistribution(in)

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
        end
        
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

%%
figure
edges = 0:500:10000;
for iSess = 1: numel(in)
    subplot(numel(in), 1, iSess)
    histogram(2*goodTouchTime{iSess}/1000, edges/1000);
    xlim([0 10])
    ylim([0 80])

    % get session name
    sessionName = [int2str(in(iSess).trials(1).date) '-' int2str(in(iSess).trials(1).saveTag)]; 
    
    title(['Session ' sessionName])
end
xlabel('Reaction time (s)')
suptitle(['Reaction Time Distribution'])
set(gcf, 'Position', [680 4 598 962])

%%
figure
edges = -1:1:10;
for iSess = 1: numel(in)
    subplot(numel(in), 1, iSess)
    badTouch_thisSess = badTouch{iSess}(anyTouch{iSess});
    %histogram(badTouch_thisSess);
    histogram(badTouch_thisSess, edges);
    xlim([-1 10])
    ylim([0 70])
    sessionName = [int2str(in(iSess).trials(1).date) '-' int2str(in(iSess).trials(1).saveTag)]; 
    
    title(['Session ' sessionName])
end
xlabel('Num of bad touches')
suptitle(['Bad touches Distribution'])
set(gcf, 'Position', [680 4 598 962]) 