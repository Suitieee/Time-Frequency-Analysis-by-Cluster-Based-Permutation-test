%% 生成被试预处理后的3维数据
clear;clc;eeglab
datapath = 'E:\Jiang in 2022\TF in aes\TF_data\';
subj = load("cnt_name.txt");
subj_num = length(subj);
trial_num = 288;
channel_num = 64;
times = 1125;

for i = 1 : subj_num

    i
    subj_id = num2str(subj(i));
    
    EEG = pop_loadset('filename',[subj_id 'reject.set'],'filepath','E:\\Jiang in 2022\\TF in aes\\TF_data\\01.reject\\');
    EEG = eeg_checkset( EEG );
    
    data = EEG.data;
    save([subj_id 'data.mat'], 'data');
    
end