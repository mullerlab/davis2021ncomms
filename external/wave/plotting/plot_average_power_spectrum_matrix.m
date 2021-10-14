function [mx,f] = plot_average_power_spectrum_matrix( x, Fs, plot_option, plotting )
% *WAVE*
%
% PLOT AVERAGE POWER SPECTRUM MATRIX    plot the average power spectrum from
%                                        multichannel data
%
% INPUT:
% x - datacube (r,c,t)
% Fs - sampling frequency
% plot_option - linear or log y-scale (0/1, respectively)
%
% OUTPUT
% linear plot
%

assert( ismatrix(x), 'matrix input required' );

% take power spectrum, for each channel
nfft= 2^(nextpow2(length(x)));
fftx = fft(x,nfft,2);
NumUniquePts = ceil((nfft+1)/2);
fftx = fftx(:,1:NumUniquePts);
mx = abs(fftx)/length(x);
mx = mx.^2;

% odd nfft excludes Nyquist point
if rem(nfft, 2)
    mx(2:end) = mx(2:end)*2;
else
    mx(2:end -1) = mx(2:end -1)*2;
end

% average the power spectra
mx = nanmean(mx, 1);

% frequency axis
f = (0:NumUniquePts-1)*Fs/nfft;

if plotting == 1
    
    % plotting
    if plot_option == 0
        plot(f,mx)
    elseif plot_option == 1
        plot(f,10*log10(mx));
    end
    
    title( 'Power Spectrum' );
    xlabel( 'Frequency (Hz)' );
    ylabel( 'Power (dB)' );
    
end
