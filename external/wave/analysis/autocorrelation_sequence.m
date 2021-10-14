function [xo,distances] = autocorrelation_sequence( x, bin_size, pixel_spacing )
% *WAVE*
%
% AUTOCORRELATION MATRIX    returns a matrix of radially averaged
%                               autocorrelation sequences from datacube x
%
% INPUT
% x - datacube input (r,c,t)
% bin_size - width of the radial average binning %px
% pixel_spacing - physical spacing of the detectors
%
% OUTPUT
% xo - output matrix of autocorrelation sequences across trials
% distances - vector of spatial distances
%

assert( ndims(x) == 3, 'data cube input required' )

[rad,~,distances] = radial_average( xcorr2( x(:,:,1), x(:,:,1) ), size(x,2), size(x,1), ...
                                                        bin_size, pixel_spacing );

xo = zeros( length(rad), size(x,3) );                                     
rows = size(x,1);
cols = size(x,2);
                                                    
for ii = 1:size(x,3)
    
    b = xcorr2( x(:,:,ii), x(:,:,ii) );
    s = sum( reshape( x(:,:,ii).^2, 1, [] ) );
    xo(:,ii) = radial_average( b, cols, rows, bin_size, pixel_spacing );
    xo(:,ii) = xo(:,ii) / s;
    
end

