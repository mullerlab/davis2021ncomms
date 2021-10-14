function [xf] = generate_gaussian_pulse_new( image_size, dt, T, amplitude, frequency, sigma )
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

% generate matrix of distances
x = 1:image_size;y = 1:image_size;
[X,Y] = meshgrid( x-(image_size/2), y-(image_size/2) );
D = sqrt( X.^2 + Y.^2 );

% generate base timeseries
xf = generate_sin( dt, T, frequency, -pi/2 );
xf = (1/2) .* ( xf + 1 );

% repmat matrix to xf 
xf = reshape( xf, [1 1 length(xf)] );
xf = repmat( xf, [ image_size image_size 1 ] );

% check the work
assert( ndims(xf) == 3, 'problem with xf dimensionality' );
assert( size(xf,1) == image_size, 'problem with xf size' );

% generate gaussian filter
gaussianFilter = amplitude * exp( -D.^2 / (2*sigma.^2) );
for ii = 1:size(xf,3)
    xf(:,:,ii) = xf(:,:,ii) .* gaussianFilter;
end
