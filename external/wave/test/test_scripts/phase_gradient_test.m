% *WAVE*
%
% PHASE GRADIENT TEST SCRIPT     takes the phase gradient of an
%                                   example function (here, a 2d
%                                   target wave)
%

image_size = 50;
number_timesteps = 100;
spatial_frequency = .05;
pixel_spacing = 1;

xf = generate_2d_target_wave( image_size, number_timesteps, spatial_frequency );
xph = hilbert_transform( xf ); xph = rectify_rotation( xph );
[pm,pd] = phase_gradient_complex_multiplication( xph, pixel_spacing );
%[pm,pd] = phase_gradient( xph );

pm = 1./pm;
figure
hist(pm(isfinite(pm)),100)
xlabel('Wavelength (px)')
ylabel('Count')

figure
imagesc(pd(:,:,10))