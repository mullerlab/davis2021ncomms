function [radavg,radstd,distances] = radial_average( x, xx, yy, bin_size, spacing )
% *WAVE*
%
% RADIAL AVERAGE     make a radial average of a two-dimensional data array
%
% INPUT
% x - data matrix (r,c)
% xx - center position (x)
% yy - center position (y)
% bin_size - bin width
% spacing - physical pixel spacing
%
% OUTPUT
% radavg - radial average 
% radstd - radial standard deviation
% distances - distance axis
%

assert( ismatrix(x), 'data matrix input required' );

[r,c] = size(x);
[X,Y] = meshgrid( (1:c)-xx, (1:r)-yy );
D = sqrt( X.^2 + Y.^2 );

maximum_distance = max(max(D));
distances = bin_size:bin_size:maximum_distance;

radavg = zeros(size(distances));
radstd = zeros(size(distances));
for ii = 1:length(distances)
    i = find( (D > (distances(ii) - (bin_size/2))) & ...
        (D < (distances(ii) + (bin_size/2))) );
    radavg(ii) = nanmean(x(i));
    radstd(ii) = nanstd(x(i));
end

distances = distances*spacing;