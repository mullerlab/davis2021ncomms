function [xf_movie] = generate_2d_sin( image_size, number_timesteps, lambda )
% *WAVE*
%
% GENERATE 2D SINE WAVE TEST DATA     generates a simple test dataset for
%                                       use with the functions in WAVE
%
%                                     data description:
%                                     a 2d sine wave, with phase angle from
%                                       [0, 2pi] in (number_timesteps)
%                                       steps
%
% INPUT
% image_size - length of the image square
% number_timesteps - time length of the movie
% lambda - wavelength (in pixels)
%
% OUPTUT
% xf_movie - test dataset
% (sample saved as sin2d.mat)
%

X = 1:image_size;                           % X is a vector from 1 to imageSize
X0 = (X / image_size) - .5;                 % rescale X -> -.5 to .5
%figure;                                 % make new figure window
%plot(X0);                               % plot ramp
freq = image_size/lambda;                    % compute frequency from wavelength
Xf = X0 * freq * 2*pi;                  % convert X to radians: 0 -> ( 2*pi * frequency)

[Xm Ym] = meshgrid(X0, X0); %#ok<NASGU>

% initialization
xf_movie = zeros(size(Xf,2),size(Xf,2),number_timesteps);

ii=1;
for phaseRad = linspace(0,2*pi,number_timesteps)
    
    Xf = Xm * freq * 2*pi;
    grating = sin(Xf + phaseRad);            % make 2D sinewave
    %imagesc( grating, [-1 1] );             % display
    %colormap gray(256);                     % use gray colormap (0: black, 1: white)
    %axis off; axis image;                   % use gray colormap
    %pause
    xf_movie(:,:,ii) = grating;
    ii = ii + 1;
    
end