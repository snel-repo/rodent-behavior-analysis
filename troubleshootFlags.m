function [allFailFlags]=troubleshootFlags(in,currentTrial,plotFlag)
allFailFlags = [in.trials.flagFail]; currentFailFlag=allFailFlags(currentTrial) %intentionally displayed
if plotFlag == true
    
    [filtData, baseLine] = touchFiltVariableHandler(in,currentTrial);
    
    miny = min(min([filtData baseLine]));
    maxy = max(max([filtData baseLine]));
    
    dThresh=10; difference = baseLine-filtData;
    maxydiff = max([difference; dThresh]);
    minydiff = min([difference; dThresh]);
    
    subplot(5,1,2);
    plot(in.trials(currentTrial).touchStatus); ylim([0,1.1]); title('Touch Status, this trial')
    
    subplot(5,1,3);yyaxis left; plot(filtData); title('Touch Capacitance w/ baseline (Blue) and Difference w/ threshold (Orange), this trial')
    hold on; plot(baseLine); ylim([miny,maxy]); legend('EMA','Baseline')
    yyaxis right; plot(difference); % difference bet. baseline and touchFilt
    plot(dThresh*ones(1,length(baseLine)),'LineStyle','--'); 
    
    subplot(5,1,4); plot(in.trials(currentTrial).state); title('Trial state, this trial')
    
    subplot(5,1,5); plot(in.trials(currentTrial).pos); title('Knob Position (blue) and Velocity (orange), this trial');
    yyaxis right; plot(in.trials(currentTrial).velRaw)
    
    subplot(5,1,1);
    H = histogram(allFailFlags,[-0.5:1:19.5]); title('All fail codes from entire session, current fail code group highlighted')
    uniqueFails = unique(allFailFlags); 
    hilite = H.BinEdges(currentFailFlag+1:currentFailFlag+2);
    hilite = [hilite fliplr(hilite)];
    y = [0 0 repmat(H.Values(currentFailFlag+1), 1, 2)];
    h_patch = patch(hilite, y, 'green', 'FaceAlpha', 0.5, 'LineStyle', ':');
    keyboard
    
end
end