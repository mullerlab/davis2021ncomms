% *WAVE*
%
% VECTOR PHASE LATENCY NPOINT TEST     do we capture the correct times for the
%                                            2pi crossings in a test case?
%

clear all
clc

Fs = 100; % Hz
T = 1; % s 

xf = generate_sin( 1/Fs, T, 10 );
xf = hilbert( xf );
wt = vector_instantaneous_frequency( xf, Fs );

plot( (1/Fs):(1/Fs):T, real(xf), 'b' )
hold on;plot( (1/Fs):(1/Fs):T, angle(xf), 'r' )

pl = vector_phase_latency_npoint( xf, wt, Fs, 1 );
plot( pl, ones(1,length(pl)), 'g*' );
