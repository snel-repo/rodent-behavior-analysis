%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Authors: ...
% Purpose: ...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage:
%   0) ...
%


%% Pull rat names for user to select
function [trials] = analyzeDataParamEstimation()

    clear all
    close all


    load('freespin_data.mat');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%                      EXTRACT RELEVANT TRIALS                          %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
    trials = t16
    currentParams = [-7.3126e-05, 0.1606]; %t16
    %currentParams = [-7.1327e-05, 0.1474]; %t25
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%     Plot relevant variables      %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    trial_cond = zeros(numel(trials.trials),1);
    accel_start_index = zeros(numel(trials.trials),1);
    accel_end_index = zeros(numel(trials.trials),1);
    decel_start_index = zeros(numel(trials.trials),1);
    decel_end_index = zeros(numel(trials.trials),1);
    
    
    % plot command current
    figure()
    for i = 1:numel(trials.trials)
    
        trial = trials.trials(i);
        
        mot_dir = double(2*trial.dirMotor)-1;
        motorCurrent = mot_dir.*trial.motorCurrent;
        
        trial_cond(i) = motorCurrent(1500);

        color_trial = [(40-trial_cond(i))/80,0,(trial_cond(i)+40)/80];
        
        plot(trial.trialData_time, motorCurrent, 'Color', color_trial);
        
        %accel_start_index(i) = find(motorCurrent ~= 0, 1);
        accel_start_index(i) = find(abs(trial.velRaw) > 10, 1);
        
        xlabel('time [ms]')
        ylabel('Motor current command [mA]')
    
    end
    
    % plot acceleration velocity
    figure()
    for i = 1:numel(trials.trials)
    
        trial = trials.trials(i);
        
        color_trial = [(40-trial_cond(i))/80,0,(trial_cond(i)+40)/80];
        
        ii = find(abs(trial.velRaw)>3000, 1);
        if length(ii) > 0 
            accel_end_index(i) = ii;
            plot(trial.trialData_time(accel_start_index(i):accel_end_index(i)), pi*trial.velRaw(accel_start_index(i):accel_end_index(i))/180, 'Color', color_trial)
            hold on
        else
            accel_end_index(i) = accel_start_index(i) + 100;
        end
        
        %accel_end_index(i) = find(abs(trial.velRaw)>3000, 1);
        
        xlabel('time [ms]')
        ylabel('Velocity [rad/s]')
        
          
    end
 
    % plot deceleration velocity
    for i = 1:numel(trials.trials)
        
        trial = trials.trials(i);
        
        decel_start_index(i) = find(abs(trial.velRaw(2450:end))<3000, 1) + 2450;
        sign_pre = sign(trial.velRaw(2450:end-1));
        sign_pos = sign(trial.velRaw(2450+1:end));
        %decel_end_index(i) = find((sign_pre ~= sign_pos) ~= 0, 1) + 2450
        %decel_end_index(i) = find(abs(trial.velRaw(2450:end))<10, 1);
        decel_end_index(i) = decel_start_index(i)+20;
    end
    
    
    figure()
    for i = 1:numel(trials.trials)
    
        trial = trials.trials(i);
        
        color_trial = [(40-trial_cond(i))/80,0,(trial_cond(i)+40)/80];
        
        plot(trial.trialData_time(decel_start_index(i):decel_end_index(i)), pi*trial.velRaw(decel_start_index(i):decel_end_index(i))/180, 'Color', color_trial)
        hold on
    
        xlabel('time [ms]')
        ylabel('Velocity [rad/s]')
        
    end
    
    
    % plot escon current measurement
    figure()
    for i = 1:numel(trials.trials)
    
        trial = trials.trials(i);
        
        color_trial = [(40-trial_cond(i))/80,0,(trial_cond(i)+40)/80];
        
        plot(trial.trialData_time(accel_start_index(i):accel_end_index(i)), trial.currentMeasEscon(accel_start_index(i):accel_end_index(i)), 'Color', color_trial)
        hold on
    
        xlabel('time [ms]')
        ylabel('Measured motor current (ESCON) [A]')
        
    end
    
    % plot shunt current measurement
    figure()
    for i = 1:numel(trials.trials)
    
        trial = trials.trials(i);
        
        color_trial = [(40-trial_cond(i))/80,0,(trial_cond(i)+40)/80];
        
        %plot(trial.trialData_time(accel_start_index(i):accel_end_index(i)), trial.currentMeasShunt(accel_start_index(i):accel_end_index(i)), 'Color', color_trial)
        plot(trial.currentMeasShunt(1:accel_end_index(i)), 'Color', color_trial)
        hold on

        xlabel('time [ms]')
        ylabel('Measured motor current (shunt) [A]')
        
        
    end
    
    % plot both current measurements
    figure()
    for i = 1:numel(trials.trials)
    
        trial = trials.trials(i);
        
        color_trial = [(40-trial_cond(i))/80,0,(trial_cond(i)+40)/80];
        
        plot(trial.trialData_time(), trial.currentMeasShunt(), 'Color', color_trial)
        hold on
        plot(trial.trialData_time(), trial.currentMeasEscon(), '--', 'Color', color_trial)

        xlabel('time [ms]')
        ylabel('Measured motor current (shunt) [A]')
        
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%     Compute torque parameters relevant variables      %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    close all
    
    k_mot = 36 * 1/1000;  
    ts = 0.002;
    
    y_full = [];
    y_accel = [];
    y_decel = [];

    x_mot_full = [];
    x_mot_accel = [];
    x_mot_decel = [];
    
    sign_fric_accel = [];
    sign_fric_decel = [];

    fc = 50;
    fs = 500;
    Wn = fc/(fs/2);
    [b50,a50] = butter(2,Wn);
    fc = 100;
    fs = 500;
    Wn = fc/(fs/2);
    [b100,a100] = butter(2,Wn);
    
    for i = 1:numel(trials.trials)
    
        trial = trials.trials(i);
        
        color_trial = [(40-trial_cond(i))/80,0,(trial_cond(i)+40)/80];
        
        %plot(trial.trialData_time(accel_start_index(i):accel_end_index(i)), trial.currentMeasShunt(accel_start_index(i):accel_end_index(i)), 'Color', color_trial)
        %hold on
        %xlabel('time [ms]')
        %ylabel('Measured motor current (shunt) [A]')
        
        
        i_mot = currentParams(1)*double(trial.currentBitsShunt + currentParams(2));
        %i_mot_i = currentParams(1)*double(trial.currentBitsShunt() + currentParams(2);
        i_mot_i = i_mot(accel_start_index(i)+1:accel_end_index(i)-1) - i_mot(1);
        %i_mot_i = -i_mot_i;
        
        if length(i_mot_i) > 6
        
            i_mot_i = filtfilt(b100,a100,i_mot_i);


             %i_mot_i = trial.currentMeasEscon(accel_start_index(i):accel_end_index(i)-1);
             %i_mot_i = i_mot_i - trial.currentMeasEscon(1);

            pos_i = pi*trial.pos(accel_start_index(i):accel_end_index(i))/180;
            
            vel_i = diff(pos_i)/ts;
            accel_i = diff(vel_i)/ts;
            accel_i = filtfilt(b100,a100,accel_i);
            
            sign_fric_accel_i = -sign(vel_i(end))*ones(size(i_mot_i));

            if length(find(abs(vel_i)>80)) == 0 && length(vel_i)>80 == 0 && abs(vel_i(end))>50
                x_mot_accel = [x_mot_accel; i_mot_i];       
                y_accel = [y_accel; accel_i];
                %sign_fric_accel = [sign_fric_accel; sign_fric_accel_i];

                if sign(vel_i(1)) > 0 
                    sign_fric_accel = [sign_fric_accel; [sign_fric_accel_i, zeros(size(sign_fric_accel_i))]];
                else
                    sign_fric_accel = [sign_fric_accel; [zeros(size(sign_fric_accel_i)), sign_fric_accel_i]];
                end

                figure(1)
                plot(i_mot_i);
                hold on

                figure(2)
                plot(vel_i);
                hold on
                %plot(sign_fric_accel_i,'k')

            end
        end

        %i_mot_i = trial.currentMeasShunt(decel_start_index(i)+1:decel_end_index(i)-1);
        %i_mot_i = i_mot_i - trial.currentMeasShunt(1);
        %i_mot_i = -i_mot_i;

        i_mot = currentParams(1)*double(trial.currentBitsShunt + currentParams(2));
        %i_mot_i = currentParams(1)*double(trial.currentBitsShunt() + currentParams(2);
        i_mot_i = i_mot(decel_start_index(i)+1:decel_end_index(i)-1) - i_mot(1);
        %i_mot_i = -i_mot_i;
        
        if length(i_mot_i) > 6

            i_mot_i = filtfilt(b100,a100,i_mot_i);


    %         i_mot_i = trial.currentMeasEscon(accel_start_index(i):accel_end_index(i)-1);
    %         i_mot_i = i_mot_i - trial.currentMeasEscon(1);

            pos_i = pi*trial.pos(decel_start_index(i):decel_end_index(i))/180;
            pos_i = filtfilt(b100,a100,pos_i);
            vel_i = diff(pos_i)/ts;
            decel_i = diff(vel_i)/ts;
            
    %         i_mot_i = trial.currentMeasEscon(decel_start_index(i):decel_end_index(i)-1);
    %         i_mot_i = i_mot_i - trial.currentMeasEscon(1);

    %         figure(3)
    %         plot(i_mot_i);
    %         hold on

            %vel_i = pi*trial.velRaw(decel_start_index(i):decel_end_index(i))/180;
            %decel_i = diff(vel_i)/ts;

            sign_fric_decel_i = -sign(vel_i(1))*ones(size(i_mot_i));

            if abs(vel_i(1))>40 && length(find(abs(vel_i)>80)) == 0

                x_mot_decel = [x_mot_decel; i_mot_i];        
                y_decel = [y_decel; decel_i];

                if sign(vel_i(1)) > 0 
                    sign_fric_decel = [sign_fric_decel; [sign_fric_decel_i, zeros(size(sign_fric_decel_i))]];
                else
                    sign_fric_decel = [sign_fric_decel; [zeros(size(sign_fric_decel_i)), sign_fric_decel_i]];
                end


                figure(4)
                plot(vel_i);
                hold on
                %plot(sign_fric_decel_i,'k')

            end
            
        end
        

        
    end
    
    %figure
    %plot(x_mot_accel)
    
    X_mot_accel = [k_mot*x_mot_accel, sign_fric_accel];
    
    %figure
    %plot(y_accel)
    
    %figure
    %plot(x_mot_decel)
    
    X_mot_decel = [k_mot*x_mot_decel, sign_fric_decel];
    
    %figure
    %plot(y_decel)
    
    X = [X_mot_accel; X_mot_decel];
    y = [y_accel; y_decel];
    
    %X = [X_mot_decel];
    %y = [y_decel];
    
    %X = [X_mot_accel];
    %y = [y_accel];
    
    theta = inv(X'*X)*X'*y

    I_net = theta(1)^(-1)
    T_fri_mag_pos = theta(2)/theta(1)
    T_fri_mag_neg = theta(3)/theta(1)

    %% analysis

    rmse = (mean((X*theta - y).^2)).^(0.5)

    figure()
    plot(y_accel)
    hold on
    plot(X_mot_accel*theta)
    legend({'Measured','Prediction'});
    xlabel('Sample # (concatenated trials)') 
    ylabel('Knob Acceleration [rad/s^2]') 
    title('Measured v/s predicted acceleration, for acceleration trials (speed 0-50 rad/s)')

    figure()
    plot(y_decel)
    hold on
    plot(X_mot_decel*theta)
    legend({'Measured','Prediction'});
    xlabel('Sample # (concatenated trials)') 
    ylabel('Knob Acceleration [rad/s^2]') 
    title('Measured v/s predicted acceleration, for deceleration trials (speed 50-0 rad/s)')

    T_in_accel = I_net*y_accel - k_mot*x_mot_accel - sign_fric_accel*[T_fri_mag_pos; T_fri_mag_neg];
    T_in_decel = I_net*y_decel - k_mot*x_mot_decel - sign_fric_decel*[T_fri_mag_pos; T_fri_mag_neg];

    figure()
    plot(T_in_accel,'Linewidth',1)
    %figure()
    hold on
    plot(T_in_decel,'Linewidth',1)
    plot(0.036*0.02*ones(1,length(T_in_accel)),'k--','Linewidth',1)
    hold on
    legend({'Accel. 0-50 rad/s','Decel. 50-0 rad/s','Motor torque at 20mA'});
    xlabel('Sample # (concatenated trials)') 
    ylabel('Estimated external torque [N]') 
    title('Estimated external torque (should be 0)')    
    
    

end