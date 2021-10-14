function [d, m] = phase_gradient_calculation( xph )
% *WAVE*
%
% PHASE GRADIENT CALCULATION    calculation of the phase gradient given
%                                   complex phase maps of the system
%
%                               (this version is distinct from the 
%                                   phase_gradient.m in that it projects
%                                   the gradient back onto the phase map)
% INPUT:
% xph - analytic representation of the datacube (r,c,t)
%
% OUTPUT:
% d - direction vector datacube (r,c,t)
% m - phase gradient magnitude datacube (r,c,t)
% dx - propagation vector component along the columns (x-direction)
% dy - propagation vector component along the rows (y-direction)
%

assert( ndims(xph) == 3, 'datacube input required' );
m = zeros(size(xph));
d = zeros(size(xph));

for ii = 1:size(xph,3)
    phase_map_x = unwrap(angle(xph(:,:,ii)),[],1);
    phase_map_y = unwrap(angle(xph(:,:,ii)),[],2);
    [dx,~] = gradient(exp(1i*phase_map_x));
    [~,dy] = gradient(exp(1i*phase_map_y));
    dx = real(dx.*exp(-1i*(phase_map_x+pi/2)));
    dy = real(dy.*exp(-1i*(phase_map_y+pi/2)));
    m(:,:,ii) = sqrt( real( gradient(exp(1i*phase_map_x)) ).^2+...
                      real( gradient(exp(1i*phase_map_y)) ).^2);
    d(:,:,ii) = atan2(dy,dx);
end