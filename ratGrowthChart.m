function [predicted_curve] = ratGrowthChart(first_ten_day_age_vector, first_ten_weights_vector, endpoint_time)
%RATGROWTHCHART used to generate growth curves for each rat, based on
%published rat growth charts

% all wistar growth data from http://hilltoplabs.com/public/wigrowth.html
%wistartMaleData.grams = [50;210;380;470;525;575;605;630;650;660;675;705;740;755;765;775;790;805;810;830;850;860;863];
%wistarFemaleGrowthData.grams = [45;170;250;290;320;345;350;360;380;390;405;415;425;440;450;465;470;485;495;520;525;540;550];
%wistarMaleGrowthData.std = [5;10;15;20;20;25;25;30;30;35;40;45;50;50;50;50;50;50;50;60;60;65;75];
%wistarFemaleGrowthData_std = [5;10;15;20;20;25;25;30;30;35;40;45;50;50;50;50;50;50;50;60;60;65;75];

% Long-Evans Growth Data from: https://doi.org/10.1016/j.toxrep.2014.12.007
longevFemaleGrowthData_time_in_weeks = [0:25]'; % 25 weeks
longevFemaleGrowthData_grams = [65;92;117;137;150;160;170;176;186;190;200;205;206;208;215;216;220;223;222;228;228;225;229;228;230;235];
wistarFemaleGrowthData_grams_std = linspace(0,30,26)'; % std approximately linear for female rats (taken from http://hilltoplabs.com/public/wigrowth.html)

upper2std_curve = longevFemaleGrowthData_grams + 2*wistarFemaleGrowthData_grams_std;
lower2std_curve = longevFemaleGrowthData_grams - 2*wistarFemaleGrowthData_grams_std;

% subtract 10 day vector from equivalent days of the Long-Evans data
first_ten_day_age_vector_weeks = first_ten_day_age_vector / 7; % convert input to weeks
longev_interp_weights = interp1(longevFemaleGrowthData_time_in_weeks,longevFemaleGrowthData_grams,first_ten_day_age_vector_weeks);
longev_interp_stds = interp1(longevFemaleGrowthData_time_in_weeks,wistarFemaleGrowthData_grams_std,first_ten_day_age_vector_weeks);

% compute average of difference between normal weight and this rat (keeping sign for each element)
% and take ratio to reflect amount of deviance relative to the Long-Evans data standard deviations
average_input_deviation = mean(longev_interp_weights - first_ten_weights_vector);
average_longev_deviation = mean(longev_interp_stds);
deviation_ratio = average_input_deviation/average_longev_deviation;

% extrapolate the prediction growth curve for this rat, and subtract
% standard deviation, scaled by the calculated deviation ratio
extrapolated_deviations = interp1(longevFemaleGrowthData_time_in_weeks,wistarFemaleGrowthData_grams_std, [first_ten_day_age_vector_weeks(1):endpoint_time],'linear','extrap');
predicted_curve = interp1(longevFemaleGrowthData_time_in_weeks, longevFemaleGrowthData_grams,[first_ten_day_age_vector_weeks(1):endpoint_time],'linear','extrap') - extrapolated_deviations*deviation_ratio;

% plotting baselines and (+/-) 2 stds
plot(longevFemaleGrowthData_time_in_weeks,longevFemaleGrowthData_grams,'k-','LineWidth',0.1); hold on
plot(longevFemaleGrowthData_time_in_weeks,upper2std_curve,'r-','LineWidth',0.1)
% plotting given data and prediction
plot([first_ten_day_age_vector_weeks(1):endpoint_time],predicted_curve,'g','LineWidth',2);
plot(first_ten_day_age_vector_weeks,first_ten_weights_vector,'k','LineWidth',2);
% plot lower std at end, to fix legend order
plot(longevFemaleGrowthData_time_in_weeks,lower2std_curve,'r-','LineWidth',0.1)
title('Projection of Female Long-Evans Growth')
xlabel('Age (weeks)')
ylabel('Weight (grams)')
legend('Long-Evans Typical Growth','(+/-) 2 Std.','Predicted Weight (25 weeks)','Actual Weight (1st 10 days)','Location','northwest')
grid minor

figHandle = gcf;
figHandle.Position = [10 10 750 850]; % left bottom width height
end
