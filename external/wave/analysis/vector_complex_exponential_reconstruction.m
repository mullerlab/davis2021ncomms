function [xn] = vector_complex_exponential_reconstruction( amplitude, phase )
% *WAVE*
%
% COMPLEX EXPONENTIAL RECONSTRUCTION    reconstructs a real-valued vector
%                                       from its instantaneous amplitudes
%                                       and phases
%
%                                       N.B. the x2 gain modulation of the
%                                       Hilbert transform is explicitly
%                                       accounted for here by the amp/2
%                                       factor
%
% INPUT
% amplitude - instantaneous amplitudes
% phases - instantaneous phases
%
% OUTPUT
% xn - reconstructed datacube (r,c,t)
%

assert( isvector(amplitude) == 1, 'vector input required, amplitude' );
assert( isvector(phase) == 1, 'vector input required' );
assert( isequal( size(amplitude), size(phase) ), 'sizes must be equal' );

xn = (amplitude) .* cos( phase );