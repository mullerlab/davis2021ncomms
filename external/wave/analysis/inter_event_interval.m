function iei = inter_event_interval( epochs, Fs, type, window_offset )
% *WAVE*
%
% INTER EVENT INTERVAL      calculate inter-event interval in a several
%                               ways using the structure of event times
%
% INPUT
% ep - epochs structure
% Fs - sampling frequency (Hz)
% type - calculation type (midpoint/start-to-end)
% window_offset - offset for window-based calculations
%
% OUTPUT
% iei - inter-event intervals
%

assert( isstruct(epochs), 'structure input required, epochs' )
assert( isscalar(Fs), 'scalar input required, Fs' )

% parse optional arguments
if ~isempty( window_offset )
    window_flag = 1;
else
    window_flag = 0;
end

% init
iei = zeros( 1, length(epochs)-1 );

if ( strcmp( type, 'midpoint' ) && ( window_flag == 0 ) )
    
    for ii = 1:( length(epochs) - 1 )
        
        first_point = ( epochs(ii).start_time + epochs(ii).end_time ) / 2;
        second_point = ( epochs(ii+1).start_time + epochs(ii+1).end_time ) / 2;
        if ~isempty( second_point )
            iei(ii) = ( second_point - first_point ) / Fs;
        else
            iei(ii) = NaN;
        end
        
    end
    
elseif ( strcmp( type, 'end-to-start' ) && ( window_flag == 0 ) )
    
    for ii = 1:( length(epochs) - 1 )
        
        first_point = epochs(ii).end_time;
        second_point = epochs(ii+1).start_time;
        iei(ii) = ( second_point - first_point ) / Fs;
        
    end
    
elseif ( strcmp( type, 'midpoint' ) && ( window_flag == 1 ) )
    
    for ii = 1:( length(epochs) - 1 )
        
        first_point = ( epochs(ii).start_time + epochs(ii).end_time ) / 2;
        second_point = ( epochs(ii+1).start_time + epochs(ii+1).end_time ) / 2;
        if ~isempty( second_point )
            iei(ii) = ( ( second_point - first_point ) * window_offset ) / Fs;
        else
            iei(ii) = NaN;
        end
        
    end
    
elseif ( strcmp( type, 'end-to-start' ) && ( window_flag == 1 ) )
    
    for ii = 1:( length(epochs) - 1 )
        
        first_point = epochs(ii).end_time;
        second_point = epochs(ii+1).start_time;
        iei(ii) = ( ( second_point - first_point ) * window_offset ) / Fs;
        
    end
    
end
