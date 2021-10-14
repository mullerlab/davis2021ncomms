%
% inter_event_interval - unit test
% lyle muller
% 10 march 2015
%

clear all;clc %#ok<CLSCR>

% parameters
N = 100; % epochs
duration = 15;
interval = 10;

% build test structure
ep = struct([]); ep(1).start_time = 1; ep(1).end_time = 1+duration;
for ii = 2:N
    ep(ii).start_time = ep(ii-1).end_time + interval;
    ep(ii).end_time = ep(ii).start_time + duration;
end

% calculate inter event intervals
iei = inter_event_interval( ep, 1, 'midpoint', [] );

