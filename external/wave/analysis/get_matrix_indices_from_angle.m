function [in] = get_matrix_indices_from_angle( x, x0, y0, distance, start_angle, stop_angle )
% *WAVE*
%
% GET MATRIX INDICES FROM ANGLE     returns the indices of a matrix from a
%                                       vector (with distance: distance, and
%                                       angle: rotation_angle)
%
% INPUT
% x - data matrix (r,c)
%
% OUTPUT
% fo - 1d output
%

assert( ndims(x) == 2, 'data matrix input required' )

% make lines
xx = linspace( x0, x0+(distance*cos(start_angle)), 100 );
yy = linspace( y0, y0+(distance*sin(start_angle)), 100 );

xx2 = linspace( x0, x0+(distance*cos(start_angle)), 100 );
yy2 = linspace( y0, y0+(distance*sin(start_angle)), 100 );

% make curve
curve_angles = linspace( start_angle, stop_angle, 100 );

zz = distance*exp(1i*curve_angles);
xx3 = real(zz) + x0;
yy3 = imag(zz) + y0;

% make polygon
polygon_x = [xx xx3 xx2];
polygon_y = [yy yy3 yy2];

[J,I] = meshgrid( 1:size(x,2), 1:size(x,1) );
in = inpolygon( J, I, polygon_x, polygon_y );
