clear;clc;
load('data2.mat')
load('stat_30_2_8.mat')
% load('stat_30_2_4_1s.mat')
% load('stat_30_4_8_1s.mat')

% load('freq2grand_30_1s.mat')
load('freq4grand_30_1s.mat')
load('freq8grand_30_1s.mat')
freq2grand.powspctrm = freq2grand.powspctrm -freq8grand.powspctrm;


index = zeros(size(stat.posclusterslabelmat));
pow = freq2grand.powspctrm;
for i = 1 : 65
    for j = 1 : 29
        for k = 1 : 451 % 151¡¢201¡¢251¡¢451
            if stat.posclusterslabelmat(i,j,k)==0
                pow(:,i,j,k) = 0;
            end
        end
    end
end

freq2grand.powspctrm = pow;

cfg=[];
cfg.colorbar ='yes';
cfg.zlim=[-1.5 1.5];
freq2grand.elec = data2.elec;
fre2grand.fsample = data2.fsample;
figure;ft_multiplotTFR(cfg,freq2grand);