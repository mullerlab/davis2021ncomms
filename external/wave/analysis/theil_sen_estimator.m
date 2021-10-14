function [m,b,slopes] = theil_sen_estimator( x, y )
% *WAVE*
%
% THEIL SEN ESTIMATOR     calculate the slope and intercept of a linear regression
%                           using the Theil-Sen robust estimator
%
% INPUT
% x - independent variable (vector)
% y - dependent variable (vector)
%
% OUTPUT
% m - slope
% b - intercept
% slopes - individual slope distribution
%

assert( ( isvector(x) && isvector(y) ) == 1, 'vector input required, x y' )

slopes = nan( length(y) );
for ii = 1:length(y), slopes(ii,:) = ( y(ii) - y ) ./ ( x(ii) - x ); end
m = nanmedian( slopes(:) );

if nargout > 1, b = nanmedian( y - m*x ); end
