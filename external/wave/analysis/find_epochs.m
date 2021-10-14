function epochs = find_epochs( cc, threshold, speed, modulus, varargin )
% *WAVE*
%
% FIND EPOCHS      locate epochs in a logical array, based on some simple
%                       heuristic parameters
%
% INPUT
% cc - correlation array (1,t)
% threshold - thresholding value, to produce a logical array (sc)
% modulus - modulus at phase angle crossing (1,t)
% speed - propagation speed estimate from slope of regressor line (1,t)
%
% corr/pval flag - controls thresholding of the logical array for
%                   correlation or p-values (change 12oct14 LM, backwards
%                   compatible)
%
% OUTPUT
% epochs - structure with epoch start/end times
%

assert( isvector(cc) == 1, 'vector input required, cc' )
assert( isscalar(threshold), 'scalar input required, threshold' )
assert( isvector(speed) == 1, 'vector input required, speed' )
assert( ndims(modulus) == 3, 'datacube input required, modulus' )

% FLAG - corr/pval
assert( length( varargin ) < 2, 'too many inputs' )
if ( isempty( varargin ) )
    corr_flag = 1;
elseif ( strcmp( varargin{1}, 'corr' ) )
    corr_flag = 1;
elseif ( strcmp( varargin{1}, 'pval' ) )
    corr_flag = 0;
end

% init
epochs = struct([]);

% threshold the logical array
if corr_flag
    L = ( cc > threshold );
elseif ~corr_flag
    L = ( cc < threshold );
end

% loop through L
epoch_found = 0;
epoch_number = 0;
for ii = 1:length(L)-1
    
    if L(ii)
        
        if ~epoch_found
            
            epoch_found = 1;
            epoch_number = epoch_number + 1;
            epochs(epoch_number).start_time = ii; % working in INDs
            
        elseif epoch_found
            
            % do nothing
            
        end
        
    elseif ~L(ii)
        
        if ( epoch_found && ~L(ii+1) )
            
            epochs(epoch_number).end_time = ii;
            epoch_found = 0;
            
        elseif ( epoch_found && L(ii+1) )
            
            % do nothing -- allowing gaps of one sample
            
        end
        
    end
    
end

% check output
for ii = 1:length(epochs)
    
    if ~isfield( epochs(ii), 'end_time' )
        epochs(ii).end_time = length(L);
    end
    
end

% calculate summary statistics
for ii = 1:length(epochs)

    if corr_flag
        epochs(ii).peak_cc = max( cc( epochs(ii).start_time:epochs(ii).end_time ) );
        epochs(ii).peak_cc_index = find( cc(epochs(ii).start_time:epochs(ii).end_time) == ...
            max(cc(epochs(ii).start_time:epochs(ii).end_time)) ) + epochs(ii).start_time - 1;
    elseif ~corr_flag
        epochs(ii).peak_cc = min( cc( epochs(ii).start_time:epochs(ii).end_time ) );
        epochs(ii).peak_cc_index = find( cc(epochs(ii).start_time:epochs(ii).end_time) == ...
            min(cc(epochs(ii).start_time:epochs(ii).end_time)) ) + epochs(ii).start_time - 1;
    end
    
    epochs(ii).mod_at_max_cc = modulus( epochs(ii).peak_cc_index );
    epochs(ii).epoch_length = epochs(ii).end_time - epochs(ii).start_time;
    epochs(ii).mean_speed = nanmean( speed( epochs(ii).start_time:epochs(ii).end_time ) );
        
end

