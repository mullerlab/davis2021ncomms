function [cc,pv] = phase_correlation_distance_DM( pl, source, distance_matrix )
% *WAVE*
%
% PHASE CORRELATION DISTANCE DM   correlation of phase with distance
%                                   (circular-linear), given an input 
%                                   phase map and a distance matrix
%
% INPUT
% pl - phase map (r,c)
% source - source point (sc)
% distance_matrix - distance matrix (rc,rc)
%
% OUTPUT
% cc - linear correlation coefficient, phase latency time w/ distance
% pv - p-value of the correlation
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

% phase correlation with distance
[ cc, pv ] = circ_corrcl( pl, D ); % H0: rho == 0, H1: rho != 0




