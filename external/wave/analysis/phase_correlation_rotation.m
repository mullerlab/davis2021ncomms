function [cc,pv,curl_point] = phase_correlation_rotation( pl, cl, varargin )
% *WAVE*
%
% PHASE CORRELATION ROTATION    correlation of phase with rotation angle
%                                   theta (circular-circular), given the curl
%                                   of the phase gradient vector field
%
% INPUT
% pl - phase field (r,c)
% cl - curl field (r,c)
% varargin{1} - curl point (x,y)
%
% OUTPUT
% cc - circular correlation coefficient, rotation angle about curl point
% pv - p-value of the correlation
%

assert( ( ismatrix(pl) & ismatrix(cl) ), 'data matrix input required, pl cl' )

% get curl point, if not passed
if ( ( nargin > 2 ) && ( ~isempty(varargin{1}) ) )
    assert( numel( varargin{1} ) == 2, 'improper format, source point' )
    curl_point = varargin{1};
else
    curl_point = zeros( 1, 2 );
    [curl_point(2),curl_point(1)] = find( abs(cl) == max(abs(cl(:))), 1, 'first' );
end

% make matrix of distances from curl point
[X,Y] = meshgrid( (1:size(pl,2))-curl_point(1), (1:size(pl,1))-curl_point(2) );
[T,~] = cart2pol( X, Y );

% flatten, remove NaNs
T = T(:); pl = pl(:); T( isnan(pl) ) = []; pl( isnan(pl) ) = [];

% phase correlation with distance
[ cc, pv ] = circ_corrcc( pl, T ); % H0: rho == 0, H1: rho != 0




