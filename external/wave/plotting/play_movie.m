function play_movie( x, varargin )
% *WAVE*
%
% PLAY MOVIE    image/surface animation of the input datacube
%
% INPUT:
% x - datacube (r,c,t)
%
% --to identify by string:
%
% plot_method - choose either imagesc or surf plot
% color_range - zaxis scale
% time_range - length of time axis to plot
% time_stamps - timvec for the title in plot
% time_units - time units to display in plot, next to time_stamps
%
% OUTPUT
% animated plot
%

assert( ndims(x) == 3, 'datacube input required' );

% default parameter structure
def.plot_method = 'imagesc'; % imagesc | surf
def.color_range = [min(x(:)) max(x(:))];
def.time_range = [1 size(x,3)];
def.time_stamps = [];
def.time_units = '';

% parse input parameters
parserObj = inputParser;
parserObj.FunctionName = 'play_movie';
if ~isempty(varargin)
    
    parserObj.addOptional( 'plot_method', def.plot_method );
    parserObj.addOptional( 'color_range', def.color_range );
    parserObj.addOptional( 'time_range', def.time_range );
    parserObj.addOptional( 'time_stamps', def.time_stamps );
    parserObj.addOptional( 'time_units', def.time_units );
    
    parserObj.parse(varargin{:});
    opt = parserObj.Results;
    
else
    
    % take the defaults
    opt = def;
    
end

assert( isvector( opt.time_range ), 'vector input required for time vector' )
if ~isempty( opt.time_stamps )
    assert( isequal( length( opt.time_stamps ), size(x,3) ), 'timvec must equal datacube len' )
end
assert( ischar( opt.time_units ), 'character array required for time units' )

% color range
if ( ( length( opt.time_range ) ~= size(x,3) ) && ( isequal( opt.color_range, def.color_range ) ) )
    
    opt.color_range = [ min( reshape(x(:,:,opt.time_range(1):opt.time_range(2)),1,[]) ) ...
        max( reshape(x(:,:,opt.time_range(1):opt.time_range(2)),1,[]) ) ];
    
end

% time stamps
%if isempty( opt.time_stamps )
%    opt.time_stamps = opt.time_range(1):opt.time_range(2);
%end

% hold on; cb = colorbar;
% set( get(cb,'ylabel'), 'string', 'z-score' )
% set( gca, 'fontname', 'arial', 'fontsize', 14 )
% set( cb, 'ytick', -2:2 )

% plotting method
if strcmp( opt.plot_method, 'imagesc' )
    
    image_plot = imagesc( x(:,:,opt.time_range(1)) );
    axis image; caxis(opt.color_range); colormap('bone'); axis off
    for ii = opt.time_range(1):opt.time_range(2)
        
        set( image_plot, 'cdata', x(:,:,ii) )
        %str = sprintf('%2.3f %s', opt.time_stamps(ii), opt.time_units );title(str)
        str = sprintf('%d', ii);title(str)
%         h = line( [200 217.6678], [130 130] ); set( h, 'color', 'r', 'linewidth', 5 );
        pause(.1); % defines the frame rate
%         export_fig( sprintf('./tmp/frame_%03d.jpg',ii ), '-r150', '-nocrop', '-transparent' )
        
    end
    
elseif strcmp( opt.plot_method, 'surf' )
    
    for ii = opt.time_range(1):opt.time_range(2)
        
        surf( x(:,:,ii) );zlim(opt.color_range);caxis(opt.color_range)
        view([45 45])
        %str = sprintf('%2.3f %s', opt.time_stamps(ii), opt.time_units );title(str)
        colorbar;colormap('bone')
        pause(.01);
        
    end
    
elseif strcmp( opt.plot_method, 'dots' )
    
    [X1,X2] = meshgrid( 1:size(x,2), 1:size(x,1) );
    
    for ii = opt.time_range(1):opt.time_range(2)
        
        plot3( X1, X2, x(:,:,ii), 'k.', 'markersize', 20 );
        zlim(opt.color_range);caxis(opt.color_range)
        view([45 45]);grid on
        %str = sprintf('%2.3f %s', opt.time_stamps(ii), opt.time_units );title(str)
        colorbar;colormap('bone')
        pause(.1);
        
    end
    
end

