k = 1;
incr = 1;
sameTot = [];
% for j = 1:length(trials)
    touchRaw = trial.touchRaw;
    for i = 1:length(touchRaw)-1
        
        if touchRaw(i) == touchRaw(i+1)
            incr = incr + 1;
        else
            sameTot(k) = incr;
            incr = 1;
            k = k + 1;
        end
    end
% end
close all
%plot(trials(2).touchRaw, '-o')
figure
edges = 2:15;%[2 3 4 5 6 8 10 12 14];
histogram(sameTot*2, edges)
title('Distribution of Touch Chip Sample Times')
xlabel('Time (ms)')
ylabel('Frequency in bin')