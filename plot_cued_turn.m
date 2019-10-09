function plot_cued_turn(in, summary)
%keyboard
trials_CW = in(1).trials([in(1).trials.dirTask] == uint8(0));
trials_CCW = in(1).trials([in(1).trials.dirTask] == uint8(1));
figure('units','normalized','outerposition',[0 0 1 1])
subplot(2,1,1)
for itr = 1:numel(trials_CW)
    if ~isnan(trials_CW(itr).holdOnset_1)
        start_idx = trials_CW(itr).holdOnset_1; %- round(250/2); % change 6 to timeHoldMin later
        end_idx = trials_CW(itr).postTrialOnset;
        %end_post_idx = trials_CW(itr).postTrialOnset + 800; % plot way after into postTrial period
        if trials_CW(itr).hitTrial
            color = 'g';
        else
            color = 'b';
        end
        plot(trials_CW(itr).pos(start_idx:end_idx,1), 'Color', [color])
        hold on
        %plot(trials_CW(itr).pos(start_idx : trials_CW(itr).firstTurnOffset,1), 'Color', [color], 'LineStyle','--')
        %plot(trials_CW(itr).pos(start_idx : trials_CW(itr).trialEnd_1,1), 'Color', [color], 'LineStyle','--')
        xlabel('tick (2 ms)')
        ylabel('turning angle')
        title('CW condition')
    end
end

subplot(2,1,2)
for itr = 1:numel(trials_CCW)
    if ~isnan(trials_CCW(itr).holdOnset_1)
        start_idx = trials_CCW(itr).holdOnset_1; % - round(250/2); % change 6 to timeHoldMin later
        end_idx = trials_CCW(itr).postTrialOnset;
        %end_post_idx = trials_CCW(itr).postTrialOnset + 800; % plot way after into postTrial period
        if trials_CCW(itr).hitTrial
            color = 'r';
        else
            color = 'b';
        end
        plot(trials_CCW(itr).pos(start_idx:end_idx,1), 'Color', [color])
        hold on
        % plot(trials_CCW(itr).pos(start_idx : trials_CCW(itr).firstTurnOffset,1), 'Color', [color], 'LineStyle','--')
        plot(trials_CCW(itr).pos(start_idx : trials_CCW(itr).trialEnd_1,1), 'Color', [color], 'LineStyle','--')
        xlabel('tick (2 ms)')
        ylabel('turning angle')
        title('CCW condition')
    end
end



