function plot_dcolor( rh, th )
% *WAVE* 
%
% PLOT DCOLOR SET      surface complex domain plot of the 
%                        two real input datacubes at the time
%                        point *ii*
%
% INPUT: 
% rh      - modulus datacube (r,c,t)
% th      - angle datacube (r,c,t)
% timevec - timestamp vector (1,t)
% ii      - time point of interest
%
% OUTPUT
% animated complex domain coloring plot
%
% DEPENDENCIES
% z2rgb (WAVE) 
%

assert( (ndims(rh)==2) && (ndims(th)==2) , 'data matrix input required' )
assert( isequal(size(rh),size(th)) , 'shape mismatch' )

[r,c,~] = size(rh);

% polar to cartesian coordinates
kk = zeros(r,c);
for rr = 1:r
    for cc = 1:c
        [a,b] = pol2cart( th(rr,cc), rh(rr,cc) );
        kk(rr,cc) = a + (1i*b);       
    end
end

% convert to domain coloring plot
kk = z2rgb(kk);

% plotting
image(kk)
set(gca,'XDir','normal')
set(gca,'YDir','reverse')
shading flat;axis image;axis off
