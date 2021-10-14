function [xo] = hipass_filter( x, f, filter_order, Fs )
% *WAVE* 
%
% LOWPASS FILTER    filter a datacube between frequencies f1 and f2
%
% INPUT: 
% x - datacube
% f - highpass cutoff
% filter_order - filter order
% Fs - sampling frequency
%
% OUTPUT
% xo - output datacube
%

assert(ndims(x) == 3,'datacube input required');
xo = zeros(size(x));

ct = f;
ct = ct / (Fs/2);
[b,a] = butter(filter_order,ct,'high'); % remember, filter_order * 1 for lowpass
for rr = 1:size(x,1)
    for cc = 1:size(x,2)
        if ~all(isnan(squeeze(x(rr,cc,:)) ))
            xo(rr,cc,:) = filtfilt(b,a,squeeze(x(rr,cc,:)));
        end
    end
end
