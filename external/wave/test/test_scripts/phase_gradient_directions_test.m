% *WAVE*
%
% PHASE GRADIENT TEST SCRIPT     takes the phase gradient of an
%                                   example function (here, a 2d
%                                   target wave)
%

image_size = 10;
dt = 0.001; T = 1.0; frequency = 10;
wavelength = 20; orientation = -pi/2;
pixel_spacing = 1;

xf = generate_plane_wave( image_size, dt, T, frequency, wavelength, orientation );
xph = hilbert_transform( xf ); xph = rectify_rotation( xph, 0.9 );
[pm,pd] = phase_gradient_complex_multiplication( xph, pixel_spacing );

plot_vector_field( exp( 1i .* pd(:,:,100) ) )
