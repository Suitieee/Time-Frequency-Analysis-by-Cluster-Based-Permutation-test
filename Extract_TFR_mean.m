function [TFR_mean] = Extract_TFR_mean(mean_powspctrm, time, freq_30)
% size(mat) = channel_num * freq_num * time_num
% 30Hz, time range from -0.5 ~ 4, while freq range from 2 ~ 30
% theta 1 ~ 4 Hz, delta 4 ~ 8 Hz, alpha 8 ~ 12 Hz, beta 12 ~ 20 Hz, gamma ~
% 20Hz

index_theta = find(freq_30 > 1  & freq_30 <= 4);
index_delta = find(freq_30 > 4  & freq_30 <= 8);
index_alpha = find(freq_30 > 8  & freq_30 <= 12);
index_beta  = find(freq_30 > 12 & freq_30 <= 20);
index_gamma = find(freq_30 > 20);

index_time_1 = find(time > 0 & time <= 1);
index_time_2 = find(time > 1 & time <= 2);
index_time_3 = find(time > 2 & time <= 3);
index_time_4 = find(time > 3 & time <= 4);

theta_1 = mean(mean_powspctrm(:, index_theta, index_time_1),[2 3]);
theta_2 = mean(mean_powspctrm(:, index_theta, index_time_2),[2 3]);
theta_3 = mean(mean_powspctrm(:, index_theta, index_time_3),[2 3]);
theta_4 = mean(mean_powspctrm(:, index_theta, index_time_4),[2 3]);

delta_1 = mean(mean_powspctrm(:, index_delta, index_time_1),[2 3]);
delta_2 = mean(mean_powspctrm(:, index_delta, index_time_2),[2 3]);
delta_3 = mean(mean_powspctrm(:, index_delta, index_time_3),[2 3]);
delta_4 = mean(mean_powspctrm(:, index_delta, index_time_4),[2 3]);

alpha_1 = mean(mean_powspctrm(:, index_alpha, index_time_1),[2 3]);
alpha_2 = mean(mean_powspctrm(:, index_alpha, index_time_2),[2 3]);
alpha_3 = mean(mean_powspctrm(:, index_alpha, index_time_3),[2 3]);
alpha_4 = mean(mean_powspctrm(:, index_alpha, index_time_4),[2 3]);

beta_1 = mean(mean_powspctrm(:, index_beta, index_time_1),[2 3]);
beta_2 = mean(mean_powspctrm(:, index_beta, index_time_2),[2 3]);
beta_3 = mean(mean_powspctrm(:, index_beta, index_time_3),[2 3]);
beta_4 = mean(mean_powspctrm(:, index_beta, index_time_4),[2 3]);

gamma_1 = mean(mean_powspctrm(:, index_gamma, index_time_1),[2 3]);
gamma_2 = mean(mean_powspctrm(:, index_gamma, index_time_2),[2 3]);
gamma_3 = mean(mean_powspctrm(:, index_gamma, index_time_3),[2 3]);
gamma_4 = mean(mean_powspctrm(:, index_gamma, index_time_4),[2 3]);

TFR_mean = zeros(64, 5, 4);
TFR_mean(:,1,:) = [theta_1, theta_2, theta_3, theta_4];
TFR_mean(:,2,:) = [delta_1, delta_2, delta_3, delta_4];
TFR_mean(:,3,:) = [alpha_1, alpha_2, alpha_3, alpha_4];
TFR_mean(:,4,:) = [beta_1,  beta_2,  beta_3,  beta_4 ];
TFR_mean(:,5,:) = [gamma_1, gamma_2, gamma_3, gamma_4];

