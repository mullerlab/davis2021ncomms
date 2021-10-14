function [cc,pv,xx,yy,time_modulation,slope] = ...
                            phase_latency_distance_threshold( pl, spacing, threshold )
% *WAVE*
%
% PHASE LATENCY CORRELATION DISTANCE     makes the phase latency
%                                           correlation with distance,
%                                           given an input latency map
%                                           PL (bounded by a distance
%                                           threshold).
%
% INPUT
% pl - phase latency map (r,c)
% spacing - pixel spacing (sc)
% threshold - distance threshold
%
% OUTPUT
% cc - linear correlation coefficient, phase latency time w/ distance
% pv - p-value of the correlation
% xx - x-position of the phase-latency basin
% yy - y-position of the phase-latency basin
% time_modulationn - (max - min), of the smoothed phase latency map
% slope - speed taken from the slope of the regression line (latency
%                                                               w/dist.)
%

assert( ndims(pl) == 2, 'data matrix input required' )

% make NaN field, if necessary
nanfield = (pl == 0);

% add smoothing in before wave center guess!
%smooth_pl = smooth_data_matrix( pl, 5, 'replicate' );
pl(nanfield) = NaN;
smooth_pl = smoothn(pl,'robust');smooth_pl(nanfield) = NaN;
[yy,xx] = find( smooth_pl == min(min(smooth_pl)) );
assert( numel(yy) == 1, 'FIND returned several minima' );

% make matrix of distances from wave center
[r,c] = size(pl);
[X,Y] = meshgrid( (1:c)-xx, (1:r)-yy );
D = sqrt( X.^2 + Y.^2 );
D = D.*spacing;

% add in NaNs and flatten
pl(nanfield) = NaN;pl = pl(:);
D(nanfield) = NaN;D = D(:);

% kill the NaNs -- ADDED LYLE 3 DEC 2012
pl(isnan(pl)) = [];
D(isnan(D)) = [];

% time modulation
time_modulation = max(smooth_pl(:)) - min(smooth_pl(:));

% old regression analysis (phase latency corr w/dist) -- LYLE 3 DEC 2012
[cc,pv] = corr( D(D<threshold), pl(D<threshold), 'tail', 'right' );
slope = polyfit( D(D<threshold), pl(D<threshold), 1 );
slope = 1./slope(1); % extract the propagation speed from the regression slope
