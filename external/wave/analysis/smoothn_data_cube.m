function [xo] = smoothn_data_cube( x, varargin )
% *WAVE*
%
% SMOOTHN DATA CUBE     fully automated smoothing for
%                          data cubes, taking each time
%                          slice into account, one at a
%                          time
%
% INPUT
% x - datacube input (r,c,t)
% mask - binary mask (r,c)
%
% OUTPUT
% xo - smoothed output (r,c,t)
%

assert( ndims(x) == 3, 'data cube input required' );

if strcmp( varargin{1}, 'robust' );robust_flag=1;else;robust_flag=0;end %#ok<NOSEM>

% init
xo = zeros(size(x));

% process
if robust_flag
    parfor ii = 1:size(x,3)
        xo(:,:,ii) = smoothn( x(:,:,ii), .5, 'robust' );
    end
elseif ~robust_flag
    parfor ii = 1:size(x,3)
        xo(:,:,ii) = smoothn( x(:,:,ii) );
    end    
end
