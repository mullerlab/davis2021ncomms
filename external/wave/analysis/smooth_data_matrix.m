function [xo] = smooth_data_matrix( x, sigma, type )
% *WAVE* 
%
% SMOOTH DATA MATRIX     smooth an input matrix in two dimensions
%
% INPUT: 
% x - data matrix (r,c)
% sigma - smoothing parameter
%
% OUTPUT
% xo - smoothed data matrix
%

assert( ndims(x) == 2, 'data matrix input required' );
assert( nargin < 4, 'too many inputs' );
xo = zeros(size(x));

% smoothing -- note the CEIL (7/3, LM)
hsize_scaling_with_sigma = 5;
gaussianFilter = fspecial( 'gaussian', ceil(sigma*hsize_scaling_with_sigma), sigma );

if nargin < 3
    xo = imfilter( x, gaussianFilter );
elseif strcmp( type, 'replicate' )
    xo = imfilter( x, gaussianFilter, 'replicate' );
end