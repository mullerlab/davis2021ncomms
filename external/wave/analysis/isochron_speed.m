function [sp] = isochron_speed( pl, pixel_spacing, speed_cutoff )
% *WAVE*
%
% ISOCHRON SPEED      makes the speed distribution from the phase
%                       latency map
%                          
% INPUT
% pl - phase latency map (r,c)
%
% OUTPUT
% sp - speed distribution
%

sp = pixel_spacing ./ gradient(pl);
sp = abs(sp);
sp(sp>speed_cutoff) = 0;
sp(~isfinite(sp)) = [];
sp(sp == 0) = [];