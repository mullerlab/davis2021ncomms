function [pm,pd,save_dx,save_dy] = ...
    phase_gradient_complex_multiplication( xph, pixel_spacing, varargin )
% *WAVE*
%
% PHASE GRADIENT COMPLEX MULTIPLICATION     take the gradient of the phase maps,
%                                             returning datacubes of direction
%                                             and magnitude
%
%                   For a 2D analytic signal V_{x,y} = v_{x,y} + iHb[v_{x,y}],
%
%                   and V_{x,y} = A_{x,y} exp( i \Phi{x,y} )
%
%                   \nabla{Phi} = dPhi/dx + dPhi/dy
%
%                   dPhi/dx = \delta Phi_x = angle( V_{x,y} V*_{x+1,y} )
%
%                       and
%
%                   dPhi/dy = \delta Phi_y = angle( V_{x,y} V*_{x,y+1} )
%
%                   where * indicates complex conjugate.
%
%                   Reference: Feldman (2011) Hilbert Transform
%                       Applications in Mechanical Vibration.
%                       Algorithm 3, p. 18.
%
% INPUT
% xph - analytic signal representation of the datacube (r,c,t)
% pixel_spacing - pixel spacing
%
% OUTPUT
% pm - phase gradient magnitude
%
% pd - phase gradient direction
%

assert( ndims(xph) >= 2, 'matrix/datacube input required' );
pm = zeros( size(xph) ); pd = zeros( size(xph) );
save_dx = zeros( size(xph) ); save_dy = zeros( size(xph) );
dim = size(xph);

for tt = 1:size(xph,3)
    
    %%% dx
    dx = zeros( size(xph(:,:,1)) );
    
    % forward differences on left and right edges
    dx(:,1) = angle( xph(:,1,tt) .* conj( xph(:,2,tt) ) ) ./ pixel_spacing; 
    dx(:,dim(2)) = angle( xph(:,dim(2)-1,tt) .* conj( xph(:,dim(2),tt) ) ) ./ pixel_spacing; 
    
    % centered differences on interior points
    dx(:,2:dim(2)-1) = angle( xph(:,1:dim(2)-2,tt) .* conj( xph(:,3:dim(2),tt) ) ) ./ (2*pixel_spacing); 
    
    % save dx
    save_dx(:,:,tt) = dx;

    %%% dy
    dy = zeros( size(xph(:,:,1)) );
    
    % forward differences on top and bottom edges
    dy(1,:) = angle( xph(1,:,tt) .* conj( xph(2,:,tt) ) ) ./ pixel_spacing; 
    dy(dim(1),:) = angle( xph(dim(1)-1,:,tt) .* conj( xph(dim(1),:,tt) ) ) ./ pixel_spacing; 
    
    % centered differences on interior points
    dy(2:dim(1)-1,:) = angle( xph(1:dim(1)-2,:,tt) .* conj( xph(3:dim(1),:,tt) ) ) ./ (2*pixel_spacing); 

    % save dy
    save_dy(:,:,tt) = dy;

    % make magnitude and direction maps
    pm(:,:,tt) = sqrt( dx.^2 + dy.^2 ) ./ (2*pi);
    pd(:,:,tt) = atan2( dy, dx ); 
    
end
