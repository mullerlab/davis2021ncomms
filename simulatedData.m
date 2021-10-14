clc; clearvars
addpath(genpath('./external'))

%% kword can equal one of the following character vectors:
% 
% 'random' - random network
% 
% 'topographic' - topographic network
% 
% 'sigmascan-x00um' - topographic network with Gaussian sigma corresponding
% to one of x = 2, 3, 4, 5, or 6
% 
% 'speedscan-0.xmps' - topographic network with conduction speed
% corresonding to one of x = 1, 2, 3, 4, 5, or 6
% 
% 'range' - topographic network with distribution of conduction speeds
% ranging from 0.1 to 0.6 m/s, and with 10% of topographic connections made
% random
% 
% 'figure7-sparse' or 'figure7-dense' - (respectively) topographic network
% with sparse or dense connectivity

%%
kword = 'figure7-dense';
paramfile = sprintf('./parameter-files/%s.parameters',kword);
outputdir = sprintf('./simulated-data/%s',kword);

%% binary source data are generated using the following command:
% runNetsim( pwd , paramfile , outputdir );

%% load binary data into matlab
[ vars, ids, times, vms, gis, ges ] = nsloaddata( paramfile , outputdir );

%% simulate z-scored lfp from lif data 
[lz,lz2,lz3] = nssimlfp( vars , vms , ges , gis );

%% exclude outer 1-mm perimeter (except for the smaller networks)
if ~startsWith(kword,'figure7')
    lz = lz( 15:74 , 15:74 , : ); 
end

%% instantaneous wavelengths and speeds
[wl,s] = waveAnalysis( lz , vars );
[wl_sh,s_sh] = waveAnalysis( shuffle_channels( lz ), vars ); % shuffled LFP input

%% note about coefficient of variation (CV) used in this paper:
% CV = stdev[ISI] / mean[ISI]

%% space-time FFT
A = nsfft(lz2);

%% phases of spikes relative to LFP
[spikePhase, randPhase, SPI, prefPhase] = NetsimSpikePhase( lz3 , ids , times , vars , [5 100] );

%%
rmpath(genpath('./external'))

%%
function [wl,s] = waveAnalysis(lz,vars)

% generalized phase
f1=5; f2=100; Fs=1000;
lz_bp = bandpass_filter(lz,f1,f2,4,Fs);
[xph,wt] = generalized_phase( lz_bp, Fs, f1 );

% phase gradient
pm = phase_gradient_complex_multiplication( xph, vars.L/size(xph,1), 1 );

% wavelength
wl = 1 ./ abs(pm) ;

% instantaneous speed
s = instantaneous_speed( wt , pm );

end



