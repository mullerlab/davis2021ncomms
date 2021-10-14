function plot_power_spectrum( x, Fs, plot_option )
% *WAVE* 
%
% PLOT POWER SPECTRUM     plot the power spectrum from a single channel
%
% INPUT: 
% x - vector input (1,t)
% Fs - sampling frequency
% plot_option - linear or log y-scale (0/1, respectively)
%
% OUTPUT
% linear plot
%

assert( isvector( x ), 'vector input required' )

% take power spectrum
nfft= 2^(nextpow2(length(x)));
fftx = fft(x,nfft);
NumUniquePts = ceil((nfft+1)/2);
fftx = fftx(1:NumUniquePts);
mx = abs(fftx)/length(x);

if plot_option == 1, mx = mx.^2; end

% odd nfft excludes Nyquist point
if rem(nfft, 2) 
    mx(2:end) = mx(2:end)*2;
else
    mx(2:end-1) = mx(2:end-1)*2;
end

% frequency axis 
f = (0:NumUniquePts-1)*Fs/nfft;

% plotting
if plot_option == 0
    plot(f,mx)
    ylabel('Magnitude');
elseif plot_option == 1
    plot(f,10*log10(mx));
    ylabel('Power (dB)');
end

title('Power Spectrum');
xlabel('Frequency (Hz)');
