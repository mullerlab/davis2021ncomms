%%%%%
%
%  WAVE UNIT TEST: spatial_correlation()
%  Lyle Muller
%  18 November 2014
%
%%%%%

% parameters
bin_size = 1;
pixel_spacing = 1;
number_pairs = 100;

% generate test datacube
x = rand( 10, 10, 10000 );

[spcorr, dist] = ...
    spatial_correlation( x, bin_size, pixel_spacing, number_pairs );

% plotting 1
figure;hold on
plot( dist, spcorr, 'linewidth', 2 )
plot( dist, spcorr, 'b.', 'markersize', 20 )
ylim( [-.1 .1] );

