function [pl,modulus,ind,offset] = phase_latency( xph, wt, Fs, time_point )
% *WAVE*
%
% PHASE LATENCY     returns the phase-based latency for
%                      the input phase maps of the system
%                      for the interpolated phase point 
%                      after the given time point (e.g.
%                      the first 2pi after stimulus onset)
%
%                      * parts of the crossing algorithm were
%                           inspired by crossing.m from FILEX
%
% INPUT
% xph - analytic signal representation of the datacube (r,c,t)
% wt - instantaneous frequency datacube (r,c,t)
% Fs - sampling frequency
% time_point - discrete index of the starting time-point
%
% OUTPUT
% pl - phase-latency matrix (r,c)
% modulus - amplitudes at the 2pi crossing (r,c)
%

assert( ndims(xph) == 3, 'datacube input required' );
assert( ~isreal(xph) == 1, 'analytic signal form for input required, xph' );
assert( ndims(wt) == 3, 'IF datacube input required' );

% reshape
[dim1,dim2,dim3] = size(xph);
xph = reshape( xph, [dim1*dim2,dim3] );
wt = reshape( wt, [dim1*dim2,dim3] );

% init
pl = zeros(1,dim1*dim2);
modulus = zeros(1,dim1*dim2);
ind = zeros(1,dim1*dim2);
offset = zeros(1,dim1*dim2);

% wrapper for vector_phase_latency.m
for ii = 1:(dim1*dim2)
   [tmp_pl,tmp_mod,tmp_ind,tmp_offset] = vector_phase_latency( xph(ii,:), wt(ii,:), Fs, time_point );
   if ~isempty(tmp_pl); pl(ii) = tmp_pl; modulus(ii) = tmp_mod; end
   if ~isempty(tmp_pl); ind(ii) = tmp_ind; offset(ii) = tmp_offset; end
end

% final reshape
pl = reshape( pl, [dim1,dim2] );
modulus = reshape( modulus, [dim1,dim2] );
ind = reshape( ind, [dim1,dim2] );
offset = reshape( offset, [dim1,dim2] );
