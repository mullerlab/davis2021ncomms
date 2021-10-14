function play_dcolor( rh, th, timevec, start, stop )
% *WAVE* 
%
% PLAY DCOLOR   surface complex domain animation of the 
%               two real input datacubes
%
% INPUT: 
% rh      - modulus datacube (r,c,t)
% th      - angle datacube (r,c,t)
% timevec - timestamp vector (1,t)
% tstart  - start sample #
% tstop   - stop sample #
%
% OUTPUT
% animated complex domain coloring plot
%

assert( (ndims(rh)==3) && (ndims(th)==3) , 'datacube input required' )
assert( isequal(size(rh),size(th)) , 'shape mismatch' )

[r,c,t] = size(rh);

kk = zeros(r,c,t);
for rr = 1:r
    for cc = 1:c
        for tt = 1:t
        
            [a,b] = pol2cart(th(rr,cc,tt),rh(rr,cc,tt));
            kk(rr,cc,tt) = a + (i*b);
        
        end
    end
end

for tt = start:stop
    dcolor(kk(:,:,tt));
    set(gca,'XDir','normal')
    set(gca,'YDir','reverse')
    shading flat;
    str = sprintf('Time: %2.3f ms', timevec(tt)); 
    title(str)
    pause(.01);
    if pause_choice
        pause
    end
end
