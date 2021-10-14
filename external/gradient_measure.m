function [l,p,p2] = gradient_measure( lz, vars, Fs, pixel_spacing )
% NS1
%
% GRADIENT MEASURE
%
% INPUT
% lz - z-scored datacube (r,c,t)
% vars - NETSIM variablke structure
% Fs - sampling rate (Hz)
% pixel_spacing - spacing between points (m)
%
% OUTPUT
% l - mean wavelength (m)
% p - percentage of time points where wavelength > (L/2)
%

% compute GP, PG, and speed
xph =  analytic_signal( lz ); wt = instantaneous_frequency( xph, Fs );
xph_sh = analytic_signal(shuffle_channels(lz)); wt_sh = instantaneous_frequency(xph_sh,Fs);
pm = phase_gradient_complex_multiplication( xph, pixel_spacing, 1 );
[pm_sh,~] = phase_gradient_complex_multiplication( xph_sh, pixel_spacing, 1 );


% compute m and p
l = nanmean( 1./pm(:) );
p = sum( (1./pm(:)) > prctile(1./pm_sh(:),99) ) ./ numel( pm(:) );
p2 = sum( (1./pm(:)) > vars.sigma_space*3 ) ./ numel( pm(:) );