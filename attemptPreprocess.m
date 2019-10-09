function [attempts, trials, session] = attemptPreprocess(trials)
totalAttempts = 1;
for i = 1 : length(trials)
    totalAttemptsTrial = 0;
    postIdx = find(trials(i).state == 5 , 1) - 1;
    hitIdx = find(trials(i).eventData_time == trials(i).trialData_time) - 2; % find the index for when the hit occurred
    trials(i).hitIdx = hitIdx;
    trialIdx = find(trials(i).state == 3);
    %     zeroStartIdx = find(diff(double(trials(i).zeroVelFlag)) == -1); % turn begins
    %     zeroEndIdx = find(double(diff(trials(i).zeroVelFlag)) == 1); % turn ends
    velThreshed = abs(trials(i).vel)  > trials(i).minVelThresh;
    velPreActive = [0 diff(velThreshed)'];
    velActiveAreas = calcActiveRegions(velPreActive, 0, 0);
    %---DETERMINE WHICH TRIALS HAD NO MOVEMENT----%
    if isempty(velActiveAreas)
        trials(i).nonMoveTrial = 1; % increment total non-movement trials
    else
        trials(i).nonMoveTrial = 0; % movement occurred
    end
    %% deleting non-trial attempts
    deleteRow = [];
    for g = 1:length(velActiveAreas(:,1))
        if velActiveAreas(g, 1) < trialIdx(1) || velActiveAreas(g,2) > trialIdx(end)
            deleteRow = [deleteRow g];
        end
    end
    velActiveAreas(deleteRow, :) = []; % delete rows that are not in Trial
    
    %% store information about turn attempts
    for j = 1:length(velActiveAreas(:,1))
        %if ~isempty(find(zeroEndIdx(j) == trials(i).attemptBus_time / 2)) || (hitIdx > zeroStartIdx(j) && hitIdx <= zeroEndIdx(j) && trials(i).hitTrial)%%&&
        % if (trials(i).pos(zeroEndIdx(j))> trials(i).trialStartTheta+0 ||  trials(i).pos(zeroEndIdx(j))<-double(trials(i).trialStartTheta)-0) % && trials(i).pos(zeroStartIdx(j)) == 0
        %---STORE KINEMATIC INFORMATION FOR ATTEMPTS---%
        %             if (trials(i).pos(zeroEndIdx(j)) < 3.1 && trials(i).pos(zeroEndIdx(j)) > 0) || (trials(i).pos(zeroEndIdx(j)) > -3.025 && trials(i).pos(zeroEndIdx(j)) < 0)
        %                 s = 1;
        %             end
        attempts(totalAttempts).pos = trials(i).pos(velActiveAreas(j, 1)  : velActiveAreas(j, 2)); % store attempt position
        attempts(totalAttempts).vel = trials(i).vel(velActiveAreas(j, 1)  : velActiveAreas(j, 2)); % store attempt velocity
        attempts(totalAttempts).maxPos = max(trials(i).pos(velActiveAreas(j,1) : velActiveAreas(j,2))); % store attempt maximum position
        attempts(totalAttempts).maxVel = max(trials(i).vel(velActiveAreas(j,1) : velActiveAreas(j,2))); % store attempt maximum velocity
        attempts(totalAttempts).minPos = min(trials(i).pos(velActiveAreas(j,1) : velActiveAreas(j,2))); % store attempt minimum position
        attempts(totalAttempts).minVel = min(trials(i).vel(velActiveAreas(j,1) : velActiveAreas(j,2))); % store attempt minimum velocity
        attempts(totalAttempts).finalPos = trials(i).pos(velActiveAreas(j,2)); % store final attempt position
        attempts(totalAttempts).startIdx = velActiveAreas(j,1); % store the index the turn begins
        attempts(totalAttempts).endIdx = velActiveAreas(j,2); % store the index the turn ends
        attempts(totalAttempts).attemptInTrial = totalAttemptsTrial; % write what number attempt this is in the trial
        attempts(totalAttempts).trialNum = i; % this may not be the true trial number, but it is the order in which the trials were processed
        attempts(totalAttempts).hitIdx  = hitIdx;
        attempts(totalAttempts).timeAttempt = (trials(i).sampleTime / 1e-3) * length( trials(i).vel(velActiveAreas(j, 1)  : velActiveAreas(j, 2)));
        attempts(totalAttempts).perturbed = trials(i).pertEnableTrial;
        %---DETERMINE WHERE TRIALS FAILED (ABOVE OR BELOW THRESHOLD)---%
        if attempts(totalAttempts).finalPos > trials(i).maxWindow
            attempts(totalAttempts).aboveFail = 1; % 1 if fail above
        elseif attempts(totalAttempts).finalPos < trials(i).minWindow
            attempts(totalAttempts).aboveFail = -1; % 0 if fail below
        else
            attempts(totalAttempts).aboveFail = 0; % 0 if success
        end
        %---DETERMINE IS ATTEMPT IS A HIT----%
        if isempty(hitIdx)
            fprintf(['Missing hit data packet detected in trial ' num2str(i) '\n'])
        elseif hitIdx > velActiveAreas(j,1) && hitIdx <= velActiveAreas(j,2) && trials(i).hitTrial% see if hit occurs within start and end indices
            attempts(totalAttempts).hit = 1; % if yes, hit
        else
            attempts(totalAttempts).hit = 0; % if not, miss
        end
        if trials(i).protocolVersion < 6 && trials(i).pos(velActiveAreas(j,1)) < 0 && trials(i).taskMode == 0
            % there was a bug before v6 where negative turns were not
            % counted towards the attempt total
        else
            totalAttemptsTrial = totalAttemptsTrial + 1;
        end
        totalAttempts = totalAttempts + 1; % increment total attempts
        %         elseif (abs(max(trials(i).pos(zeroStartIdx(j) : zeroEndIdx(j)))) < 5 ||  abs(min(trials(i).pos(zeroStartIdx(j) : zeroEndIdx(j)))) > 5)
        %             if nonMoveTrialFlag == 0
        %                 nonMoveTrialFlag = 1;
        %             end
        %end
    end
    trials(i).attemptTotal = totalAttemptsTrial; % log total attempts
    if totalAttemptsTrial > 3
        s = 1;
    end
    if totalAttemptsTrial == 1 && trials(i).hitTrial
        trials(i).firstAttemptSuccess = 1;
    else
        trials(i).firstAttemptSuccess = 0;
    end
    
    if trials(i).bidirectionalEnable && trials(i).firstAttemptSuccess == 1 && trials(i).dirTask == 0 && trials(i).hitTrial
        trials(i).labelAttempt = 1; % 1 is for CW turns succeeded on first attempt
    elseif trials(i).bidirectionalEnable && trials(i).firstAttemptSuccess == 1 && trials(i).dirTask == 1 && trials(i).hitTrial
        trials(i).labelAttempt = 2; % 2 is for CCW turns succeeded on first attempt
    elseif trials(i).bidirectionalEnable == 0
        trials(i).labelAttempt = NaN; % 0 is for trials that did not succeed on the first attempt, or did not have any attempts.
    elseif trials(i).bidirectionalEnable && trials(i).attemptTotal > 1 || isnan(trials(i).attemptTotal)
        trials(i).labelAttempt = 0;
    end
end

belowWindowAttemptIdx = find([attempts(:).aboveFail] == -1); % computes the indices of failed attempts below window
aboveWindowAttemptIdx = find([attempts(:).aboveFail] == 1);  % computes the indices of failed attempts above window
session.meanLow = mean([attempts(belowWindowAttemptIdx).finalPos]); % computes mean of below window position end of attempt
session.meanHigh = mean([attempts(aboveWindowAttemptIdx).finalPos]); % computes mean of above window position end of attempt
session.stdLow = std([attempts(belowWindowAttemptIdx).finalPos]); % computes std of below window position end of attempt
session.stdHigh =  std([attempts(aboveWindowAttemptIdx).finalPos]); % computes std of above window position end of attempt
%
session.rateMissAbove = length(belowWindowAttemptIdx) / (sum([trials(:).attemptTotal]) - sum(~[attempts(:).hit]));
session.rateMissBelow = length(aboveWindowAttemptIdx) / (sum([trials(:).attemptTotal]) - sum(~[attempts(:).hit]));

session.CCW = sum([trials(:).dirTask]);
session.CW = length(trials) - session.CCW;

session.CCWNonMoveTrial = sum([trials(:).nonMoveTrial] .* double([trials(:).dirTask]));
session.CWNonMoveTrial = sum([trials(:).nonMoveTrial] .* ~double([trials(:).dirTask]));

session.CCWHit = sum(double([trials(:).wasHit]) .* double([trials(:).dirTask]));
session.CWHit = sum(double([trials(:).wasHit]) .* ~double([trials(:).dirTask]));


session.CCWHitRate = session.CCWHit / (session.CCW - session.CCWNonMoveTrial);
session.CWHitRate = session.CWHit / (session.CW - session.CWNonMoveTrial);

session.CCWHitFirst =  sum(double([trials(:).firstAttemptSuccess]) .* double([trials(:).dirTask]));
session.CWHitFirst =  sum(double([trials(:).firstAttemptSuccess]) .* ~double([trials(:).dirTask]));

session.CCWHitRateFirst = session.CCWHitFirst / (session.CCW - session.CCWNonMoveTrial);
session.CWHitRateFirst = session.CWHitFirst / (session.CW - session.CWNonMoveTrial);

hitAttemptsIdx = find([attempts(:).hit]);

session.meanHitAttemptTime = mean([attempts(hitAttemptsIdx).timeAttempt]);
session.stdHitAttemptTime = std([attempts(hitAttemptsIdx).timeAttempt]);

session.attemptHitRate = sum([trials(:).wasHit]) / length(attempts);
session.nonMoveTrial = sum([trials(:).nonMoveTrial]);
session.overallHitRateCorrected =  sum([trials(:).wasHit]) / (length(trials) - sum([trials(:).nonMoveTrial]));
session.nonMoveTrialPert = sum([trials(:).nonMoveTrial] .* double([trials(:).pertEnableTrial]));
session.nonMoveTrialUnpert = session.nonMoveTrial - session.nonMoveTrialPert;
session.pertTrialTotal = sum([trials(:).pertEnableTrial]);
session.unpertTrialTotal = sum(~[trials(:).pertEnableTrial]);
session.unpertHitRateCorrected = sum([trials(:).wasHit] .* ~double([trials(:).pertEnableTrial])) / (session.unpertTrialTotal - session.nonMoveTrialUnpert);
if session.pertTrialTotal ~= 0
    session.pertHitRateCorrected = sum([trials(:).wasHit] .* double([trials(:).pertEnableTrial])) / (session.pertTrialTotal - session.nonMoveTrialPert);
else
    session.pertHitRateCorrected = NaN;
end
session.totalTrials = length(trials);
session.totalAttempts = sum([trials(:).attemptTotal]);