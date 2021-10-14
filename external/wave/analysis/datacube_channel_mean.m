function [xo] = datacube_channel_mean( x )
% *WAVE*
%
% DATACUBE CHANNEL MEAN         flattenes a datacube into a two-dimensional
%                                   matrix and takes the mean down the
%                                   rows, after removing NaN rows.
%
% INPUT
% x - datacube (r,c,t)
%
% OUTPUT
% xo - mean channel (t) 
%

assert( ndims(x) == 3, 'datacube input required' )

x = reshape( x, [size(x,1)*size(x,2) size(x,3)] );
x = x(~any(isnan(x),2),:);
xo = mean( x, 1 );