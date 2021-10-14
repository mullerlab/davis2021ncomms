function [pl,modulus,ind,offset] = vector_phase_latency( xph, wt, Fs, time_point )
% *WAVE*
%
% PHASE LATENCY     returns the phase-based latency for
%                      an input analytic signal for the
%                      interpolated phase point after 
%                      the given time point (e.g. the
%                      first 2pi after stimulus onset)
%
%                      * parts of the crossing algorithm were
%                           inspired by crossing.m from FILEX
%
% INPUT
% xph - analytic signal vector (1,t)
% wt - instantaneous frequency vector (1,t)
% Fs - sampling frequency
% time_point - discrete index of the requested starting time-point
%
% OUTPUT
% pl - phase-latency (sc)
%

assert( isrow(xph), 'row vector input required' );
modulus = abs(xph);
xph = angle(xph);

% do exact zeros exist?
ind0 = find( xph(1,time_point:end) == 0, 1, 'first' );

% get the first crossing 
ind = find( ( xph(1,time_point:end-1) .* xph((time_point+1):end) ) < 0, 1, 'first' );

% get the second crossing 
ind2 = find( ( xph(1,(time_point+ind+1):end-1) .* xph((time_point+ind+2):end) ) < 0, 1, 'first' ) + 1;

% correct indexes
ind = time_point + ind - 1;
ind2 = ind + ind2;

% abs(xph(ind2)) < abs(xph(ind))?
if abs(xph(ind2)) < abs(xph(ind)); ind = ind2; end

% ind0<ind?
if ~isempty(ind0)
    if ind0 < ind;ind = ind0;end
end

% interpolate based on instantaneous frequency

offset = ( abs(xph(ind)) ./ (2*pi*wt(ind)) ); 
pl = ( ( abs(xph(ind)) ./ (2*pi*wt(ind)) ) + ( ind / Fs ) );
modulus = modulus(ind);
