function [xo] = lowpass_filter_matrix( x, f, filter_order, Fs )
% *WAVE*
%
% LOWPASS FILTER MATRIX    filter channels in a matrix, w/cutoff frequency f
%
% INPUT:
% x - datacube
% f - lowpass cutoff
% Fs - sampling frequency
%
% OUTPUT
% xo - output datacube
%

assert(ndims(x) == 2,'matrix input required');
xo = zeros(size(x));

ct = f;
ct = ct / (Fs/2);
[b,a] = butter(filter_order,ct,'low'); % remember, filter_order * 1 for lowpass

for ii = 1:size(x,1)
    xo(ii,:) = filtfilt(b,a,x(ii,:));
end
