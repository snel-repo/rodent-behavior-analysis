function ratScatter(in, ratName, sessionDateTimeAndSaveTag, pngFlag, pngPath)
pngPath = "/snel/home/jwang945/PNG_plots";

allTouch = {};
goodBadTouches = {};
sessionTick = zeros(1, numel(in));
cueOnset = {};

for isess = 1:numel(in)
    if isess == 1
        sessionTick(isess) = 1;
    else
        sessionTick(isess) = numel(allTouch{isess - 1}) + sessionTick(isess - 1);
    end
    
    oneSession = in(isess);
    allTrials = oneSession.trials;
    touchStatus = {};
    trialState = {};
    for i = 1:numel(allTrials)
        touchStatus{i} = allTrials(i).touchStatus;
        trialState{i} = allTrials(i).state;
        failType{i} = allTrials(i).flagFail;
    end
    %%keyboard
    %%
    allTouch{isess} = {};
    goodBadTouches{isess} = {};
    cueOnset{isess} = {};
    cueTimeOut{isess} = {};
    %goodTouch{isess} = {};
    %anyTouch{isess} = false(1, numel(trialState));
    %isGoodTouch{isess} = false(1, numel(trialState));
    %goodTouchTime{isess} = NaN(1, numel(trialState));
    for x = 1:numel(trialState) %loops through each field, where each field is named 1,2,3,...
        allTouch{isess}{x} = zeros(1, numel(trialState{x}));
        tick = 2;
        %    badTouch = 0;
        while tick <= length(trialState{x}) %loops through each row in the field
            if touchStatus{x}(tick) == 1 && touchStatus{x}(tick - 1) == 0 %if it is the first tick of a touch        
                if trialState{x}(tick) ~= 3
                    allTouch{isess}{x}(tick) = 1;
                else
                    allTouch{isess}{x}(tick) = 2;
                end
            end
            tick = tick + 1;
        end
        %        goodBadTouches{isess}{x} = allTouch{isess}{x}(allTouch{isess}{x} > 0);
        %plot(x,badTouch(x));
        %hold on;
        tmp = find(trialState{x} == 3);
        cueOnset{isess}{x} = tmp(1);
        if failType{x} == 9
            tmp_1 = find(trialState{x} == 5);
            cueTimeOut{isess}{x} = tmp_1(1);
        else
            cueTimeOut{isess}{x} = NaN;
        end
    end

end

%% plotting session details, aligned to cueOnset

isess = numel(in);
maxCueOn = max([cueOnset{isess}{:}]);
align_offset = {};
adjust_x = maxCueOn + 500;

if ~strcmp(pngFlag,'nopng')
    f = figure('visible','off');
    if ~exist(pngPath,'dir')
        mkdir(pngPath)
    end
elseif strcmp(pngFlag,'nopng')
    f = figure;
end
for itrial = 1: numel(allTouch{isess})
    y = itrial * ones(1, length(allTouch{isess}{itrial}));
    x = 1:length(allTouch{isess}{itrial});
    align_offset{isess}{itrial} = maxCueOn - cueOnset{isess}{itrial} + 500;
    scatter((2*(x(allTouch{isess}{itrial} == 1) + align_offset{isess}{itrial} - adjust_x))/1000, y(allTouch{isess}{itrial} == 1), 'r', 'filled')
    hold on
    scatter((2*(x(allTouch{isess}{itrial} == 2) + align_offset{isess}{itrial} - adjust_x))/1000, y(allTouch{isess}{itrial} == 2), 'g', 'filled')
    hold on
    scatter((2*(x(cueOnset{isess}{itrial}) + align_offset{isess}{itrial} - adjust_x))/1000, itrial, 'k', '^')
    hold on
    scatter((2*(align_offset{isess}{itrial} - adjust_x))/1000, itrial, 'k', 'd', 'filled')
    hold on
    if ~isnan(cueTimeOut{isess}{itrial})
        scatter((2*(x(cueTimeOut{isess}{itrial}) + align_offset{isess}{itrial} - adjust_x))/1000, itrial, 'b', 's', 'filled')
    end
end
set(f, 'Position', [0 0 1200 1000])
set(gca, 'ytick', [1 : 1 : itrial])
ax = gca;
ax.XGrid = 'off';
ax.YGrid = 'on';
ax.XAxis.Exponent = 0;
ylabel('trial')
xlabel('time (s)')
axis tight
title([ratName ' ' sessionDateTimeAndSaveTag])
if ~strcmp(pngFlag,'nopng')
    sessionTimeStamp = char(string(in.trials(1).dateTimeTag));
    saveas(f,[pngPath ratName '_scatter_' sessionTimeStamp '.png'],'png')
    close(f)
end
return;
% %% plotting session details, aligned to trial Start
% 
% isess = numel(in);
% 
% 
% figure
% for itrial = 1: numel(allTouch{isess})
%     y = itrial * ones(1, length(allTouch{isess}{itrial}));
%     x = 1:length(allTouch{isess}{itrial});
%     scatter(2*x(allTouch{isess}{itrial} == 1), y(allTouch{isess}{itrial} == 1), 'r', 'filled')
%     hold on
%     scatter(2*x(allTouch{isess}{itrial} == 2), y(allTouch{isess}{itrial} == 2), 'g', 'filled')
%     hold on
%     scatter(2*x(cueOnset{isess}{itrial}), itrial, 'k', '^')
%     hold on
%     %scatter(2*align_offset{isess}{itrial}, itrial, 'k', 'd', 'filled')
%     %hold on
%     if ~isnan(cueTimeOut{isess}{itrial})
%         scatter(2*x(cueTimeOut{isess}{itrial}), itrial, 'b', 's', 'filled')
%     end
% end
% set(gcf, 'Position', [0 0 1200 1000])
% set(gca, 'ytick', [1 : 1 : itrial])
% ax = gca;
% ax.XGrid = 'off';
% ax.YGrid = 'on';
% ylabel('trial')
% xlabel('time (s)')
% axis tight
% %print(gcf, 'exampleSession', '-dpng')
% 
% 
% title([name ' ' session])
% %%
% 
% 
% isess = numel(in);
% figure
% for itrial = 1: numel(goodBadTouches{isess})
%     if ~isempty(goodBadTouches{isess}{itrial})
%         y = itrial * ones(1, length(goodBadTouches{isess}{itrial}));
%         x = 1:length(goodBadTouches{isess}{itrial});
%         scatter(x(goodBadTouches{isess}{itrial} == 1), y(goodBadTouches{isess}{itrial} == 1), 'r', 'filled')
%         hold on
%         scatter(x(goodBadTouches{isess}{itrial} == 2), y(goodBadTouches{isess}{itrial} == 2), 'g', 'filled')
%         hold on
%     end
% end
% set(gcf, 'Position', [0 0 600 1000])
% set(gca, 'ytick', [1 : 1 : itrial])
% ax = gca;
% ax.XGrid = 'off';
% ax.YGrid = 'on';
% ylabel('trial')
% xlabel('touch')
% print(gcf, 'exampleSession', '-dpng')
%         
% %% plot session summary
% 
% figure
% baseX = [1,2,3];
% g = cell(3,1);
% g{1} = 'Good Touches';
% g{2} = 'Bad Touches';
% g{3} = 'No Touch';
% 
% 
% %c = linspace(1,10,length(baseX));
% c = [0,1,0;1,0,0;0,0,0];
% for i = 1:numel(badTouch)
%     bad = sum(badTouch{i});
%     good = sum(goodTouch{i});
%     noTouch = sum(~anyTouch{i});
%     sz = 100;
%     %scatter((5*(i-1)+baseX), [bad,good,noTouch], sz, c, 's');
%     gscatter((5*(i-1)+baseX), [good,bad,noTouch], g, 'grk', 's', 10);
%     if i == 1
%         legend('Location','northwestoutside')
%     end
%     
%     hold on
% end
% ylabel('Num of Touches')
% xticks(((1:numel(badTouch))-1)*5 + 2);
% xticklabels({'Sess 1', 'Sess 2', 'Sess 3', 'Sess 4'})
% %%
% 
% 
% 
% %keyboard
% %%
% all_badTouches = cat(2, badTouch{:});
% all_anyTouches = cat(2, anyTouch{:});
% x = 1:numel(all_badTouches);
% 
% %%
% figure
% scatter(x(all_anyTouches), all_badTouches(all_anyTouches), 'g', 'filled')
% hold on
% scatter(x(~all_anyTouches), all_badTouches(~all_anyTouches), 'r', 'filled')
% ylabel('Num of bad touches')
% xticks(sessionTick);
% xticklabels({'Sess 1', 'Sess 2', 'Sess 3'})
% xlabel('Trials')
% title('Bad touches across sessions')
% set(gcf, 'Position', [50, 200, 1800, 600])
% 
% %%
% all_goodTimes = cat(2, goodTouchTime{:});
% all_isGoodTouch = cat(2, isGoodTouch{:});
% x = 1:numel(all_isGoodTouch);
% %%
% zeroX = zeros(1, numel(x));
% figure
% scatter(x(all_isGoodTouch), all_goodTimes(all_isGoodTouch), 'b', 'filled')
% hold on
% ylabel('Reaction Time for Touching')
% scatter(x(~all_isGoodTouch), zeroX(~all_isGoodTouch), 'r', 'filled')
% xticks(sessionTick);
% xticklabels({'Sess 1', 'Sess 2', 'Sess 3', 'Sess 4'})
% xlabel('Trials')
% title('Reaction Time for Touching across sessions')
% set(gcf, 'Position', [50, 200, 1800, 600])