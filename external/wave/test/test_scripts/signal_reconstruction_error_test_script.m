%%%%%
%
% Signal Reconstruction Error
% Lyle Muller
% 10 September 2012
%
%%%%%

clear all
clc

trials = 10;
[maplmc,timvec] = load_fredo_data( 2, 'stim' );

for ii = 1:trials
    
    x = maplmc(:,:,:,ii);
    x = bandpass_filter( x, 5, 20, 4, 110 );
    x = zscore_independent( x );
    xh = hilbert_transform( x );
    xn = complex_exponential_reconstruction( abs(xh), angle(xh) );
    [ep,eps] = signal_reconstruction_error( x, xn )
    
end