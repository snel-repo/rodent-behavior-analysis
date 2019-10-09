function [rat] = pullRatData(basedir)

        % first select subject
        rat.name = dir(basedir);
        rat.name = {ratNameDirAll.name};
        ratNames= ratNames(3:end); % trim . and .. from filenames
        try
            [ratInput_idx,~] = listdlg('PromptString', 'Select a rat', 'SelectionMode', 'single', 'ListString', ratNames);
        catch
            fprintf('Failed to pull rat directories. Likely incorrect base directory selected.\n');
            return;
        end
        if isempty(ratInput_idx)
            fprintf('Exiting program.\n')
            return
        end
        subjdir = [basedir ratNames{ratInput_idx} '/'];
        % next select session date
        sessionDatesDirAll = dir(subjdir);
        sessionDates = {sessionDatesDirAll.name};
        sessionDates = sessionDates(3:end); % trim . and .. from filenames
        [dateInput_idx,~] = listdlg('PromptString', 'Select a date', 'SelectionMode', 'single', 'ListString', sessionDates);
        if isempty(dateInput_idx)
            fprintf('Exiting program.\n')
            return
        end
        sessiondir = [subjdir sessionDates{dateInput_idx} '/1/'];
        % next select session time (morning or afternoon)
        sessionTimeDirAll = dir(sessiondir);
        sessionTime = {sessionTimeDirAll.name};
        sessionTime = sessionTime(3:end); % trim . and .. from filenames
        convSessionTime = regexprep(sessionTime, 'saveTag001', 'Morning');
        convSessionTime = regexprep(convSessionTime, 'saveTag002', 'Afternoon');
        [timeInput_idx,~] = listdlg('PromptString', 'Select a session time', 'SelectionMode', 'single', 'ListString', convSessionTime);
        if isempty(timeInput_idx)
            fprintf('Exiting program.\n')
            return
        end