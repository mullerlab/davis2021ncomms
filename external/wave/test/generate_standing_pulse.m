function [xf] = generate_standing_pulse( image_size, number_timesteps, sigma )
% *WAVE*
%
% GENERATE STANDING PULSE     generates a standing pulse, one of the two
%                               important idealized models for the VSD 
%                               response, following the equation:
%
%                               f(x,t) = exp( - [ ( r^2 / (2sigma_x) ) +
%                                                ( (t-t_p)^2 / (2sigma_t) )
%                                                ] )
%
%
% INPUT
% image_size - length of the image square
% number_timesteps - time length of the movie
% sigma - dispersion in space
%
% OUPTUT
% xf - test data
%


