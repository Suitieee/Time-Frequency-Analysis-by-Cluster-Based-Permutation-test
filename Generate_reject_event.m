clear;clc;eeglab
datapath = 'E:\Jiang in 2022\TF in aes\TF_data\';
% subj = load("cnt_name.txt");
% subj_num = length(subj);

load('subj_30.mat'); % subj_30
subj = subj_30;
subj_num = length(subj);
trial_num = 288;

rejects_30 = zeros(subj_num, trial_num);
events_30 = zeros(subj_num, trial_num);

%% 生成2维reject和event的mat文件
for i = 1 : subj_num
    i
    subj_id = num2str(subj(i));
    
    EEG = pop_loadset('filename',[subj_id 'reject.set'],'filepath','E:\\Jiang in 2022\\TF in aes\\TF_data\\01.reject\\');
    EEG = eeg_checkset( EEG );
    
    % reject循环赋值
    reject = EEG.reject.rejthresh;
    L_reject = length(reject);
    rejects_30(i, 1:L_reject) = reject;
    
    % event村换赋值
    event = {EEG.event.type};
    L_event = length(event);
    events_30(i, 1 : L_event) = cell2mat(event);
end


%% 记录所有数据的长度，部分不是288个试次
edge_reject = length(rejects_30(1,:));
edge_event = length(events_30(1,:));
for i = 1 : subj_num
    i
    subj_id = num2str(subj(i));
    
    EEG = pop_loadset('filename',[subj_id 'reject.set'],'filepath','E:\\Jiang in 2022\\TF in aes\\TF_data\\01.reject\\');
    EEG = eeg_checkset( EEG );
    
    reject = EEG.reject.rejthresh;
    L_reject = length(reject);
    rejects_30(i, edge_reject + 1) = L_reject;
        
    event = {EEG.event.type};
    L_event = length(event);
    rejects_30(i, edge_event + 1) = L_event;
end
save('rejects_30.mat', 'rejects_30');
save('events_30.mat', 'events_30');