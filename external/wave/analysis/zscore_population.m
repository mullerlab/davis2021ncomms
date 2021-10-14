function [xo] = zscore_population( x )
% *WAVE*
%
% ZSCORE POPULATION  returns the z-score of each channel in the datacube,
%                       based on the estimated population variance.
%
% INPUT
% x - datacube (r,c,t)
%
% OUTPUT
% xo - z-scored datacube (r,c,t)
%

assert(ndims(x) == 3,'datacube input required');

t = size(x,3);
mu = mean(x,3);mu = repmat(mu,[1 1 t]);

% estimate population variance
sigma = std(x,[],3);
sigma = mean(sigma(:));

% make the population z-score
xo = (x - mu) ./ sigma;