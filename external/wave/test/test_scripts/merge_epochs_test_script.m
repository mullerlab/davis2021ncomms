%
% inter_event_interval - unit test
% lyle muller
% 10 march 2015
%

%% general test

clear all;clc %#ok<CLSCR>

% parameters
N = 10; % epochs
duration = 10;
interval = 10;

% build test structure
ep = struct([]); ep(1).start_time = 1; ep(1).end_time = 1+duration;
ep(1).index_row = []; ep(1).index_column = [];
for ii = 2:N
    ep(ii).start_time = ep(ii-1).end_time + interval;
    ep(ii).end_time = ep(ii).start_time + duration;
end

ep(4).start_time = ep(3).end_time + 2;

% calculate inter event intervals
iei = inter_event_interval( ep, 1, 'midpoint', [] );

% merge epochs & recalculate iei
ep = merge_epochs( ep, iei, 17, 1 );
iei = inter_event_interval( ep, 1, 'midpoint', [] );

%% small (N=2) test

clear all;clc %#ok<CLSCR>

% build test structure
ep = struct([]); ep(1).start_time = 1; ep(1).end_time = 10;
ep(1).index_row = []; ep(1).index_column = [];
ep(2).start_time = 11; ep(2).end_time = 20;

% calculate inter event intervals
iei = inter_event_interval( ep, 1, 'end-to-start', [] );

% merge epochs & recalculate iei
ep = merge_epochs( ep, iei, 2, 1 );

