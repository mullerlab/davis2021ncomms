function play_movie_pause( x, timevec, tstart, tstop )
% *WAVE* 
%
% PLAY MOVIE PAUSE    surface animation of the input datacube (w/ pauses)
%
% INPUT: 
% x - datacube (r,c,t)
% timevec - timestamp vector (1,t)
% tstart - start sample #
% tstop - stop sample #
%
% OUTPUT
% animated plot
%

assert(ndims(x) == 3,'datacube input required');

x_min = min(min(min(x(:,:,tstart:tstop))));
x_max = max(max(max(x(:,:,tstart:tstop))));

for ii = tstart:tstop
    pcolor(x(:,:,ii));set(gca,'XDir','normal');set(gca,'YDir','reverse');shading flat;axis image;
    caxis([x_min x_max]);%caxis([color_axis(1) color_axis(2)])
    str = sprintf('Time: %2.3f ms', timevec(ii));title(str)
    colorbar;colormap('jet');
    pause
end
