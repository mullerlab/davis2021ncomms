function [pm,pd] = phase_gradient_complex_multiplication_pppiv( xph, pixel_spacing )
% *WAVE*
%
% PHASE GRADIENT COMPLEX MULTIPLICATION PPPIV     take the gradient of the phase maps,
%                                                   returning datacubes of direction
%                                                   and magnitude
%
%                   For an analytic signal V_n = v_n + i*Hb[v_n],
%
%                   \nabla{Psi} = dPsi/dx + dPsi/dy
%
%                   dPsi/dx = dPsi_x = arctan( V_x V*_x+1 )
%           
%                       and
%
%                   dPsi/dy = dPsi_y = arctan( V_y V*_y+1 )
%
%                   Reference: Feldman (2011) Hilbert Transform
%                       Applications in Mechanical Vibration.
%                       Algorithm 3, p. 18. 
%
%                   With the dx/dy maps estimated above, the DCT-PLS
%                   (discrete cosine transform - penalized least squares)
%                   method from Garcia (2011) for post-processing of 
%                   particle image velocimetry data is applied.
%
%                   Reference: Garcia (2011) A fast all-in-one method for
%                   automated post-procesing of PIV data. Exp Fluids 50:
%                   1247 -- 1259.
%
% INPUT
% xph - analytic signal representation of the datacube (r,c,t)
%
% OUTPUT
% pm - phase gradient magnitude
% pd - phase gradient direction
%

assert( ndims(xph) == 3, 'datacube input required' );
pm = zeros( size(xph) );
pd = zeros( size(xph) );

for tt = 1:size(xph,3)    
    % dx
    dx = zeros( size(xph(:,:,1)) );
    for ii = 1:size(xph,1)
        dx(ii,(1:end-1)) = angle( xph(ii,1:end-1,tt) .* conj( xph(ii,2:end,tt) ) ) ./ pixel_spacing;
    end

    % dy
    dy = zeros( size(xph(:,:,1)) );
    for jj = 1:size(xph,2)
        dy((1:end-1),jj) = angle( xph(1:end-1,jj,tt) .* conj( xph(2:end,jj,tt) ) ) ./ pixel_spacing;
    end
    
    % pppiv
    [dx,dy] = pppiv(dx,dy);
    
    % make magnitude and direction maps
    pm(:,:,tt) = sqrt( dx.^2 + dy.^2 ) ./ (2*pi);
    pd(:,:,tt) = atan2( dy, dx );
    
    % zero out the borders
    pm(1,:,tt) = zeros(1,size(xph,2));pm(:,1,tt) = zeros(size(xph,1),1);
    pm(end,:,tt) = zeros(1,size(xph,2));pm(:,end,tt) = zeros(size(xph,1),1);
end


