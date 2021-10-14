function [spatial_correlation,distances] = ...
    spatial_correlation( x, bin_size, number_pairs, pixel_spacing )
% *WAVE*
%
% SPATIAL CORRELATION    returns the spatial correlation vector from
%                           datacube x (Monte Carlo implementation)
%
% INPUT
% x - datacube input (r,c,t)
% bin_size - width of the radial average binning %px
% number_paris - number of iterations to do at each distance D
% pixel_spacing - physical spacing of the detectors
%
% OUTPUT
% xo - output matrix of autocorrelation sequences across trials
% distances - vector of spatial distances
%

assert( ndims(x) == 3, 'data cube input required' )

max_dist = sqrt( (size(x,1)-1).^2 + (size(x,2)-1).^2 );
distances = (bin_size:bin_size:max_dist)*pixel_spacing;
bin_size = bin_size * pixel_spacing; % bin size in pixels

spatial_correlation = zeros( 1, length(distances) );

iteration_threshold = 5000;

for dd = 1:length(distances)
    
    tmp_cc = zeros( 1, number_pairs );
    
    for ii = 1:number_pairs
        
        ind = [];cc = 0;
        while ( isempty(ind) )
            
            % (1) pick a channel at random
            chan = zeros( 1, 2 );
            chan(1) = randi( size(x,1), 1 );chan(2) = randi( size(x,2), 1 );
            
            % (2) pick a random channel at distance D
            [X,Y] = meshgrid( (1:size(x,2))-chan(2), (1:size(x,1))-chan(1) );
            D = sqrt( X.^2 + Y.^2 ) * pixel_spacing;
            
            ind = find( ( D > (distances(dd) - (bin_size/2)) ) & ...
                ( D < (distances(dd) + (bin_size/2)) ) );
            
            cc = cc + 1;
            if ( cc >= iteration_threshold );
                error( 'iteration threshold exceeded' ); end
            
        end
        
        % correlation of selected channels
        ind = ind( randi( length(ind), 1 ) );
        [i,j] = ind2sub( size(x), ind );
        tmp_cc(ii) = corr( reshape( x( chan(1), chan(2), : ), [] , 1 ), ...
            reshape( x( i, j, : ), [] , 1 ) );
        
    end
    
    % Fisher z
    tmp_cc = .5 * log( (1+tmp_cc) ./ (1-tmp_cc) );
    spatial_correlation(dd) = nanmean( tmp_cc );
    
end

spatial_correlation = ( (exp(2*spatial_correlation)-1) ./ ...
    (exp(2*spatial_correlation)+1) );
