function h = plot_power_spectral_density( x, Fs, window_function )
% *WAVE* 
%
% PLOT POWER SPECTRAL DENSITY     plot PSD from a single channel
%
% INPUT: 
% x - vector input (1,t)
% Fs - sampling frequency
% plot_option - linear or log y-scale (0/1, respectively)
%
% OUTPUT
% axis handle
%

assert( isvector( x ), 'vector input required' )

[Pxx,F] = periodogram( x, window_function, [], Fs, 'onesided' );

% plotting
h = plot( F, 10*log10(Pxx) ); grid on

ylabel( 'Power/frequency (dB/Hz)' )
title('Periodogram Power Spectral Density Estimate')
xlabel('Frequency (Hz)')
