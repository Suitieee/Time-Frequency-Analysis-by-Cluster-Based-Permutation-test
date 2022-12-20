clear;clc;eeglab
datapath = 'E:\Jiang in 2022\TF in aes\TF_data\';
load('subj_30.mat'); % subj_30
subj = subj_30;
subj_num = length(subj);

for i = 6 : subj_num
    i
    subj_id = num2str(subj(i));
    
    %% before_ICA
    EEG.etc.eeglabvers = '2020.0'; % this tracks which version of EEGLAB is being used, you may ignore it
    EEG = pop_loadcnt([datapath '00.cntdata_other\' subj_id '.cnt'] , 'dataformat', 'auto', 'memmapfile', '');
    EEG = eeg_checkset( EEG );

    EEG=pop_chanedit(EEG, 'lookup','D:\\Program Files\\MATLAB\\R2018b\\toolbox\\eeglab\\eeglab2020_0\\plugins\\dipfit4.3\\standard_BESA\\standard-10-5-cap385.elp');
    EEG = eeg_checkset( EEG );
    
    % 01.降采样，1000Hz to 250Hz
    % 降采样可能会带来一些频域混叠？https://www.zhihu.com/question/23474073?sort=created
    EEG = pop_resample( EEG, 250); % 降采样 250Hz
    EEG = eeg_checkset( EEG );

    % 02.重参考
    EEG = pop_reref( EEG, 43 ); % 重参考M2
    EEG = eeg_checkset( EEG );

    % 03_1.带通滤波0.01-100Hz
    EEG = pop_eegfiltnew(EEG, 'locutoff',0.01,'hicutoff',100); % 带通滤波0.01-100Hz
    EEG = eeg_checkset( EEG );

    % 03_2.凹陷滤波48-52Hz
    EEG = pop_eegfiltnew(EEG, 'locutoff',48,'hicutoff',52,'revfilt',1); % 凹陷滤波48-52Hz
    EEG = eeg_checkset( EEG );

    % 存储before_ICA的文件
    EEG = pop_saveset( EEG, 'filename',[subj_id 'beforeICA.set'],'filepath','E:\\Jiang in 2022\\TF in aes\\TF_data\\01.before_ICA\\');
    EEG = eeg_checkset( EEG );
    
    %% ICA
    % 04.ICA,生成50个成分
    EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1,'pca',50,'interrupt','on');% ICA
    EEG = eeg_checkset( EEG );

    EEG = pop_saveset( EEG, 'filename',[subj_id 'ICA.set'],'filepath','E:\\Jiang in 2022\\TF in aes\\TF_data\\01.ICA\\');% 存储ICA
    EEG = eeg_checkset( EEG );
end

for i = 1  : subj_num
    i
    subj_id = num2str(subj(i));
    %% after_ICA
    % 读取ICA文件
    EEG = pop_loadset('filename',[subj_id 'ICA.set'],'filepath','E:\\Jiang in 2022\\TF in aes\\TF_data\\01.ICA\\');
    EEG = eeg_checkset( EEG );
    
    % 05.标记超过90%的心电、肌电和眼电的成分
    EEG = pop_iclabel(EEG, 'default');
    EEG = eeg_checkset( EEG );

    EEG = pop_icflag(EEG, [NaN NaN;0.9 1;0.9 1;0.9 1;NaN NaN;NaN NaN;NaN NaN]);
    EEG = eeg_checkset( EEG );
    
    % 06.将这些flag的伪迹成分置空
    EEG = pop_subcomp( EEG, [ ], 0); % 待确认
    EEG.setname='afterICA';
    EEG = eeg_checkset( EEG );
    
    % 存储after_ICA文件
    EEG = pop_saveset( EEG, 'filename',[subj_id 'afterICA.set'],'filepath','E:\\Jiang in 2022\\TF in aes\\TF_data\\01.after_ICA\\');% 存储ICA
    EEG = eeg_checkset( EEG );
    
    %% epoch
    % 07.epoch[-0.5 4]的事件
    EEG = pop_epoch( EEG, {  }, [-0.5           4], 'newname', 'afterICA epochs', 'epochinfo', 'yes');
    EEG = eeg_checkset( EEG );
    
    % 08.对[-500 0]进行基线校正
    EEG = pop_rmbase( EEG, [-500 0] ,[]);% 待确认 % 2 35 41
    EEG = eeg_checkset( EEG );

    % 存储epochs的文件
    EEG = pop_saveset( EEG, 'filename',[subj_id 'epoch.set'],'filepath','E:\\Jiang in 2022\\TF in aes\\TF_data\\01.epochs\\');% 存储ICA
    EEG = eeg_checkset( EEG );

    %% reject
    % 09.阈限坏段标记±150μV
    EEG = pop_eegthresh(EEG,1,[1:64] ,-150,150,-0.5,3.996,0,0);
    EEG = eeg_checkset( EEG );

    % 存储reject文件
    EEG = pop_saveset( EEG, 'filename',[subj_id 'reject.set'],'filepath','E:\\Jiang in 2022\\TF in aes\\TF_data\\01.reject\\');
    EEG = eeg_checkset( EEG );
end