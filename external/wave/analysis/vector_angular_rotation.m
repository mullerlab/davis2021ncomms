function [xo] = vector_angular_rotation( xph, angle )
% *WAVE* 
%
% VECTOR ANGULAR ROTATION     rotates the angular data in the vector xph a given
%                                    angle
%
% INPUT: 
% xph - datacube (r,c,t) (probably complex)
% angle - rotation angle
%
% OUTPUT
% xo - output datacube
%

assert( isvector(xph) == 1, 'vector input required' );

xo = xph .* exp( 1i * angle );