function [xo] = zscore_independent_slice( x, time_point )
% *WAVE*
%
% ZSCORE INDEPENDENT SLICE  returns the z-score of each channel in the 
%                               datacube, with standard deviations taken
%                               before a given timepoint
%
% INPUT
% x - datacube (r,c,t)
% time_point - cutoff time for standard deviations
%
% OUTPUT
% xo - z-scored datacube (r,c,t)
%

assert(ndims(x) == 3,'datacube input required');

% get matrices of mean and std
mu = mean(x(:,:,1:time_point),3);sigma = std(x(:,:,1:time_point),[],3);
mu = repmat(mu,[1 1 size(x,3)]);sigma = repmat(sigma,[1 1 size(x,3)]);

% make independent z-score
xo = (x - mu) ./ sigma;