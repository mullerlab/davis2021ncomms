% *WAVE*
%
% ISOCHRON MAP GAUSSIAN PULSE TEST SCRIPT - ADDITIVE NOISE
%
%   confirms the assertion that the phase latency correlation with distance
%       of a gaussian pulse (see generate_gaussian_pulse.m in /test/) is
%       not significant
%

clear all

[xf] = generate_gaussian_pulse( 50, .01, 1, 2, 1, 20 );
xf = xf + randn(size(xf))*.25;
xf = lowpass_filter( xf, 5, 4, 100 );

xph = hilbert_transform( xf );
wt = instantaneous_frequency( xph, 100 );
pl = phase_latency( xph, wt, 100, 25 );

[cc,pv,xx,yy,~,slope] = phase_latency_correlation_distance( pl, 1 );
