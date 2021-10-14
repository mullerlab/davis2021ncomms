function plot_data_matrix( x, yaxis, xaxis )
% *WAVE*
%
% PLOT DATA MATRIX     plots a two-dimensional data matrix, using the
%                       correct labels of the axes provided.
%
% INPUT
% x - data matrix input (r,c)
% yaxis - labels for all data points in y-axis
% xaxis - labels for all data points in x-axis
%
% OUTPUT
% two-dimensional labeled imagesc plot
%

assert( ndims(x) == 2, 'data matrix input required' );
assert( isvector(yaxis) == 1, 'vector input required, yaxis' );
assert( isvector(xaxis) == 1, 'vector input required, xaxis' );

imagesc( x )
xx = get( gca, 'xtick' );yy = get( gca, 'ytick' );
set( gca, 'xticklabel', xaxis(xx) );set( gca, 'yticklabel', yaxis(yy) );
