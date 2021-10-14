function [xo] = surrogate_narrowband_data( dimen, Fs, T, frequencies, phases )
% *WAVE* 
%
% SURROGATE NARROWBAND DATA    creates random control narrowband data,
%                               given a set of input parameters
%
% INPUT: 
% dimen - array dimensions
% Fs - sampling frequency (Hz)
% T - time (s)
% frequencies - frequency distribution
% phases - initial phase angles (random if empty)
%
% OUTPUT
% xo - output datacube
%

% check input
assert( numel(dimen) == 2, 'array dimension input required, dimen' )
assert( ( isscalar(Fs) == 1 ) & ( isscalar(T) ), 'scalar input required, Fs T' )
if nargin > 3
    assert( ( ismatrix(frequencies) ) & ( isequal(size(frequencies),dimen) ), ...
        'improper input, frequencies' )
end

if nargin > 4
    assert( ( ismatrix(phases) ) & ( isequal(size(phases),dimen) ), ...
        'improper input, frequencies' )
else
    phases = rand( dimen(1), dimen(2) ) * (2*pi);
end

time = (1/Fs):(1/Fs):T;
xo = repmat( time, [dimen(1)*dimen(2) 1 ] );
xo = reshape( xo, [ dimen(1) dimen(2) length(time) ] );
xo = exp( 1i .* ( 2.*pi.*repmat(frequencies, [1 1 length(time)]) ...
    .* xo + repmat(phases, [1 1 length(time)]) ) );



