function [xo] = remove_zero_rows( x )
% *WAVE*
%
% REMOVE NAN ROWS      removes any rows from a two-dimensional matrix which
%                           contain 0's
%
% INPUT
% x - data matrix (r,c)
%
% OUTPUT
% xo - data matrix, NaN rows removed
%

assert( ndims(x) == 2, 'data matrix input required' )

xo = x(~any((x==0),2),:);