function [wt] = vector_instantaneous_frequency( xph, Fs )
% *WAVE*
%
% VECTOR INSTANTANEOUS FREQUENCY     returns the instantaneous frequency
%                                       estimation from the formula:
%
%           d(Psi)/dt = \Delta(Psi_n) = arctan(X_{n}*X_{n+1})/dt   (2.11)
%
%                           where X is the analytic signal of x.
%
%                           Given in: Feldman (2011) Hilbert Transform
%                                     Applications in Mechanical Vibration.
%                                     Algorithm 3, p. 18.
%
%                           Which allows direct computation of the IF, 
%                           without phase unwrapping. 
%
% INPUT: 
% xph - analytic signal representation of vector x (1,t)
% Fs - sampling frequency
%
% OUTPUT:
% wt - instantaneous frequency (1,t)
%       N.B. wt(:,:,end) = 0
%

assert( isvector( xph ), 'data vector input required' );

wt = abs( angle( xph(1:end-1) .* conj( xph(2:end) ) ) ) ./ (1/Fs);
wt(end+1) = 0;
wt = wt./(2*pi);
