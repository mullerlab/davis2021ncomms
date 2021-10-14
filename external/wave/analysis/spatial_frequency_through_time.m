function [sp, freq] = spatial_frequency_through_time( x, bin_size, spacing_x, spacing_y )
% *WAVE*
%
% SPATIAL FREQUENCY THROUGH TIME     returns the spatial frequency (x,y) 
%                                    through time for an input datacube x
%
% INPUT
% x - datacube input (r,c,t)
%
% OUPTUT
% sp - spatial frequency through time matrix
%

assert(ndims(x) == 3,'data cube input required');

% initialization
[~,~,freq] = spatial_frequency_radial_average( x(:,:,1), bin_size, spacing_x, spacing_y );
sp = zeros( length(freq), size(x,3) );
sp_std = zeros( length(freq), size(x,3) );

for ii = 1:size(x,3)
    
    [sp(:,ii),sp_std(:,ii),freq] = spatial_frequency_radial_average( x(:,:,ii), bin_size, spacing_x, spacing_y );
    
end
