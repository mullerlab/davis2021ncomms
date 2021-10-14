function print_movie( x, timevec, tstart, tstop, filename, fps )
% *WAVE* 
%
% PRINT MOVIE     print surface animation to AVI file
%
% INPUT: 
% x - datacube (r,c,t)
% timevec - timestamp vector (1,t)
% tstart - start sample #
% tstop - stop sample #
%
% OUTPUT
% AVI file w/filename
%

assert( ndims(x) == 3, 'datacube input required' );

% get bounds
x_min = min(min(min(x(:,:,tstart:tstop))));
x_max = max(max(max(x(:,:,tstart:tstop))));

% open movie object
movie = avifile(filename);
movie.Fps = fps;
movie.Quality = 100;
movie

for ii = tstart:tstop
    pcolor(x(:,:,ii));set(gca,'XDir','normal');set(gca,'YDir','reverse');shading flat;
    caxis([x_min x_max]);
    set(gca,'fontname','Georgia');
    set(gca,'fontsize',36);
    str = sprintf('Time: %2.3f ms', timevec(ii));title(str)
    %colorbar;colormap('jet');
    axis image;axis off
    pause(.01);
    if (ii==1)
        pause
    end
    F = getframe(gcf);
    movie = addframe(movie,F);
end

% close movie object
movie = close(movie); 

