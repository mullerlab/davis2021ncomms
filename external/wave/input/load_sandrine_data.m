function [maplmc, timvec] = load_sandrine_data( file_number )
% *WAVE*
%
% LOAD SANDRINE DATA  loads data of the type given by the Marseille
%                       experimental group
%
% INPUT
% file_number - file number for wa_080208 session
%
% OUTPUT
% maplmc - trial datacube (r,c,t,trials)
% timvec - time vector for these experiments (1,t)
%

S = load( ...
 sprintf( '/Users/lyle/Documents/data/int/sandrine/trial_averages/wa080208_%d.mat', file_number ) );
maplmc = S.( sprintf('map%dn',file_number) );
timvec = S.timvec;
xrange = 168; yrange = 246; trange = 77; trials = size(maplmc,3);

maplmc = reshape( maplmc, [ xrange yrange trange trials ] );
