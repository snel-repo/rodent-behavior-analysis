saveDir = '/snel/share/rodent/debug/F_test6/';
if ~isdir(saveDir)
    mkdir(saveDir);
end

cd(saveDir)
for i = 5
%for i = 1:numel(tmp)
    f1 = figure
    ah(1) = subplot(4,1,1);
    plot(tmp(i).touchStatus)
    title(['Touch Status'])
    ah(2) = subplot(4,1,2);
    plot(tmp(i).state)
    title(['Trial state'])
    ah(3) = subplot(4,1,3);
    plot(tmp(i).pos)
    title(['Knob Position'])
    ah(4) = subplot(4,1,4);
    plot(tmp(i).vel)
    title(['Knob Velocity'])
    set(gcf, 'Position', [238 38 1304 928])
    if tmp(i).hitTrial
        failStr = 'Hit';
    else
        failStr = 'Fail';
    end
    linkaxes(ah(1:2));
    suptitle(['trial ' int2str(i) ' - ' failStr]);
    print(f1, ['trial ' int2str(i) ' - ' failStr], '-dpng');
    %close all
end

%%
firstTickPos = zeros(1, numel(tmp));
lastTickPos = zeros(1, numel(tmp));
diff = zeros(1, numel(tmp));
for i = 1:numel(tmp)
    firstTickPos(i) = tmp(i).pos(1);
    lastTickPos(i) = tmp(i).pos(end);
    if i > 1
        diff(i) = firstTickPos(i) - lastTickPos(i - 1);
    end
end

