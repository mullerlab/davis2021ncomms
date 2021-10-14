function [xx] = half_width_half_max( xf, distances )
% *WAVE*
%
% HALF WIDTH HALF MAX (HWHM)     calculates the position of the half-width
%                                   half-max for a monotonically decreasing
%                                   sequence
%
% INPUT
% xf - input sequence (1d)
% distances - detector position vector (1d - must be evenly spaced)
%
% OUTPUT
% xx - position of the half-max (in units of distances)
%

assert( isvector( xf ), 'xf, vector input required' )
assert( isvector( distances ), 'distances, vector input required' )

% subtract the half-maximum value
xf = xf - (max(xf)/2);

% get exact zeros
ind0 = find( xf == 0 );
if ~isempty(ind0); xx = distances(ind0); return; end;

% else, get the crossing index
ind = find( ( xf(1:end-1) .* xf(2:end) ) < 0, 1, 'first' );

% assign the distance, with linear interpolation
xx = interp1( [xf(ind) xf(ind+1)], [distances(ind) distances(ind+1)], 0 );
