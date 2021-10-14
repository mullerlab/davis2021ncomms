% *WAVE*
%
% VECTOR PHASE LATENCY TEST     do we capture the correct times for the
%                                   2pi crossings in a test case?
%

Fs = 1000; % Hz
T = 1; % s 

%xf = generate_chirp( 1/Fs, T, 10, 20 );
xf = generate_sin( 1/Fs, T, 10 );
xf = hilbert( xf );
wt = vector_instantaneous_frequency( xf, Fs );

plot( (1/Fs):(1/Fs):T, real(xf), 'b' )
hold on;plot( (1/Fs):(1/Fs):T, angle(xf), 'r' )

for ii = 1:900
    pl = vector_phase_latency( xf, wt, Fs, ii );
    if ~isempty(pl); plot( pl, 1, 'g*' ); end
end
