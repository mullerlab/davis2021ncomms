function [cc,pv,xx,yy,time_modulation,speed] = phase_latency_correlation_scan( pl, spacing, range, dx )
% *WAVE*
%
% PHASE LATENCY CORRELATION DISTANCE     makes the phase latency
%                                           correlation with distance,
%                                           given an input latency map
%                                           PL.
%
% INPUT
% pl - phase latency map (r,c)
% spacing - pixel spacing (sc)
%
% OUTPUT
% cc - linear correlation coefficient, phase latency time w/ distance
% pv - p-value of the correlation
% xx - x-position of the phase-latency basin
% yy - y-position of the phase-latency basin
% time_modulationn - (max - min), of the smoothed phase latency map
% speed - speed taken from the slope of the regression line (latency
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

space = range(1):dx:range(2);
cc = zeros(1,length(space));pv = zeros(1,length(space));speed = zeros(1,length(space));
for ii = 1:length(space)
    [slope,~,stats,~] = linear_regression( D(D<space(ii)), pl(D<space(ii)) );
    slope = 1./slope(1);
    cc(ii) = stats(1);pv(ii) = stats(5);speed(ii) = slope;
end
