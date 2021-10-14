%%%%%
%
% Phase Latency Scan Test
% Lyle Muller
% 4 June 2013 
%
%%%%%

clear all
clc

% parameters
Fs = 100;
pixel_spacing = 1;

% generate data
xf = generate_2d_target_wave( 5, Fs, .01, pi );
xph = hilbert_transform( xf );
wt = instantaneous_frequency( xph, Fs );

% phase latency scan
[pl,modulus,cc,pv,slope] = phase_latency_scan( xph, wt, Fs, pixel_spacing );

