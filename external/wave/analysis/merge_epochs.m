function epochs = merge_epochs( epochs, iei, threshold, Fs )
% *WAVE*
%
% MERGE EPOCHS      merge epochs in a given structure that occur within a
%                       certain time interval
%
% INPUT
% ep - epochs structure
% iei - inter-event intervals (sec)
% threshold - merge duration threshold (sec)
% Fs - sampling frequency (sc)
%
% OUTPUT
% epochs - structure with epoch start/end times
%

assert( isstruct(epochs), 'structure input required, epochs' )
assert( isscalar(threshold), 'scalar input required, threshold' )
assert( isscalar(Fs), 'scalar input required, Fs' )
assert( ...
    length(iei) == (length(epochs)-1), 'iei and epoch structure length mismatch' )

% find epochs to merge
to_merge = zeros( 1, length(epochs)-1 );
for ii = 1:( length(epochs) - 1 )
    
    % mark events to merge
    if ( iei(ii) <= threshold ), to_merge(ii) = 1; end
    
end

% find start and stop merge points
active_merge = 0; nmerges = 0; merge_start = []; merge_end = [];
for ii = 1:( length(epochs) - 1 )
    
    if ( to_merge(ii) == 1 ) && ( active_merge == 0 )
        
        active_merge = 1; nmerges = nmerges + 1;
        merge_start(nmerges) = ii; %#ok<AGROW>
        
    elseif ( to_merge(ii) == 0 ) && ( active_merge == 1 )
        
        active_merge = 0;
        merge_end(nmerges) = ii; %#ok<AGROW>
        
    end
      
end
if active_merge == 1, merge_end(nmerges) = length( epochs ); end

% rearrange 
for ii = 1:nmerges
    
    % rearrange
    epochs(merge_start(ii)).end_time = epochs(merge_end(ii)).end_time;
    epochs(merge_start(ii)).epoch_length = epochs(merge_start(ii)).end_time - ...
        epochs(merge_start(ii)).start_time;
    
    for jj = (merge_start(ii)+1):merge_end(ii)
        epochs(merge_start(ii)).index_row = ...
            [ epochs(merge_start(ii)).index_row; epochs(jj).index_row ];
        epochs(merge_start(ii)).index_column = ...
            [ epochs(merge_start(ii)).index_column; epochs(jj).index_column ];
    end
           
end

% delete
for ii = nmerges:-1:1
   
    epochs(merge_start(ii)+1:merge_end(ii)) = [];
    
end




