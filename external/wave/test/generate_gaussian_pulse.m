function [xf] = generate_gaussian_pulse( image_size, dt, T, amplitude, frequency, sigma )
% *WAVE*
%
% GENERATE GAUSSIAN PULSE     generates a simple test dataset, following
%                               the model of a space-time separable
%                               Gaussian pulse.
%
%                             f(x,t) = g(x) * h(t), where
%                               
%                                    g(x) = exp(-(x-x_0)^2/2*sigma^2)
%                                    h(t) = A*sin(2*pi*f*t)
%
% INPUT
% image size - length of the image square
% dt - sampling period
% T - epoch length
% amplitude - oscillation amplitude
% frequency - oscillation frequency
% sigma - the spatial spread of the gaussian
%
% OUTPUT
% xf_movie - the movie of the gaussian pulse
%

gaussianFilter = fspecial( 'gaussian', image_size, sigma );
gaussianFilter = gaussianFilter ./ max(gaussianFilter(:));
xf = generate_sin( dt, T, frequency, -pi/2 );
xf = (amplitude/2) .* ( xf + 1 );

% repmat matrix to xf 
xf = reshape( xf, [1 1 length(xf)] );
xf = repmat( xf, [ image_size image_size 1 ] );

% check the work
assert( ndims(xf) == 3, 'problem with xf dimensionality' );
assert( size(xf,1) == image_size, 'problem with xf size' );

for ii = 1:size(xf,3)
    xf(:,:,ii) = xf(:,:,ii) .* gaussianFilter;
end
