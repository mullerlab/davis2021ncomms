%%%%%
%
% Phase Latency Correlation Test
% Lyle Muller
% 27 July 2012
%
%%%%%

noise_strength = .01;

xf = generate_2d_target_wave( 50, 100, .01, .1 );
xph = hilbert_transform( xf );
wt = instantaneous_frequency( xph, 100 );

pl = phase_latency( xph, wt, 100, 1 );
%pl = pl + randn(size(pl)).*noise_strength;  
%pl = randn(size(pl)).*noise_strength;       % just noise
[cc,pv,xx,yy,tm,speed] = phase_latency_correlation_distance( pl, 1 );

% plotting
imagesc(pl);
cb = colorbar;
cblabel( cb, '2pi Phase Latency' );
cbunits( cb, 's' );
hold on;plot(xx,yy,'w+')
title_str = sprintf('Phase latnecy correlation with distance: %.2f', cc);
title(title_str)
xlabel('Localized source marked with white dot')