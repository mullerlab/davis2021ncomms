function x = load_human_data( state, part_number, epoch_number )
% *WAVE*
%
% LOAD HUMAN DATA  loads data of the type given by the Mass-Gen
%                       experimental group
%
% INPUT
% state - a string specifying sleep state
% part_number - integer specifying part number
% epoch number - integer specifying epoch
%
% OUTPUT
% x - datacube (r,c,t)
%

assert( ischar( state ) == 1 , 'state must be a string' )
assert( strcmp( state, 'awk') | strcmp( state, 'rem' ) | strcmp( state, 'sws' ),...
    'wrong value specified for state' )

% cd
initial_pwd = pwd;
cd( '~/Dropbox/data/mgh/MG29_5dec2012/' )
%cd( '~/Documents/data/mgh/MG29_5dec2012/' )

% load data
load( sprintf('%s_epochInfo', state) )
load('channel_mapping.mat')
bad_channels = [33 7 16 36 48 72 50 54 43 52 58 79 87];
load( sprintf('%s_part%d_epoch%d', state, part_number, epoch_number) )

% init
x = ones( 10, 10, size(LfpMtx,2) ) * NaN; %#ok<*NODEF>

for ii = 1:length(chans)
    
    channel_number = chans(ii);
    if ( sum( bad_channels == channel_number ) == 0 )
        
        [i,j] = find( channel_mapping == channel_number );
        x( i, j, : ) = LfpMtx(ii,:);
        
    end
    
end

% cd back to original directory
cd( initial_pwd )


