addpath(genpath('./external'))

%% figure 6
clc; clearvars
load('./real-data/fig6/exData.mat') % rates and CVs
load( './real-data/fig6/ell_wolfie.mat' ) % wavelengths (m)
load( './real-data/fig6/wolfie-speed_density.mat' ) % speeds in m/s (k = normalized prob. density in arb. units)

%% figure 7
clc; clearvars
load('./real-data/fig7/spikePhase.mat')

%%
rmpath(genpath('./external'))
