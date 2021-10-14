function [target_movie] = generate_2d_target_wave( image_size, number_timesteps, spatial_frequency, varargin )
% *WAVE*
%
% GENERATE 2D TARGET WAVE TEST DATA     generates a simple test dataset for
%                                         use with the functions in WAVE
%
%                                       data description:
%                                       a 2d target wave, with phase angle from
%                                         [0, 2pi] in (number_timesteps)
%                                         steps
%
% INPUT
% image_size - length of the image square
% number_timesteps - time length of the movie
% lambda - wavelength (in pixels)
%
% OUPTUT
% target_movie - test dataset
% (sample saved as sin2d.mat)
%

% generate matrix of distances
x = -(image_size-1):image_size;y = -(image_size-1):image_size;
[X,Y] = meshgrid(x,y);
D = sqrt( X.^2 + Y.^2 );

% initialization
target_movie = zeros( image_size*2, image_size*2, number_timesteps );
if ~isempty(varargin); phase_offset = varargin{1}; else phase_offset = 0; end;

% generate cosine wave movie
ii = 1;
for phaseRad = linspace( 0, 2*pi, number_timesteps )

    target_movie(:,:,ii) = cos( 2*pi*spatial_frequency*D - phaseRad + phase_offset );
    ii = ii + 1;
    
end

