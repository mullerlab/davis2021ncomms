function [sp] = speed_distribution_phase_latency( pl, pixel_spacing, speed_threshold )
% *WAVE*
%
% SPEED DISTRIBUTION PHASE LATENCY     forms the speed distribution from
%                                           the smoothed phase latency map
%
% INPUT
% pl - phase latency map (r,c)
% pixel_spacing - distance between pixel centers
% speed_threshold - cutoff speed threshold
%
% OUTPUT
% sp - speed distribution (1d - flattened)
%

assert( ndims(pl) == 2, 'data matrix input required' )

sp = pixel_spacing ./ gradient(pl);
sp = abs(sp);
sp( sp > speed_threshold ) = 0;
sp( sp == 0 ) = [];
sp = sp(:); 
