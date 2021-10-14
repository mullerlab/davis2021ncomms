function [xo] = lowpass_spatial_filter( x, sigma ) 
% *WAVE*
%
% LOWPASS SPATIAL FILTER    filter a data cube in the first two dimensions
%                              with a gaussian in spatial frequency 
%                              domain
%
% INPUT: 
% x - data (r,c,t)
% sigma - frequency spread
% 
% OUTPUT:
% xo - output datacube
%
% SAMPLE PARAMETERS:
% sigma -- 0.02 
%

assert(ndims(x) == 3,'datacube input required');
xo = zeros(size(x));

FFT_pts = 2 .^ ceil(log2(size(x(:,:,1))));
f0 = floor([FFT_pts(1) FFT_pts(2)] / 2) + 1;
fy = ((FFT_pts(1): -1: 1) - f0(1) + 1) / FFT_pts(1);
fx = ((1: FFT_pts(2)) - f0(2)) / FFT_pts(2);
[mfx mfy] = meshgrid(fx, fy);
SF = sqrt(mfx .^ 2 + mfy .^ 2);
filt = exp(-(SF) .^ 2 / (2 * sigma.^2));

for ii = 1:size(x,3)
    
    tmp_out = fft2(x(:,:,ii), FFT_pts(1), FFT_pts(2));
    tmp_out = fftshift(tmp_out); 
    tmp_out = filt .* tmp_out;
    tmp_out = real(ifft2(ifftshift(tmp_out)));
    tmp_out = tmp_out(1:size(x,1),1:size(x,2));   
    xo(:,:,ii) = tmp_out; 
    clear tmp_out
    
end
