%% Between-trial experiments

%% 01.Preprocessing
% Leadfield Matrix calculation
% https://zhuanlan.zhihu.com/p/483052689
clear;clc;eeglab
% ¶ÁÈ¡ICAÎÄ¼þ
filepath = 'D:\MATLAB\TF_data\3reject.set';
EEG = pop_loadset('filename', '3reject.set','filepath','D:\\MATLAB\\TF_data\\');
EEG = eeg_checkset( EEG );
dataPre = eeglab2fieldtrip(EEG, 'preprocessing');   % convert the EEG data structure to fieldtrip
%% 02.Reading in the data
cfg                         = [];
cfg.dataset                 = 'Subject01.ds';
cfg.trialfun                = 'ft_trialfun_general'; % this is the default
cfg.trialdef.eventtype      = 'backpanel trigger';
cfg.trialdef.eventvalue     = [3 5 9]; % the values of the stimulus trigger for the three conditions
% 3 = fully incongruent (FIC), 5 = initially congruent (IC), 9 = fully congruent (FC)
cfg.trialdef.prestim        = 1; % in seconds
cfg.trialdef.poststim       = 2; % in seconds

cfg = ft_definetrial(cfg);
%% 03.Cleaning
% remove the trials that have artifacts from the trl
cfg.trl([2, 5, 6, 8, 9, 10, 12, 39, 43, 46, 49, 52, 58, 84, 102, 107, 114, 115, 116, 119, 121, 123, 126, 127, 128, 133, 137, 143, 144, 147, 149, 158, 181, 229, 230, 233, 241, 243, 245, 250, 254, 260],:) = [];


% preprocess the data
cfg.channel   = {'MEG', '-MLP31', '-MLO12'};        % read all MEG channels except MLP31 and MLO12
cfg.demean    = 'yes';                              % do baseline correction with the complete trial

data_all = ft_preprocessing(cfg);

cfg = [];
cfg.trials = data_all.trialinfo == 3;
dataFIC = ft_redefinetrial(cfg, data_all);

cfg = [];
cfg.trials = data_all.trialinfo == 9;
dataFC = ft_redefinetrial(cfg, data_all);

save dataFIC dataFIC
save dataFC dataFC
%% 04.Calculation of the planar gradient and time-frequency analysis
load dataFIC
load dataFC

cfg = [];
cfg.planarmethod = 'sincos';
% prepare_neighbours determines with what sensors the planar gradient is computed
cfg_neighb.method = 'distance';
cfg.neighbours    = ft_prepare_neighbours(cfg_neighb, dataFC);

dataFIC_planar = ft_megplanar(cfg, dataFIC);
dataFC_planar  = ft_megplanar(cfg, dataFC);

cfg = [];
cfg.output     = 'pow';
cfg.channel    = 'MEG';
cfg.method     = 'mtmconvol';
cfg.taper      = 'hanning';
cfg.foi        = 20;
cfg.toi        = [-1:0.05:2.0];
cfg.t_ftimwin  = 7./cfg.foi; %7 cycles
cfg.keeptrials = 'yes';

freqFIC_planar = ft_freqanalysis(cfg, dataFIC_planar);
freqFC_planar  = ft_freqanalysis(cfg, dataFC_planar);

cfg = [];
freqFIC_planar_cmb = ft_combineplanar(cfg, freqFIC_planar);
freqFC_planar_cmb = ft_combineplanar(cfg, freqFC_planar);

freqFIC_planar_cmb.grad = dataFIC.grad
freqFC_planar_cmb.grad = dataFC.grad

save freqFIC_planar_cmb freqFIC_planar_cmb
save freqFC_planar_cmb  freqFC_planar_cmb
%% 05.Permutation test
load freqFIC_planar_cmb
load freqFC_planar_cmb

cfg = [];
cfg.channel          = {'MEG', '-MLP31', '-MLO12'};
cfg.latency          = 'all';
cfg.frequency        = 20;
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
cfg.neighbours       = ft_prepare_neighbours(cfg_neighb, dataFC);

design = zeros(1,size(freqFIC_planar_cmb.powspctrm,1) + size(freqFC_planar_cmb.powspctrm,1));
design(1,1:size(freqFIC_planar_cmb.powspctrm,1)) = 1;
design(1,(size(freqFIC_planar_cmb.powspctrm,1)+1):(size(freqFIC_planar_cmb.powspctrm,1)+...
size(freqFC_planar_cmb.powspctrm,1))) = 2;

cfg.design           = design;
cfg.ivar             = 1;

[stat] = ft_freqstatistics(cfg, freqFIC_planar_cmb, freqFC_planar_cmb);

save stat_freq_planar_FICvsFC stat
%% 06.Plotting the results
load stat_freq_planar_FICvsFC

cfg = [];
freqFIC_planar_cmb = ft_freqdescriptives(cfg, freqFIC_planar_cmb);
freqFC_planar_cmb  = ft_freqdescriptives(cfg, freqFC_planar_cmb);

stat.raweffect = freqFIC_planar_cmb.powspctrm - freqFC_planar_cmb.powspctrm;

cfg = [];
cfg.alpha  = 0.025;
cfg.parameter = 'raweffect';
cfg.zlim   = [-1e-27 1e-27];
cfg.layout = 'CTF151_helmet.mat';
ft_clusterplot(cfg, stat);