function [xo] = notch_filter(x, f1, f2, filter_order, Fs)
% *WAVE* 
%
% NOTCH FILTER    notch filter a datacube between frequencies f1 and f2
%
% INPUT: 
% x - datacube (r,c,t)
% f1 - low frequency for notch
% f2 - high frequency
% filter_order - filter order ( x2 for bandpass filter )
% Fs - sampling frequency
%
% OUTPUT
% xo - output datacube
%

assert(ndims(x) == 3,'datacube input required');
xo = zeros(size(x));

% construct filter
ct = [f1 f2];
ct = ct / (Fs/2);
[b,a] = butter(filter_order,ct,'stop'); 

% proceed with filtering
for rr = 1:size(x,1)
    for cc = 1:size(x,2)
        if ~all( isnan(squeeze(x(rr,cc,:))) )
            xo(rr,cc,:) = filtfilt( b, a, squeeze(x(rr,cc,:)) );
        end
    end
end