function [U,V] = ...
    generate_logarithmic_spiral_vector_field( size, a, alpha, center )
% *WAVE*
%
% GENERATE SINE WAVE TEST DATA     generates a logarithmic spiral vector
%                                   field according to the equation:
%           
%                                       r = a * exp( \theta cot(\alpha) ),
%
%                                           where \theta is the rotation
%                                           angle about a center (x,y) point
%
% OTHER INPUTS
% size - image size (sc)
%
% OUPTUT
% v - output vector field
%

[X,Y] = meshgrid( (1:size)-center(1), (1:size)-center(2) );
[TH,R] = cart2pol( X, Y );

U = a * exp( TH * cot(alpha) ) * sin( TH );
V = a * exp( TH * cot(alpha) ) * cos( TH );
% 
% %R = 1;
% T = ( 1 ./ cot(alpha) ) * log( R / a );



