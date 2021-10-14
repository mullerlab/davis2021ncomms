function plot_epoch( epoch, pl, pixel_spacing )
% *WAVE*
%
% PLOT EPOCH            Phase latency and PLCD plot for visualizing epoch
%
% INPUT:
% epoch
% pl
% pixel_spacing
%
% OUTPUT
% animated plot
%

% pl map
f1 = figure;

plotting_point = epoch.peak_cc_index(1);
smooth_pl = smoothn( pl(:,:,plotting_point) );

imagesc( smooth_pl )
set( gca, 'xtick', [] )
set( gca, 'ytick', [] )
xlabel( 'electrodes', 'fontsize', 12 )
ylabel( 'electrodes', 'fontsize', 12 )

% distance inset
f2 = figure;hold on

% make distance matrix
[y1,x1] = find( smooth_pl == min(smooth_pl(:)) );
[X,Y] = meshgrid( (1:size(pl,2))-x1, (1:size(pl,1))-y1 );
D = sqrt( X.^2 + Y.^2 );
D = D.*pixel_spacing;

% plot correlation
tmp_pl = pl(:,:,plotting_point);
nanfield = isnan(tmp_pl);
tmp_pl = tmp_pl(:);tmp_pl( isnan(tmp_pl) ) = [];
D( nanfield ) = NaN;D = D(:);D( isnan(D) ) = [];
tmp_pl = tmp_pl - tmp_pl(end);
s = polyfit( D, tmp_pl, 1 );
s = polyval( s, linspace( min(D), max(D), 100 ) );
xlabel( 'distance (mm)', 'fontsize', 14 )
ylabel( 'phase latency (ms)', 'fontsize', 14 )
%ylim([-.0095 .045]);xlim([.2 5]);
box on
set( gca, 'xtick', [1:5] ) %#ok<NBRAK>

plot( D, tmp_pl, 'k.','markersize', 18 );
plot( linspace( min(D), max(D), 100 ), s, 'r', 'linewidth', 2 );

[h1,h2] = inset( f2, f1 );
close(f1);close(f2)
set( h2, 'position', [.18 .7 .2 .2] )
set(gca,'linewidth',2)

set( h1, 'fontname', 'Arial' );set( h1, 'fontsize', 12 );
set( h2, 'fontname', 'Arial' );set( h2, 'fontsize', 11 );
set( h1, 'linewidth', 2 )


