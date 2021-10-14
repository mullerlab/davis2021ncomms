%
% unit test: rectify_rotation()
% lyle muller
% 10 february 2015
%

clear all; clc %#ok<CLSCR>

% generate test data
a = generate_sin( .001, 1, 2 );
a = repmat( a, [100 1] );
a = reshape( a, 10, 10, [] );

% analytic signal + rectify
a = hilbert_transform( a );
a1 = rectify_rotation( a );

% plotting 1
figure; hold on; plot( reshape( angle(a), 100, [] )', 'k:' )
plot( reshape( angle(a1), 100, [] )' )

% plotting 2
figure; hold on; plot( reshape( real(a), 100, [] )', 'k.', 'markersize', .5 )
plot( reshape( real(a1), 100, [] )', 'r--' )
