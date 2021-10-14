function [cr] = circular_resultant( xph )
% *WAVE*
%
% CIRCULAR RESULTANT     get the circular resultant timeseries from a
%                           datacube of angular values
%
% INPUT
% xph - datacube (r,c,t - angular values)
%
% OUTPUT
% cr - circular resultant timeseries
%

assert( ndims(xph) == 3, 'datacube input required' )
assert( isreal(xph) == 1, 'angular (real-valued) input required' )

xph = reshape( xph, [], size(xph,3) );
xph = remove_nan_rows( xph );
cr = circ_r( xph, [], [], 1 );

