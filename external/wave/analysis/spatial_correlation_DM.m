function [spatial_correlation,bin_size] = ...
    spatial_correlation_DM( x, number_bins, number_pairs, distance_matrix, channel_map )
% *WAVE*
%
% SPATIAL CORRELATION DM   returns the spatial correlation vector from
%                           datacube x (Monte Carlo implementation), using
%                           an arbitrary distance matrix (DM)
%
% INPUT
% x - datacube input (r,c,t)
% number_bins - number of bins to use
% number_paris - number of iterations to do at each distance bin
% distance_matrix - distances between the detectors
% channel_map - channel numbering
%
% OUTPUT
% xo - output matrix of autocorrelation sequences across trials
% bin_separation - separation between adjacent spatial bins
%

assert( ndims(x) == 3, 'data cube input required' )

max_dist = max( distance_matrix(:) );
distances = linspace( 0, max_dist, number_bins + 1 ); distances = distances(2:end);
bin_size = distances(2) - distances(1);

spatial_correlation = zeros( 1, length(distances) );

iteration_threshold = 5000;

for dd = 1:length(distances)
    
    tmp_cc = zeros( 1, number_pairs );
    
    for ii = 1:number_pairs
        
        ind = [];cc = 0;
        while ( isempty(ind) )
            
            % (1) pick a channel at random (index)
            chan = randi( size(x,1)*size(x,2), 1 );
            
            % (2) pick a random channel at distance D
            ind = find( ...
                ( distance_matrix(chan,:) > (distances(dd) - (bin_size/2)) ) & ...
                ( distance_matrix(chan,:) < (distances(dd) + (bin_size/2)) ) );
            
            cc = cc + 1;
            if ( cc >= iteration_threshold );
                error( 'iteration threshold exceeded' ); end
            
        end
        
        % correlation of selected channels
        ind = ind( randi( length(ind), 1 ) );
        [i,j] = channel_to_index( ind, channel_map );
        [chan1,chan2] = channel_to_index( chan, channel_map );
        tmp_cc(ii) = corr( reshape( x( chan1, chan2, : ), [] , 1 ), ...
            reshape( x( i, j, : ), [] , 1 ) );
        
    end
    
    % Fisher z
    tmp_cc = .5 * log( (1+tmp_cc) ./ (1-tmp_cc) );
    spatial_correlation(dd) = nanmean( tmp_cc );
    
end

spatial_correlation = ( (exp(2*spatial_correlation)-1) ./ ...
    (exp(2*spatial_correlation)+1) );
