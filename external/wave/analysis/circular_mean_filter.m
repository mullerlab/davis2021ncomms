function [xo] = circular_mean_filter( x, pix )
% *WAVE*
%
% CIRCULAR MEAN FILTER     filters a data matrix with a circular mean
%                           filter, meant for direction maps, ignoring NaNs.
%
% INPUT
% x - data matrix (r,c)
% pix - length of the filter square
%
% OUTPUT
% xo - data matrix output (r,c)
%

assert( ndims(x) == 2, 'data matrix input required' )
xo = zeros( size(x) );

for rr = 1:size(x,1)
    for cc = 1:size(x,2)
        
        index_rr = (rr-pix):(rr+pix);
        index_rr(index_rr<1) = [];
        index_rr(index_rr>size(x,1)) = [];
        index_cc = (cc-pix):(cc+pix);
        index_cc(index_cc<1) = [];
        index_cc(index_cc>size(x,2)) = [];
        
        j = x(index_rr,index_cc);
        j(isnan(j)) = [];
        
        xo(rr,cc) = circ_mean(j(:));
        
    end
end