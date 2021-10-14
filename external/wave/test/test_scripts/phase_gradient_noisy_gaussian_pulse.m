% *WAVE*
%
% PHASE GRADIENT GAUSSIAN PULSE TEST SCRIPT - ADDITIVE NOISE
%
%   confirms the assertion that the phase gradient of a gaussian is
%     null; here the phase gradient magnitude is small to the limit of
%     machine precision
%

clear all

[xf] = generate_gaussian_pulse( 50, .01, 1, 2, 1, 10 );
xf = xf + randn(size(xf))*.25;
xph = hilbert_transform( xf );
[pm,pd] = phase_gradient_complex_multiplication( xph, 1 );

pm = pm(:,:,1:end-1);
hist(pm(:),100)
