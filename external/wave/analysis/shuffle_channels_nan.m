function [x] = shuffle_channels_nan( x )
% *WAVE*
%
% SHUFFLE CHANNELS NAN      randomizes the spatial position of channels in a
%                              datacube, so that any spatial autocorrelation
%                              is destroyed while leaving the temporal
%                              structure intact
%                              
%                              - avoids moving NaN's
%
% INPUT: 
% x - original datacube
%
% OUTPUT:
% x - output datacube, with channels shuffled in space
%

assert( ndims(x) >= 2, 'matrix/datacube input required' );

[d1,d2,d3] = size( x );

ind = find( ~isnan(x(:,:,1)) ); 
ind_perm = ind( randperm(length(ind)) );

x = reshape( x, d1*d2, d3 ); 
x( ind_perm, : ) = x( ind, : );
x = reshape( x, d1, d2, d3 );
