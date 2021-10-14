function [s,varargout] = ...
    instantaneous_speed_map( pl, wt, source, source_value, spacing, speed_bound )
% *WAVE*
%
% INSTANTANEOUS SPEED MAP     compute an instantaneous speed map from a
%                               phase latency map
%
% INPUT
% pl - phase latency map (r,c)
% wt - instantaneous frequency map (r,c)
% source - wave source estimate [x y]
% source_value - estimated wave source value (e.g. pixel average) (sc)
% speed_bound (optional) - speed bounds [lo hi]
%
% OUTPUT
% s - instantaneous speed estimate
% b (optional) - logical matrix of speeds falling within speed_bound
%

assert( ismatrix(pl) & ismatrix(wt), 'matrix inputs required, pl and wt' );
assert( isequal( size(pl), size(wt) ), 'matrix sizes must be equal, pl and wt' );
assert( numel(source) == 2, '[x y] input required, source' )
if isempty(source_value), source_value = pl(source(2),source(1)); end
if nargin > 5
    assert( numel(speed_bound) == 2, '[lo hi] input required, speed bound' )
end

% make matrix of distances from wave center
[r,c] = size(pl); [X,Y] = meshgrid( (1:c)-source(2), (1:r)-source(1) );
D = sqrt( X.^2 + Y.^2 ); D = D.*spacing;

s = zeros( size(pl) );
for ii = 1:size(pl,1)
    for jj = 1:size(pl,2)
        s(ii,jj) = ( pl(ii,jj) - source_value );
        s(ii,jj) = D(ii,jj) ./ s(ii,jj); % rate = distance / time
    end
end
s( source(2), source(1) ) = NaN;

if nargin > 5
    
    % compute boundary from speed estimate
    b = ( s > speed_bound(1) ) & ( s < speed_bound(2) );
    b( source(2), source(1) ) = 1;
    varargout{1} = b;
    
end

