function [xo] = zscore_independent_matrix( x )
% *WAVE*
%
% ZSCORE INDEPENDENT MATRIX  returns the z-score of each channel in the datacube
%
% INPUT
% x - data matrix (r,t)
%
% OUTPUT
% xo - z-scored data matrix (r,t)
%

assert( ismatrix(x), 'datacube input required' );

% get matrices of mean and std
mu = mean(x,2);sigma = std(x,[],2);
mu = repmat(mu,[1 size(x,2)]);sigma = repmat(sigma,[1 size(x,2)]);

% make independent z-score
xo = (x - mu) ./ sigma;
