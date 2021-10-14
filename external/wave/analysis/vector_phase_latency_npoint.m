function [pl,modulus] = vector_phase_latency_npoint( xph, wt, Fs, time_point )
% *WAVE*
%
% PHASE LATENCY NPOINT     returns the phase-based latency for
%                               an input analytic signal for the
%                               all phase points after the given
%                               starting time point (e.g. the
%                               first 2pi after stimulus onset)
%
% INPUT
% xph - analytic signal vector (1,t)
% wt - instantaneous frequency vector (1,t)
% Fs - sampling frequency
% time_point - discrete index of the requested starting time-point
%
% OUTPUT
% pl - phase-latency (1,number_crossings)
% modulus - amplitude complex exponential around the crossing index
%                                                   (1,number_crossings)
%

assert( isrow(xph), 'row vector input required' );
mod = abs(xph);
xph = angle(xph);

% do exact zeros exist?
ind0 = find( xph(1,time_point:end) == 0, 1 );

% get all crossings
ind = find( ( xph(1,time_point:end-1) .* xph((time_point+1):end) ) < 0 );

% exclude wrapped crossings
ind( abs( xph(ind) > 2 ) | abs( xph(ind+1) > 2 ) ) = [];

% correct indexes
ind = time_point + ind - 1;

% gather up indices and sort
ind = [ind ind0];
ind = sort( ind );

% interpolate based on instantaneous frequency
pl = zeros(1,length(ind));
modulus = zeros(1,length(ind));

for ii = 1:length(ind)
    pl(ii) = ( ( abs(xph(ind(ii))) ./ (2*pi*wt(ind(ii))) ) + ( ind(ii) / Fs ) );
    modulus(ii) = mod(ind(ii));
end

