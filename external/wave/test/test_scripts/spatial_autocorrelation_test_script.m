% *WAVE*
%
% SPATIAL AUTOCORRELATION TEST SCRIPT
%
%   quick check on the radial average spatial autocorrelation function
%

xf = generate_2d_target_wave( 50, 10, .02 );
xo = autocorrelation_sequence( xf, 1, 1 );
