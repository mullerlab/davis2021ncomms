function [target_movie] = generate_traveling_gaussian_pulse( size, number_timesteps, sigma, c )
% *WAVE*
%
% GENERATE TRAVELING GAUSSIAN PULSE     generates a simple test dataset for
%                                         use with the functions in WAVE
%
% INPUT
% size - length of x-axis (px)
% number_timesteps - length of time axis (samples)
% sigma - spatial sigma of the gaussian
% c - speed
%
% OUPTUT
% target_movie - test dataset
%

x = 1:size;
t = 1:number_timesteps;
target_movie = zeros( size, number_timesteps );

for ii = 1:number_timesteps
    target_movie(:,ii) = exp( - ( x - c.*t(ii) ).^2 / (2*sigma.^2) );
end