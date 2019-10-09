% ratTaskRunner Analysis Home
% Use this program to select the appropriate analysis program
% Author: Tony Corsten
% Date: 7/2/2018
fprintf('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&\n');
fprintf('Welcome to the taskRunner Analysis Suite!\n');
fprintf('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&\n\n');
fprintf('Please select an analysis program:\n');
analysisSelect = {'0 = Raw Touch Plotter',...
    '1 = Touch Data Analysis'};

for i = 1:length(analysisSelect)
    fprintf('%s\n', analysisSelect{i});
end
selection = input('');
switch selection
    case 0
        x = 1;
    case 1
        x = 2;
end