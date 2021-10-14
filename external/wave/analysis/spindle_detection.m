function [spindle] = ...
    spindle_detection( x, amplitude_threshold, duration_threshold, Fs )
% *WAVE*
%
% SPINDLE DETECTION    basic amplitude-duration spindle detection,
%                           one- and two-step variants, as in:
%
%           Johnson LA, Blakely T, Hermes D, Hakimian S, Ramsey NF, and
%               Ojemann JG (2012) Sleep spindles are locally modulated by
%               training on a brain-computer interface. PNAS 109: 18583-18588.
%
%           and
%
%           Molle M, Marshall L, Gais S, and Born J (2002) Grouping of
%               spindle activity during slow oscillations in human non-rapid
%               eye movement sleep. J Neurosci 22: 10941-10947.
%
% INPUT:
% x - datacube (r,c,t)
% amplitude_threshold - amplitude threshold (s OR [lo hi])
% duration_threshold - duration threshold (s OR [lo hi])
% Fs - sampling frequency (s, Hz)
%
% OUTPUT
% spindle - structure with epoch information
%

% check input
assert( ndims(x) == 3, 'datacube input required' );
assert( length(amplitude_threshold) <= 2, 'too many inputs, amplitude threshold' )
assert( length(duration_threshold) <= 2, 'too many inputs, duration threshold' )
assert( length(amplitude_threshold) == length(duration_threshold), ...
    'amplitude and duration thresholds must have equal length (1 or 2 inputs)' )

% primary detection
if length( amplitude_threshold ) == 1
    
    [spindle] = one_step_detection( x, ...
        amplitude_threshold, duration_threshold, Fs );
    
elseif length( amplitude_threshold ) == 2
    
    [spindle] = two_step_detection( x, ...
        amplitude_threshold, duration_threshold, Fs );
    
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [spindle] = ...
    one_step_detection( x, amplitude_threshold, duration_threshold, Fs )

amp_th = ones( size(x) ) * amplitude_threshold; %(r,c,t)
dur_th = round( duration_threshold * Fs ); % (s), duration in samples

x = ( x > amp_th );
spindle = struct([]);
spindle_number = 0;

for ii = 1:size(x,1)
    for jj = 1:size(x,2)
        
        k = reshape( x(ii,jj,:), 1, [] );
        ind_up = find( diff( [0 k 0] ) == 1 ); % note aux vector & hcat
        ind_down = find( diff( [0 k 0] ) == -1 );
        
        for kk = 1:length(ind_up)
            
            if ( ( ind_down(kk) - ind_up(kk) ) >= dur_th )
                
                % spindle!
                spindle_number = spindle_number + 1;
                spindle(spindle_number).start_time = ind_up(kk);
                spindle(spindle_number).end_time = ind_down(kk);
                spindle(spindle_number).duration = ...
                    ( ind_down(kk) - ind_up(kk) );
                spindle(spindle_number).row = ii;
                spindle(spindle_number).col = jj;
                
            end
            
        end
        
    end
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [spindle] = ...
    two_step_detection( x, amplitude_threshold, duration_threshold, Fs )

amp_lo = ones( size(x) ) * amplitude_threshold(1); %(r,c,t)
amp_hi = ones( size(x) ) * amplitude_threshold(2); %(r,c,t)

dur_lo = round( duration_threshold(1) * Fs ); % (s), duration in samples
dur_hi = round( duration_threshold(2) * Fs ); % (s), duration in samples

% threshold
x_lo = ( x > amp_lo ); x_hi = ( x > amp_hi );

% init
spindle = struct([]);
spindle_number = 0;

for ii = 1:size(x,1)
    for jj = 1:size(x,2)
        
        k = reshape( x_lo(ii,jj,:), 1, [] );
        ind_up = find( diff( [0 k 0] ) == 1 );
        ind_down = find( diff( [0 k 0] ) == -1 );
        
        for kk = 1:length(ind_up)
            
            if ( ( ind_down(kk) - ind_up(kk) ) >= dur_lo )
                
                k2 = reshape( x_hi(ii,jj,ind_up(kk):ind_down(kk)), 1, [] );
                ind_up_2 = find( diff( [0 k2 0] ) == 1 );
                ind_down_2 = find( diff( [0 k2 0] ) == -1 );
                
                for ll = 1:length(ind_up_2)
                    
                    if ( (ind_down_2(ll) - ind_up_2(ll) ) >= dur_hi )
                        
                        % spindle!
                        spindle_number = spindle_number + 1;
                        spindle(spindle_number).start_time = ind_up(kk);
                        spindle(spindle_number).end_time = ind_down(kk);
                        spindle(spindle_number).duration = ...
                            ( ind_down(kk) - ind_up(kk) );
                        spindle(spindle_number).row = ii;
                        spindle(spindle_number).col = jj;
                        
                    end
                    
                end
                
            end
        end
    end
end

end
