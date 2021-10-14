function [xo] = shuffle_circular( x, center )
% *WAVE*
%
% SHUFFLE CIRCULAR      randomizes the spatial position of channels in a
%                           datacube by rotation about a center point,
%                           such that all channels at distance R from the
%                           center are randomized in space
%
% INPUT: 
% x - original datacube
% center - center point
%
% OUTPUT:
% xo - output datacube, with channels shuffled in space
%

assert( ismatrix(x), 'matrix input required' );

% make matrix of distances from source
[X,Y] = meshgrid( (1:size(x,2))-center(1), (1:size(x,1))-center(2) );
[~,R] = cart2pol( X, Y );

xo = x;
for ii = 1:floor( max(R(:)) )
    ind = ( (R>=ii) & (R<(ii+1)) );
    tmp = xo( ind );
    xo(ind) = tmp( randperm(length(tmp)) );
end
