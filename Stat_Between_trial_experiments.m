%% Between-trial experiments

%% 01.Preprocessing
% Leadfield Matrix calculation
% https://zhuanlan.zhihu.com/p/483052689
clear;clc;eeglab
% 读取ICA文件
filename = '3reject.set';
filepath = ['D:\MATLAB\TF_data\' filename];
EEG = pop_loadset('filename', filename,'filepath','D:\\MATLAB\\TF_data\\');
EEG = eeg_checkset( EEG );
dataPre = eeglab2fieldtrip(EEG, 'preprocessing');   % convert the EEG data structure to fieldtrip
save dataPre dataPre
%% 02.Reading in the data
cfg                         = [];
cfg.dataset                 = filepath;
cfg.trialfun                = 'ft_trialfun_general'; % this is the default
cfg.trialdef.prestim        = -0.5; % in seconds
cfg.trialdef.poststim       = 4; % in seconds

cfg = ft_definetrial(cfg);
%% 03.Cleaning
% remove the trials that have artifacts from the trl
load('rejects_30.mat');
load('events_30.mat');
reject = rejects_30(1, 1: 288);
index0 = (reject == 0); % 保留项目
index2 = dataPre.trialinfo.type == 2;
index4 = dataPre.trialinfo.type == 4;
index8 = dataPre.trialinfo.type == 8;

cfg = [];
cfg.trials = index0' & index2;
data2 = ft_redefinetrial(cfg, dataPre);

cfg = [];
cfg.trials = index0' & index4;
data4 = ft_redefinetrial(cfg, dataPre);

cfg = [];
cfg.trials = index0' & index8;
data8 = ft_redefinetrial(cfg, dataPre);

save data2 data2
save data4 data4
save data8 data8
%% 04.Calculation of the planar gradient and time-frequency analysis
% Calculation of the planar gradient is too early here.

%%

cfg = [];
cfg.output     = 'pow';
cfg.channel    = [];
cfg.method     = 'mtmconvol';
cfg.taper      = 'hanning';
cfg.foi          = 2:1:30;                         % analysis 2 to 30 Hz in steps of 1 Hz
% cfg.foi          = frequency;
cfg.t_ftimwin    =ones(length(cfg.foi),1).*0.4;   % length of time window = 0.4 sec
cfg.toi          = -0.5:0.01:4;                  % time window "slides" from -0.5 to 4.0 sec in steps of 0.01 sec (10 ms)
cfg.keeptrials = 'yes';

freq2 = ft_freqanalysis(cfg, data2);
freq4 = ft_freqanalysis(cfg, data4);
freq8 = ft_freqanalysis(cfg, data8);

save freq2 freq2
save freq8 freq8 
save freq4 freq4
%% 05.Permutation test
load ('freq2.mat')
load ('freq8.mat')

cfg = [];
cfg.channel          = [];           % channel
cfg.latency          = 'all';        % time
cfg.frequency        = [2 30];     % freq
cfg.method           = 'montecarlo';
cfg.statistic        = 'ft_statfun_indepsamplesT';
cfg.correctm         = 'cluster';
cfg.clusteralpha     = 0.05;
cfg.clusterstatistic = 'maxsum';
cfg.minnbchan        = 2;
cfg.tail             = 0;
cfg.clustertail      = 0;
cfg.alpha            = 0.025;
cfg.numrandomization = 500;
% prepare_neighbours determines what sensors may form clusters
cfg_neighb.method    = 'distance';
cfg.neighbours       = ft_prepare_neighbours(cfg_neighb, data8);

design = zeros(1,size(freq2.powspctrm,1) + size(freq8.powspctrm,1));
design(1,1:size(freq2.powspctrm,1)) = 1;
design(1,(size(freq2.powspctrm,1)+1):(size(freq2.powspctrm,1)+...
size(freq8.powspctrm,1))) = 2;

cfg.design           = design;
cfg.ivar             = 1;

[stat] = ft_freqstatistics(cfg, freq2, freq8);

save stat_freq_planar_2vs8 stat
%% 06.Plotting the results
% load stat_freq_planar_2vs8
load('stat_freq_planar_2vs8.mat')

cfg = [];
freq2 = ft_freqdescriptives(cfg, freq2);
freq8  = ft_freqdescriptives(cfg, freq8);

stat.raweffect = freq2.powspctrm - freq8.powspctrm;

cfg = [];
cfg.alpha  = 0.025;
cfg.parameter = 'raweffect';
cfg.zlim   = [-1e-27 1e-27];
cfg.layout = 'standard_1020.elc';
ft_clusterplot(cfg, stat);