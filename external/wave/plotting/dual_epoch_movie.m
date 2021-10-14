function dual_epoch_movie( ...
    x, y, color_axis, plot_axis, Fs, save_option, normalized_flag )
% *WAVE*
%
% EPOCH MOVIE    image/surface animation of a wave propagation epoch
%
% INPUT:
% x - datacube (r,c,t)
% y - datacube 2 (r,c,t)
% color_axis - caxis for imagesc plot [lo hi]
% plot_axis - range for the line plot [lo hi]
% Fs - sampling frequency (s) Hz
% save_option - either plot or save the files
%
% OUTPUT
% animated plot
%

% init
assert( ndims(x) == 3, 'datacube input required' );
if nargin > 6,
    if strcmp( normalized_flag, 'normalized' );norm_flag=1;else norm_flag=0;end
else norm_flag = 0;
end 

timvec = (1/Fs):(1/Fs):(size(x,3)/Fs);

f1 = figure;set( f1, 'position', [ 1512  199  872  505 ] )
h1 = axes(); h2 = axes(); h3 = axes(); h4 = axes();
set( h1, 'position', [ 0.0522    0.0350    0.4210    0.6091 ] )
set( h2, 'position', [ 0.2090    0.7228    0.2624    0.2412 ] )
set( h3, 'position', [ 0.5626    0.0350    0.4214    0.6091 ] )
set( h4, 'position', [ 0.7175    0.7228    0.2630    0.2412 ] )

set( f1, 'currentaxes', h1 );
image_plot = imagesc( x(:,:,1) );hold on;
cb = colorbar;
set( cb, 'position', [ 0.5046    0.5228    0.0191    0.1261 ] )
set( get(cb,'ylabel'), 'string', 'z-score' )
if norm_flag,
    set( cb, 'ytick', [-1 0 1] );
    set( get(cb,'ylabel'), 'string', 'norm. amplitude' )
end

set( gca, 'xtick', [] );set( gca, 'ytick', [] )
caxis( color_axis );axis image;colormap bone;

set( f1, 'currentaxes', h3 );
image_plot2 = imagesc( y(:,:,1) );hold on;
    
set( gca, 'xtick', [] );set( gca, 'ytick', [] )
caxis( color_axis );axis image;colormap bone;

set( f1, 'currentaxes', h2 );hold on
plot( timvec, reshape( x, size(x,1)*size(x,2), [] )', ...
    'color', [.7 .7 .7], 'linewidth', 1 );
ylim( plot_axis );xlim( [timvec(1) timvec(end)] );
xlabel( 'time (s)' );ylabel( 'z-score' );

line_plot = line( [timvec(1) timvec(1)], plot_axis );
set( line_plot, 'linestyle', ':', 'color', 'r' )

if norm_flag;set( gca, 'ytick', [-1 0 1] );ylabel( 'norm. amplitude' );end

set( f1, 'currentaxes', h4 );hold on
plot( timvec, reshape( y, size(y,1)*size(y,2), [] )', ...
    'color', [.7 .7 .7], 'linewidth', 1 );
ylim( plot_axis );xlim( [timvec(1) timvec(end)] );
xlabel( 'time (s)' );ylabel( 'z-score' );

line_plot2 = line( [timvec(1) timvec(1)], plot_axis );
set( line_plot2, 'linestyle', ':', 'color', 'r' )

if norm_flag;set( gca, 'ytick', [-1 0 1] );ylabel( 'norm. amplitude' );end

for ii = 1:size(x,3)

    set( f1, 'currentaxes', h1 );hold on
    set( image_plot, 'cdata', x(:,:,ii) )
    set( f1, 'currentaxes', h2 );hold off;
    set( line_plot, 'xdata', [timvec(ii) timvec(ii)] );
    
    set( f1, 'currentaxes', h3 );hold on
    set( image_plot2, 'cdata', y(:,:,ii) )
    set( f1, 'currentaxes', h4 );hold off;
    set( line_plot2, 'xdata', [timvec(ii) timvec(ii)] );
    
    if save_option == 0
        pause(.01)
    elseif save_option == 1
        export_fig( ...
           sprintf( './tmp/frame_%03d.jpg', ii ), '-r150', '-nocrop', '-transparent' )
    end
        
end
