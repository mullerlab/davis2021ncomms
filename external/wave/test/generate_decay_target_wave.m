function [xf] = generate_decay_target_wave( image_size, dt, T, ...
                                        frequency, lambda, sigma, varargin )
% *WAVE*
%
% GENERATE DECAY TARGET WAVE TEST DATA     generates a simple test dataset for
%                                           use with the functions in WAVE
%
%             data description:    a 2d decaying target wave
%
% INPUT
% image size - length of the image square
% dt - sampling period
% T - epoch length
% frequency - oscillation frequency
% lambda - wavelength (in polar coordinate frame)
% sigma - the spatial spread of the decay (from center point)
% varargin{1} - phase offset (sc)
%
% OUTPUT
% xf - the movie of the gaussian pulse
%

if ~isempty(varargin); phase_offset = varargin{1}; else phase_offset = 0; end;

% distance matrix
[X,Y] = meshgrid( (1:image_size)-floor(image_size/2), ...
                                    (1:image_size)-floor(image_size/2) );
D = sqrt( X.^2 + Y.^2 );

xf = zeros( image_size, image_size, T/dt );
time = dt:dt:T;
for ii = 1:image_size
    for jj = 1:image_size
   
        xf(ii,jj,:) = sin( 2*pi*frequency*time - 2*pi/lambda*D(ii,jj) + ...
                                                            phase_offset );
        
    end
    
end

gF = 1 * exp( -D.^2 / (2*sigma.^2) );
xf = (1/2) .* ( xf + 1 );
xf = xf .* repmat( gF, [1 1 size(xf,3)] );

