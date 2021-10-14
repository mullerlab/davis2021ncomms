function plot_dcolor_set( rh, th, ii )
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

assert( (ndims(rh)==3) && (ndims(th)==3) , 'datacube input required' )
assert( isequal(size(rh),size(th)) , 'shape mismatch' )

[r,c,~] = size(rh);

kk = zeros(r,c);
for rr = 1:r
    for cc = 1:c
        [a,b] = pol2cart( th(rr,cc,ii), rh(rr,cc,ii) );
        kk(rr,cc) = a + (1i*b);       
    end
end

kk = z2rgb(kk);
image(kk)
set(gca,'XDir','normal')
set(gca,'YDir','reverse')
shading flat;axis image;axis off
