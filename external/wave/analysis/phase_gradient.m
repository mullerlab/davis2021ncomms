function [pm,pd] = phase_gradient( xph )
% *WAVE*
%
% PHASE GRADIENT     take the gradient of the phase maps,
%                       returning datacubes of direction
%                       and magnitude
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
xph = angle( xph );

for ii = 1:size(xph,3)
    phase_map_x = xph(:,:,ii);%unwrap(xph(:,:,ii),[],1);
    phase_map_y = xph(:,:,ii);%unwrap(xph(:,:,ii),[],2);
    [dx,~] = gradient( phase_map_x );
    [~,dy] = gradient( phase_map_y );
    pm(:,:,ii) = sqrt( dx.^2 + dy.^2 );
    pd(:,:,ii) = atan2( dy, dx );
end
