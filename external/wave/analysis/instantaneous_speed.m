function [s] = instantaneous_speed( wt, pm )
% *WAVE*
%
% INSTANTANEOUS SPEED     makes the instantaneous speed measurement
%                           via the analytic signal framework
%
% INPUT
% wt - instantaneous frequency datacube (r,c,t)
% pm - phase gradient magnitude datacube (r,c,t)
%
% OUTPUT
% s - instantaneous speed estimate
%

assert( ( ndims(wt) == 3 ) & ( ndims(pm) == 3 ), 'datacube inputs required' );
assert( isequal( size(wt), size(pm) ), 'datacube sizes must be equal' );

s = wt ./ abs(pm);