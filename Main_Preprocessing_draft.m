clear;clc;
eeglab
rawpath = 'E:\Jiang in 2022\TF in aes\TF_data\00.cntdata_other';
cd(rawpath)
D= dir('*.cnt');
for i = 66
    %% 1~6
    % 首先将数据降采样至250hz
    %1 load raw data and resample cnt to 250 Hz
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    EEG = pop_loadcnt(strcat(rawpath,'\', num2str(i),'.cnt'), 'dataformat', 'auto', 'memmapfile', '');
    EEG = eeg_checkset( EEG );
    EEG = pop_resample( EEG, 250);
    EEG = eeg_checkset( EEG );
     
%     %2 loadchannelcap
%     [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname','S999file','gui','off'); 
%     EEG=pop_chanedit(EEG, 'lookup','D:\\Program Files\\MATLAB\\R2018b\\toolbox\\eeglab\\eeglab2020_0\\plugins\\dipfit\\standard_BESA\\standard-10-5-cap385.elp');
%     
    % 并对数据进行重定位，参考点为左右乳突的平均值
    %3 re-reference refere to M2 (as online reference is M1)???????????
     [ALLEEG EEG CURRENTSET] = eeg_store(ALLEEG, EEG, CURRENTSET);
     EEG = pop_reref( EEG, [33 43] ); % ?
     % EEG = pop_eegchanoperator( EEG, {  'nch1 = ch1 - ( ch43/2 ) Label FP1',  'nch2 = ch2 - ( ch43/2 ) Label FPZ',  'nch3 = ch3 - ( ch43/2 ) Label FP2',  'nch4 = ch4 - ( ch43/2 ) Label AF3',  'nch5 = ch5 - ( ch43/2 ) Label AF4',  'nch6 = ch6 - ( ch43/2 ) Label F7',  'nch7 = ch7 - ( ch43/2 ) Label F5',  'nch8 = ch8 - ( ch43/2 ) Label F3',  'nch9 = ch9 - ( ch43/2 ) Label F1',  'nch10 = ch10 - ( ch43/2 ) Label FZ',  'nch11 = ch11 - ( ch43/2 ) Label F2',  'nch12 = ch12 - ( ch43/2 ) Label F4',  'nch13 = ch13 - ( ch43/2 ) Label F6',  'nch14 = ch14 - ( ch43/2 ) Label F8',  'nch15 = ch15 - ( ch43/2 ) Label FT7',  'nch16 = ch16 - ( ch43/2 ) Label FC5',  'nch17 = ch17 - ( ch43/2 ) Label FC3',  'nch18 = ch18 - ( ch43/2 ) Label FC1',  'nch19 = ch19 - ( ch43/2 ) Label FCZ',  'nch20 = ch20 - ( ch43/2 ) Label FC2',  'nch21 = ch21 - ( ch43/2 ) Label FC4',  'nch22 = ch22 - ( ch43/2 ) Label FC6',  'nch23 = ch23 - ( ch43/2 ) Label FT8',  'nch24 = ch24 - ( ch43/2 ) Label T7',  'nch25 = ch25 - ( ch43/2 ) Label C5',  'nch26 = ch26 - ( ch43/2 ) Label C3',  'nch27 = ch27 - ( ch43/2 ) Label C1',  'nch28 = ch28 - ( ch43/2 ) Label CZ',  'nch29 = ch29 - ( ch43/2 ) Label C2',  'nch30 = ch30 - ( ch43/2 ) Label C4',  'nch31 = ch31 - ( ch43/2 ) Label C6',  'nch32 = ch32 - ( ch43/2 ) Label T8',  'nch33 = ch33 - ( ch43/2 ) Label M1',  'nch34 = ch34 - ( ch43/2 ) Label TP7',  'nch35 = ch35 - ( ch43/2 ) Label CP5',  'nch36 = ch36 - ( ch43/2 ) Label CP3',  'nch37 = ch37 - ( ch43/2 ) Label CP1',  'nch38 = ch38 - ( ch43/2 ) Label CPZ',  'nch39 = ch39 - ( ch43/2 ) Label CP2',  'nch40 = ch40 - ( ch43/2 ) Label CP4',  'nch41 = ch41 - ( ch43/2 ) Label CP6',  'nch42 = ch42 - ( ch43/2 ) Label TP8',  'nch43 = ch43 - ( ch43/2 ) Label M2',  'nch44 = ch44 - ( ch43/2 ) Label P7',  'nch45 = ch45 - ( ch43/2 ) Label P5',  'nch46 = ch46 - ( ch43/2 ) Label P3',  'nch47 = ch47 - ( ch43/2 ) Label P1',  'nch48 = ch48 - ( ch43/2 ) Label PZ',  'nch49 = ch49 - ( ch43/2 ) Label P2',  'nch50 = ch50 - ( ch43/2 ) Label P4',  'nch51 = ch51 - ( ch43/2 ) Label P6',  'nch52 = ch52 - ( ch43/2 ) Label P8',  'nch53 = ch53 - ( ch43/2 ) Label PO7',  'nch54 = ch54 - ( ch43/2 ) Label PO5',  'nch55 = ch55 - ( ch43/2 ) Label PO3',  'nch56 = ch56 - ( ch43/2 ) Label POZ',  'nch57 = ch57 - ( ch43/2 ) Label PO4',  'nch58 = ch58 - ( ch43/2 ) Label PO6',  'nch59 = ch59 - ( ch43/2 ) Label PO8',  'nch60 = ch60 - ( ch43/2 ) Label CB1',  'nch61 = ch61 - ( ch43/2 ) Label O1',  'nch62 = ch62 - ( ch43/2 ) Label OZ',  'nch63 = ch63 - ( ch43/2 ) Label O2',  'nch64 = ch64 - ( ch43/2 ) Label CB2',  'nch65 = ch65 Label HEO',  'nch66 = ch66 Label VEO'} , 'ErrorMsg', 'popup', 'Warning', 'on' ); % GUI: 21-Jan-2021 20:48:56
     EEG = eeg_checkset( EEG );
    
     % 随后使用零相位FIR滤波器对数据进行滤波，其中高通阈限为1Hz，低通滤波阈限为100Hz，并进行凹陷滤波（48-52Hz）
    %4 filtering (0.1-100Hz) 滤波
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    EEG = eeg_checkset( EEG );
    EEG = pop_eegfiltnew(EEG, 'locutoff',52,'hicutoff',48,'revfilt',1,'plotfreqz',0);
    % EEG  = pop_basicfilter( EEG,  1:65 , 'Boundary', 'boundary', 'Cutoff', [ 0.1 100], 'Design', 'butter', 'Filter', 'bandpass', 'Order',  4 ); % GUI: 12-Apr-2021 14:23:11
    EEG = eeg_checkset( EEG );
    
    %5 delete M1
     EEG = pop_select( EEG, 'nochannel',{'M1'});
     EEG = eeg_checkset( EEG );
    
    %6 creat binlist
%      [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
%     EEG  = pop_editeventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99}, 'BoundaryString', { 'boundary' }, 'List', 'E:\Jiang in 2022\TF in aes\eventlistorg.txt', 'SendEL2', 'EEG', 'UpdateEEG', 'askUser', 'Warning', 'on' ); % GUI: 19-Jan-2021 17:21:36
%     [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 4,'gui','off'); 
%     EEG  = pop_binlister( EEG , 'BDF', 'E:\Jiang in 2022\TF in aes\binlist.txt', 'IndexEL',  1, 'SendEL2', 'EEG', 'UpdateEEG', 'on', 'Voutput', 'EEG' ); % GUI: 19-Jan-2021 17:21:48
     
    %saveset
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset( EEG, 'filename',strcat(num2str(i),'beforeICA.set'), 'filepath','E:\Jiang in 2022\TF in aes\TF_data\01.before_ICA');
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    eeglab redraw;
    
    %% 通过人工检查，识别坏导，并使用spherical的方式对数据进行插值替代。
    
    %% ICA 随后使用ICLable识别伪迹，删除90%以上可能为眼电、肌电、心电的成分，并对数据进行矫正
    %load ICA data
    EEG = pop_loadset('filename', strcat(num2str(i), 'epoch.set'), 'filepath', rawpath);
    EEG = eeg_checkset( EEG );
    
    %run ICA
    EEG = pop_runica(EEG, 'extended',1,'pca',50,'interupt','on');
    
    %save ICA data
    EEG = pop_saveset( EEG, 'filename',strcat(num2str(i),'epochICA.set'), 'filepath','G:\审美脑电实验数据\脑电数据\数据分析\V2\other\2.3.2epoch_ICA');
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    eeglab redraw;
    
    %load channel location
    EEG = pop_chanedit(EEG, 'lookup','D:\\Program Files\\MATLAB\\R2018b\\toolbox\\eeglab\\eeglab2020_0\\plugins\\dipfit\\standard_BESA\\standard-10-5-cap385.elp');
 
    %lable and flag ICA then delet
    % 随后使用ICLable识别伪迹，删除90%以上可能为眼电、肌电、心电的成分，并对数据进行矫正
    EEG = pop_iclabel(EEG, 'default');
    EEG = pop_icflag(EEG, [NaN NaN;0.9 1;0.9 1;NaN NaN;NaN NaN;NaN NaN;NaN NaN]);
    EEG = pop_subcomp( EEG, [ ], 0);
    
    %save ICA data
    EEG = pop_saveset( EEG, 'filename',strcat(num2str(i),'epoch_cleanICA.set'), 'filepath','G:\审美脑电实验数据\脑电数据\数据分析\V2\other\2.3.3epoch_clean_ICA');
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    eeglab redraw;
    
    %% epoch
    %load before ICA data
    EEG = pop_loadset('filename', strcat(num2str(i), 'beforeICA.set'), 'filepath', rawpath);
    EEG = eeg_checkset( EEG );
    
    % epoch [-200 800]
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    EEG = pop_epochbin( EEG , [-200.0  800.0],  'pre'); % GUI: 19-Jan-2021 17:22:30
    
    %save epoch data
    EEG = pop_saveset( EEG, 'filename',strcat(num2str(i),'epoch.set'), 'filepath','G:\审美脑电实验数据\脑电数据\数据分析\V2\other\2.3.1epoch');
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    eeglab redraw;
    %% 7~10
    %load before ICA data
    EEG = pop_loadset('filename', strcat(num2str(i), 'epoch_cleanICA.set'), 'filepath', rawpath);
    EEG = eeg_checkset( EEG );
    
    %7 epoch [-200 800]
    % 随后，将数据分段（截取刺激呈现前500ms（基线）至刺激呈现后4000ms），以便人工检查标记并删除其幅值超过±150μv的伪迹试次。
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    EEG = pop_epochbin( EEG , [-200.0  800.0],  'pre'); % GUI: 19-Jan-2021 17:22:30

    %8 artifact detection by simple threshold:
    EEG  = pop_artextval( EEG , 'Channel', [64 65], 'Flag', [1 6], 'Threshold', [ -100 100], 'Twindow',[ -200 799] );
    EEG.setname = [EEG.setname '_ar'];
    EEG         = pop_saveset(EEG, 'filename', [EEG.setname '.set'], 'filepath', rawpath);
    EEG         = pop_exporteegeventlist(EEG, 'Filename', strcat(num2str(i), '_eventlist_ar.txt'));

    %9 Report percentage of rejected trials (collapsed across all bins)
    artifact_proportion = getardetection(EEG);
    fprintf('%s: Percentage of rejected trials was %1.2f\n', strcat(num2str(i), artifact_proportion));    
    EEG         = pop_summary_AR_eeg_detection(EEG, strcat(rawpath,'\', num2str(i),'ARperc.txt'));
    
    %10 save erp   
    ERP = pop_averager( EEG , 'Criterion', 'good', 'DQ_flag', 1, 'ExcludeBoundary', 'on', 'SEM', 'on' );
    ERP = pop_savemyerp(ERP, 'erpname', num2str(i), 'filename', strcat(num2str(i), 're.erp'), 'filepath', 'G:\审美脑电实验数据\脑电数据\数据分析\V2\other\4.1epoch_ICA_ERP', 'warning', 'off');
    
    
end