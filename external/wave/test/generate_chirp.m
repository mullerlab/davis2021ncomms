function [xf] = generate_chirp( dt, T, f0, f1 )
% *WAVE* 
%
% GENERATE CHIRP     generates a 1d swept-frequency cosine chirp
%
% INPUT
% dt - timestep
% T - epoch length
% f0 - start frequency
% f1 - end frequency
%

time_axis = dt:dt:T;
xf = chirp( time_axis, f0, T, f1 );