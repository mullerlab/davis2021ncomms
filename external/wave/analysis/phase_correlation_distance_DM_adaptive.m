function [cc,pv,b] = phase_correlation_distance_DM_adaptive( ...
    pl, wt, source, distance_matrix, speed_bound, shuffle_option, bound )
% *WAVE*
%
% PHASE CORRELATION DISTANCE DM   correlation of phase with distance
%                                   (circular-linear), given an input
%                                   phase map and a distance matrix
%
% INPUT
% pl - phase map (r,c)
% wt - instantaneous frequency map (r,c)
% source - source point (sc)
% distance_matrix - distance matrix (rc,rc)
% speed_bound - speed limits for boundary calculation [lo hi]
% shuffle_option - whether to shuffle the channels in space (permutation)
% bound (optional) - boundary surface (if precomputed)
%
% OUTPUT
% cc - linear correlation coefficient, phase latency time w/ distance
% pv - p-value of the correlation
% b - boundary surface
%

assert( ismatrix(pl), 'data matrix input required' )
assert( ( source(1) <= size(pl,2) ) && ( source(2) <= size(pl,1) ), ...
    'source point out of bounds' )

% make matrix of distances from wave center
ind = sub2ind( [size(pl,1) size(pl,2)], source(2), source(1) );
D = distance_matrix( ind, : ); D = reshape( D, size(pl,1), size(pl,2) );

if nargin < 7
    
    % make speed estimate (a PL-type calculation)
    s = zeros( size(pl) );
    for ii = 1:size(pl,1)
        for jj = 1:size(pl,2)
            s(ii,jj) = abs( ( circ_dist( pl(ii,jj), 2*pi ) ./ wt(ii,jj) ) - ...
                ( circ_dist( pl(source(2),source(1)), 2*pi ) ./ wt(source(2),source(1)) ) );
            distance = distance_matrix( ...
                    sub2ind( [size(pl,1) size(pl,2)], source(2), source(1) ), ...
                    sub2ind( [size(pl,1) size(pl,2)], ii, jj ) );                        
            s(ii,jj) = distance ./ s(ii,jj); % rate = distance/time
        end
    end
    s( source(2), source(1) ) = NaN;
    
    % compute boundary from speed estimate
    b = ( s > speed_bound(1) ) & ( s < speed_bound(2) );
    b( source(2), source(1) ) = 1;
    
elseif nargin == 7
    pl( ~bound ) = NaN;  b = [];
end

% add in NaNs, flatten, remove NaNs
D = D(:);D( isnan(pl) ) = [];
pl = pl(:);pl( isnan(pl) ) = [];

% shuffle phase values, if requested
if strcmp( shuffle_option, 'shuffle' ) == 1
    shuffle_index = randperm( length(pl) ); pl = pl( shuffle_index );
end

% phase correlation with distance
if ~isempty( pl )
    [ cc, pv ] = circ_corrcl( pl, D ); % H0: rho == 0, H1: rho != 0
else
    cc = NaN; pv = NaN;
end
