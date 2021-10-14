function [slope,intercept] = ...
    phase_correlation_distance_DM_TS( pl, source, distance_matrix )
% *WAVE*
%
% PHASE CORRELATION DISTANCE DM TS    assess relationship of phase with
%                                       distance, using the Theil-Sen
%                                       estimator and distance matrix
%
% INPUT
% pl - phase map (r,c)
% source - source point (sc)
% distance_matrix - distance matrix (rc,rc)
%
% OUTPUT
% slope - slope of relationship from Theil-Sen estimator
% intercept - intercept of relationship
%

assert( ismatrix(pl), 'data matrix input required' )
assert( ( source(1) <= size(pl,2) ) && ( source(2) <= size(pl,1) ), ...
    'source point out of bounds' )

% make matrix of distances from wave center
ind = sub2ind( [size(pl,1) size(pl,2)], source(2), source(1) );
D = distance_matrix( ind, : ); D = reshape( D, size(pl,1), size(pl,2) );

% add in NaNs, flatten, remove NaNs
D = D(:);D( isnan(pl) ) = [];
pl = pl(:);pl( isnan(pl) ) = [];

% phase relationship with distance
[slope,intercept] = theil_sen_estimator( D, pl );

