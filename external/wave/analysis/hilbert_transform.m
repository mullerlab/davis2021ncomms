function [xo] = hilbert_transform( x )
% *WAVE*
%
% HILBERT TRANSFORM    take the hilbert transform of a datacube
%
% INPUT:
% x - datacube (r,c,t)
%
% OUTPUT:
% xo - output datacube
%

assert(ndims(x) == 3,'datacube input required');
[dim1,dim2,dim3] = size(x);

x = reshape(x, [dim1*dim2, dim3]);
xo = hilbert(x');
xo = xo';
xo = reshape(xo, [dim1,dim2,dim3]);