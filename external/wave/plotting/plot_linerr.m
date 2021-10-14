function [h] = plot_linerr( xaxis, data, err )
% *WAVE*
%
% PLOT LINERR            errorbar plot with lines for the errors
%
% INPUT:
% xaxis - x values
% data - main data
% err - data + err (forms the lines)
%
% OUTPUT
% plot
%

default_color = [.5 .5 .5];
default_err_color = [.75 .75 .75];

h = zeros( 1, 3 ); hold on;

% plot
h(1) = plot( xaxis, data, 'linewidth', 2, 'color', default_color );
h(2) = plot( xaxis, data+err, ':', 'linewidth', 2, 'color', default_err_color );
h(3) = plot( xaxis, data-err, ':', 'linewidth', 2, 'color', default_err_color );

