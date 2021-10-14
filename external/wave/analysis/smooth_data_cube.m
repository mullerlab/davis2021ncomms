function [xo] = smooth_data_cube( x, sigma, type )
% *WAVE*
%
% SMOOTH DATA MATRIX     smooth each time slice of an input data cube
%                           in two dimensions
%
%                        works as a wrapper function for SMOOTH DATA MATRIX
%
% INPUT:
% x - data cube (r,c,t)
% sigma - smoothing parameter
%
% OUTPUT
% xo - smoothed data cube
%

assert( ndims(x) == 3, 'data cube input required' );
assert( nargin < 4, 'too many inputs' );
xo = zeros(size(x));

if nargin < 3
    for ii = 1:size(x,3);
        xo(:,:,ii) = smooth_data_matrix( x(:,:,ii), sigma );
    end
elseif nargin == 3
    for ii = 1:size(x,3);
        xo(:,:,ii) = smooth_data_matrix( x(:,:,ii), sigma, type );
    end
end