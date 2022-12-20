clear;clc;
%%
cfg = [];
load('D:\MATLAB\TF_data\TFR\16freq2.mat');
freq2_1 = ft_freqdescriptives(cfg, freq2);
load('D:\MATLAB\TF_data\TFR\20freq2.mat');
freq2_2 = ft_freqdescriptives(cfg, freq2);
load('D:\MATLAB\TF_data\TFR\31freq2.mat');
freq2_3 = ft_freqdescriptives(cfg, freq2);

load('D:\MATLAB\TF_data\TFR\16freq8.mat');
freq8_1 = ft_freqdescriptives(cfg, freq8);
load('D:\MATLAB\TF_data\TFR\20freq8.mat');
freq8_2 = ft_freqdescriptives(cfg, freq8);
load('D:\MATLAB\TF_data\TFR\31freq8.mat');
freq8_3 = ft_freqdescriptives(cfg, freq8);

%%
cfg = [];
cfg.keepindividual = 'yes';
freq2grand = ft_freqgrandaverage(cfg, freq2_1, freq2_2, freq2_3);
freq8grand = ft_freqgrandaverage(cfg, freq8_1, freq8_2, freq8_3);

%%
cfg = [];
cfg.channel          = [];
cfg.latency          = 'all';
cfg.frequency        = [2 30];
cfg.method           = 'montecarlo';
cfg.statistic        = 'ft_statfun_depsamplesT';
cfg.correctm         = 'cluster';
cfg.clusteralpha     = 0.05;
cfg.clusterstatistic = 'maxsum';
cfg.minnbchan        = 2;
cfg.tail             = 0;
cfg.clustertail      = 0;
cfg.alpha            = 0.025;
cfg.numrandomization = 500;
% specifies with which sensors other sensors can form clusters
% cfg.method    = 'distance';
cfg_neighb.method    = 'distance';
freq2grand.elec = data2.elec;
fre2grand.fsample = data2.fsample;
cfg.neighbours       = ft_prepare_neighbours(cfg_neighb, freq2grand);

% design
subj = 3;
design = zeros(2,2*subj);
for i = 1:subj
  design(1,i) = i;
end
for i = 1:subj
  design(1,subj+i) = i;
end
design(2,1:subj)        = 1;
design(2,subj+1:2*subj) = 2;

cfg.design   = design;
cfg.uvar     = 1;
cfg.ivar     = 2;

%% 
[stat] = ft_freqstatistics(cfg, freq2grand, freq8grand);