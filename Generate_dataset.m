clear;clc;
load('rejects.mat');
subj = load("cnt_name.txt");
filepath = 'F:\Jiang in 2022\TF in aes\TFR_low\';

%% ɾ������288�Դεı���,ɸѡ��������ǰ30%�ı���
% �洢subj_30.mat��rejects_30.mat��events_30.mat
merge = [subj rejects];
column = length(merge(1, :));
merge(find(merge(:, column) ~= 288), :) = [];
merge(:, [288 + 2 : column]) = [];

% �ܾ���
subj_288 = merge(:, 1);
rejects_288 = merge(:, 2 : 289);
rejects_sum = sum(rejects_288, 2);
histogram(rejects_sum,25);
sum(rejects_sum < 58);

% ������
accepts = (288 - rejects_sum)/288;
histogram(accepts,25);
mean_accept = mean(accepts);
std_accept = std(accepts);

% top30 subj
accept_top30 = prctile(accepts, 69);
merge = [accepts subj_288];
merge(merge(:,1) < accept_top30, :) = [];
subj_30 = merge(:, 2);

% top30 reject
for i = 1 : 30
    index(i) = find(subj==subj_30(i));
end
rejects_30 = rejects(index, 1:288);
load('events.mat');
events_30 = events(index, 1:288);

save('rejects_30.mat', 'rejects_30');
save('subj_30.mat', 'subj_30');
save('events_30.mat', 'events_30');
    
%% TF��������ֵ��TFR_mean_30
markers = [2 4 8 16 32 64];
load('time.mat');% ��Ƶ��ʱ��߶�
load('freq_30.mat');% ��Ƶ��Ƶ�γ߶�
Freq_type = 'TFRhann'; % TFRhann��TFRmult

% TFR_mean_30������
TFR_mean_30 = zeros(30, 6, 64, 5, 4);
for subj_i = 1 : 30
    subj_id = num2str(subj_30(subj_i)); 
    for marker_i = 1 : 6
        marker = markers(marker_i); 
        filename = [filepath subj_id 'subj_' num2str(marker) 'marker_' Freq_type '.mat'];
        
        % size(TFRhann.powspctrm)=[72 64 29 451]trial_num channel_num freq_scale time_scale
        load(filename); % TFRhann��TFRmult
        powspctrm = TFRhann.powspctrm;
        
        index_event = find(events_30(subj_i, :) == marker); % �ҵ������marker�������Դε�λ��
        reject_event = rejects_30(subj_i, index_event); % �ҵ����λ���µ�reject����Ϣ
        reject_index = find(reject_event == 1);% �ҵ�reject��λ����Ϣ
        powspctrm(reject_index,:,:,:) = [];% ɾ��reject��TFR
        
        mean_powspctrm = squeeze(mean(powspctrm, 1));% ���Դ�ά����ƽ��������ά
        
        %% feature extraction and assign it
        TFR_mean = Extract_TFR_mean(mean_powspctrm, time, freq_30); % channel_num * freq_band * time_block 64 * 5 * 4
        TFR_mean_30(subj_i, marker_i, :, :, :) = TFR_mean;
    end
end

save('TFR_mean_30.mat', 'TFR_mean_30');

%% ����dataset 30 * 6 vs. 64 * 5 * 4��dataset��������2*3��ANOVA
dataset_2_3 = zeros(30 * 6, 64 * 5 * 4);
% size(TFR_mean_30) = [30, 6, 64, 5, 4];
for subj_i = 1 : 30
    for marker_i = 1 : 6
        left = 1;
        row = (subj_i - 1) * 6 + marker_i;
        for channel_i = 1 : 64
            for freq_i = 1 : 5
                target = TFR_mean_30(subj_i, marker_i, channel_i, freq_i, :);
                dataset_2_3(row, left : left + 3) = squeeze(target);
                left = left + 4;
            end
        end
    end
end

%% ����Excel��ͷ
save('dataset_2_3.mat', 'dataset_2_3');
header = [{ }];
freq_band = [{'theta'},{'delta'},{'alpha'},{'beta'},{'gamma'}];
o = 1;
for i = 1 : 64
    for j = 1 : 5
        for k = 1 : 4
            name = ['C' num2str(i) '_' char(freq_band(j)) num2str(k) ];
            header(o) = {name};
            o = o + 1;
        end
    end
end
xlswrite('header.xlsx', header);
xlswrite('dataset_2_3.xlsx', dataset_2_3);