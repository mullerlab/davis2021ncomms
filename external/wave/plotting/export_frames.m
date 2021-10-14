function export_frames( x, time_points, color_axis, timvec )
% *WAVE*
%
% EXPORT FRAMES     exports PNG frames from a MATLAB datacube, suitable for
%                       use with INKSCAPE and FFMPEG on Linux (script
%                       packaged separately)
%
% INPUT
% x - datacube (r,c,t)
% filename - /path/to/outputfile
% 
% OUTPUT
% movie frames in a temporary directory
%

assert( ndims(x) == 3, 'datacube input required' )
assert( numel(time_points) == 2, 'specify only two start/stop points' )
assert( numel(color_axis) == 2, 'specify only two points, color_axis' )

% make temporary directory for the files
if ( exist( './tmp', 'dir' ) == 7 )
    cc = 0;
    while ( exist( sprintf('./tmp_%d',cc), 'dir' ) == 7  )
        cc = cc + 1;
    end
    directory_name = sprintf( './tmp_%d', cc );
elseif ( exist( './tmp', 'dir' ) == 0 )
    directory_name = './tmp';
end
mkdir(directory_name);
cd(directory_name);

% make panels
figure;
for ii = time_points(1):time_points(2)
   
    imagesc( x(:,:,ii) );axis image;caxis( color_axis )
    %title( sprintf( '%1.0f ms', ii - (time_points(1)-1) ) );
    title( sprintf( '%2.1f ms', timvec(ii)*1000 ) );
    cb = colorbar;colormap('jet');
    set( get(cb,'ylabel'), 'string', 'Z-score' )
    %set( cb, 'ytick', [0 .25 .5 .75 1] )
    axis off;set( gcf, 'color', 'w' );
    %export_fig( sprintf( './frame_%02d.png', ii - (time_points(1)-1) ), '-transparent', '-nocrop' )
    export_fig( sprintf( './frame_%03d.jpg', ii - (time_points(1)-1) ), '-r150', '-nocrop' )
    
end

% change back
cd('..')
