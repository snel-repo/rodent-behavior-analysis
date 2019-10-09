function [in, summary] = analyzeCuedTurn(in, sessionTag)
for i = 1 : length(in)
    tmp = in(i).trials;
    % keyboard
    holdOnset = zeros(1, length(tmp));
    postTrialOnset = zeros(1, length(tmp));
    %failNoTarget = false(1,length(tmp));    
    for j = 1:length(tmp)
        initTrialIdx = find(tmp(j).state == 1);
        isTouch = tmp(j).touchStatus;
        isTouch(initTrialIdx) = 0;
        touchIdx = find(isTouch);

        % for rand turn task
        isHoldStart = find((tmp(j).state == 3) & (tmp(j).touchStatus));
        if isempty(isHoldStart)
            holdOnset_1(j) = NaN;
        else
            holdOnset_1(j) = isHoldStart(1);
        end
        isTrialEnd = find(tmp(j).state == 5);
        trialEnd_1(j) = isTrialEnd(1) + 500;
        
        if isempty(touchIdx)
            holdOnset(j) = NaN;
        else
            holdOnset(j) = touchIdx(1);
        end
        %get rid of trials that the rat started holding before entering "trial" (3) state
        if holdOnset_1(j) == 251;
            holdOnset_1(j) = NaN;
        end
        postTrialIdx = find(tmp(j).state == 5);
        postTrialOnset(j) = postTrialIdx(1);
        firstTurnEndIdx = find((tmp(j).state == 5) & (tmp(j).vel == 0));
        in(i).trials(j).firstTurnOffset = firstTurnEndIdx(1); % if no turn at all, this is equal to postTrialOnset(j)
        turnInPostTrial = (tmp(j).state == 5) & (tmp(j).vel ~= 0);
        if any(find(diff(turnInPostTrial), 1))
            turnStartPostTrial = find(diff(turnInPostTrial) == 1);
            if (turnStartPostTrial(1) - firstTurnEndIdx(1)) > 300 % if for 600ms in post trial period we don't see a turn
                in(i).trials(j).secondTurnOffset = NaN;
            else
                turnEndPostTrial = find(diff(turnInPostTrial) == -1);
                if turnEndPostTrial(1) > turnStartPostTrial(1)
                    in(i).trials(j).secondTurnOffset = NaN;
                else
                    in(i).trials(j).secondTurnOffset = turnEndPostTrial(2);
                end
            end
        end
        in(i).trials(j).holdOnset = holdOnset(j);
        in(i).trials(j).postTrialOnset = postTrialOnset(j);
        in(i).trials(j).trialEnd_1 = trialEnd_1(j);
        in(i).trials(j).holdOnset_1 = holdOnset_1(j);
        %if in(i).trials(j).hitTrial
        turningIdx = find(tmp(j).touchStatus & tmp(j).state == 3 & abs(tmp(j).pos) > 3); % hard coded now by FZ, change to holdPosMax
        if isempty(turningIdx)
            in(i).trials(j).definedHoldTime = NaN;
        else
            in(i).trials(j).definedHoldTime = turningIdx(1) - holdOnset_1(j);
        end
            %else
            %in(i).trials(j).definedHoldTime = NaN;
            %end
    end
    %failNoTarget = (postTrialOnset - holdOnset) <= tmp(1).timeHoldMin;
    failNoTarget = (postTrialOnset - holdOnset)*2 <= 6;
    holdNoTurn  = (postTrialOnset - holdOnset)*2 >= 6 + 500 - 3;
    
    summary(i).trialNum = length(in(i).trials);
    summary(i).hitNum = sum([in(i).trials(:).hitTrial]);
    summary(i).hitRate = sum([in(i).trials(:).hitTrial]) / length(in(i).trials); % compute hit rate
    summary(i).sessionTag = sessionTag{i};
    summary(i).holdTooShort = mean(failNoTarget);
    summary(i).holdNoTurn = mean(holdNoTurn);
end



