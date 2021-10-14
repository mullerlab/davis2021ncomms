function [ep,s] = narrowband_detection( ...
    x, freq, freq_wide, filter_order, window_length, offset, threshold, Fs )
% *WAVE*
%
% NARROWBAND DETECTION    detect epochs of transient narrowband
%                           oscillations in multichannel data
%
% INPUT
% x - unprocessed datacube (r,c,t)
% freq - frequency band of interest [ f1 f2 ]
% freq_wide - frequency band for comparison [ f1 f2 ]
% filter_order - desired order for applied filter
% window length - points for each window (sc)
% offset - sliding window offset (sc)
% Fs - sampling frequency (sc)
%
% OUTPUT
% ep - epochs structure
% snr - SNR datacube (r,c,t)
%

assert( ndims(x) == 3, 'datacube input required, x' )
assert( numel(freq) == 2, 'frequency band start/stop required, freq' )
assert( ...
    isscalar(window_length) & isscalar(offset) & ( isscalar(threshold) | isempty(threshold) ) & isscalar(Fs), ...
    'scalar inputs required -- window_size, offset, threshold, and Fs' )

% initialization and defaults
if isempty( window_length ); window_length = 256; end
if isempty( offset ); offset = window_length; end
if isempty( threshold ); threshold = 1; end
number_windows = floor( ( size(x,3) - window_length ) ./ offset );
s = zeros( size(x,1), size(x,2), number_windows );

% prepare datacubes
xf = bandpass_filter( x, freq(1), freq(2), filter_order, Fs );
xb = bandpass_filter( x, freq_wide(1), freq_wide(2), filter_order, Fs );
xb = notch_filter( xb, freq(1), freq(2), filter_order, Fs );

% calculate SNR values
for kk = 1:number_windows
    
    times = (1:window_length) + ( (kk-1)*offset );

    for ii = 1:size(x,1)
        for jj = 1:size(x,2)
            s(ii,jj,kk) = snr( xf(ii,jj,times), xb(ii,jj,times) );
        end
    end
end
            
% calculate epochs
ep = find_amplitude_epochs( s, threshold );
