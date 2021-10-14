function [radavg, radstd, frequencies] = spatial_frequency_radial_average( x, bin_size, spacing_x, spacing_y )
% *WAVE*
%
% SPATIAL FREQUENCY RADIAL AVERAGE     returns the radially averaged
%                                       spatial frequency
%
% INPUT
% x - data matrix (r,c)
%
% OUTPUT
% fo - 1d output
%

assert( ndims(x) == 2, 'data matrix input required' );

% take fft2
x = fft2( x ); 
x = fftshift( x );
x = abs(x);

% frequency axis
mx = -floor(size(x,2)/2):(size(x,2)-1)/2;   % centered index
my = -floor(size(x,1)/2):(size(x,1)-1)/2;   % centered index
my = fliplr(my);                            % increase upwards
Fx = mx/(size(x,2)*spacing_x);              % frequency at x, centered
Fy = my/(size(x,1)*spacing_y);              % frequency at y, centered
[Fx,Fy] = meshgrid(Fx,Fy);
F = sqrt( Fx.^2 + Fy.^2 );

maximum_frequency = max(max(F));
frequencies = bin_size:bin_size:maximum_frequency;

radavg = zeros(size(frequencies));
radstd = zeros(size(frequencies));
for ii = 1:length(frequencies)
    i = find( (F > (frequencies(ii) - (bin_size/2))) & ...
        (F < (frequencies(ii) + (bin_size/2))) );
    radavg(ii) = mean(x(i));
    radstd(ii) = std(x(i));
end
