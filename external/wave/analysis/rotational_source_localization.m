function source = rotational_source_localization( ph )
% *WAVE*
%
% ROTATIONAL SOURCE LOCALIZATION    localize rotational source in a
%                                       direction field, using a coordinate 
%                                       transform and iterative solution
%
%
% INPUT
% ph - direction (i.e. unit vector) field (r,c)
%
% OUTPUT
% source - source point (x,y)
%

% init
assert( ismatrix(ph), 'matrix input required, ph' )
assert( ~isreal(ph), 'complex-valued input required, ph' )
number_steps = 100; source_iterations = 25;

%ph = -ph;   % ** invert sign of phase field **, for phase gradient
%ph = ph + pi;

rot = exp(-1i*pi/2); ph_rot = ph * rot;

% get transformed vector fields
U = real( exp( 1i * angle(ph_rot) ) ); V = imag( exp( 1i * angle(ph_rot) ) );

% divergence calculation
d = divergence( U, V ); %d = smoothn( d, 1 ); % n.b. the smoothing here can cause boundary effects

% % find center by divergence
% source = [0 0]; [ source(2), source(1) ] = find( abs(d) == max(abs(d(:))) );

% use sign of divergence field
ind = find( abs(d) == max(abs(d(:))) ); 
sgn = -sign( d(ind(1)) ); %Explanation: flip if source field, don't flip if sink

% find center by iteration
source = zeros( 2, source_iterations );
for ii = 1:source_iterations
    source(:,ii) = iterative_solution( U*sgn, V*sgn, number_steps );
end
source = round( mean( source, 2 ) ); 

% % find center by curl
% %ph = smoothn( ph, 1, 'robust' );
% cl = curl( real(ph), imag(ph) );
% source = [0 0]; [source(2),source(1)] = find( abs(cl) == max(abs(cl(:))), 1, 'first' );

end


%%% iterative solution to find vector field center
function source = iterative_solution( U, V, steps )

d1 = size(U,1); d2 = size(V,2);

% prepare padded vector fields
UU = zeros( size(U)+2 ); VV = zeros( size(V)+2 );
UU(2:end-1,2:end-1) = U; VV(2:end-1,2:end-1) = V;
UU( :, 1 ) = ones(size(UU,1),1) * real(exp( 1i * 0 ));
UU( :, end ) = ones(size(UU,1),1) * real(exp( 1i * pi ));
VV( 1, : ) = ones(1,size(VV,2)) * imag(exp( 1i * (pi/2) ));
VV( end, : ) = ones(1,size(VV,2)) * imag(exp( 1i * (-pi/2) ));

% % extra padding conditions
% UU( 1, 2:end ) = ones(1,size(UU,2)-1) * .1*real(exp( 1i * pi ));
% UU( 1, 1 ) = UU( 1, 1 ) .* .1;

% initialize loop
s = zeros( 2, steps ); 
s(1,1) = randi( [3 d2-1], 1 ); s(2,1) = randi( [3 d1-1], 1 );
points_to_average = floor( steps./10 );

% loop
for ii = 2:steps
    point = round( s(:,ii-1) );
    s(:,ii) = s(:,ii-1) + [ UU(point(2),point(1)) VV(point(2),point(1)) ]'; 
end

source = ceil( mean( s(:,end-points_to_average:end), 2 ) ); % note ceil
source = source - 1; % 1 for the padding

end


%%% interpolated iterative solution to find vector field center
function source = iterative_solution_interp( U, V, steps )

d1 = size(U,1); d2 = size(V,2);

% interpolate U and V
[X,Y] = meshgrid( 1:size(U,2), 1:size(U,1) );
[Xq,Yq] = meshgrid( 1:.1:size(U,2), 1:.1:size(U,1) );
U = interp2( X, Y, U, Xq, Yq ); V = interp2( X, Y, V, Xq, Yq );

% prepare padded vector fields
UU = zeros( size(U)+2 ); VV = zeros( size(V)+2 );
UU(2:end-1,2:end-1) = U; VV(2:end-1,2:end-1) = V;
UU( :, 1 ) = ones(size(UU,1),1) * 2*real(exp( 1i * 0 ));
UU( :, end ) = ones(size(UU,1),1) * 2*real(exp( 1i * pi ));
VV( 1, : ) = ones(1,size(VV,2)) * 2*imag(exp( 1i * (pi/2) ));
VV( end, : ) = ones(1,size(VV,2)) * 2*imag(exp( 1i * (-pi/2) ));

% initialize loop
s = zeros( 2, steps ); 
s(1,1) = randi( [3 d2-1], 1 ); s(2,1) = randi( [3 d1-1], 1 );
points_to_average = floor( steps./20 );

% loop
for ii = 2:steps
    point = round( s(:,ii-1) );
    s(:,ii) = s(:,ii-1) + [ UU(point(2),point(1)) VV(point(2),point(1)) ]'; 
end

source = ceil( mean( s(:,end-points_to_average:end), 2 ) ); % note ceil
if source(1) > size(Xq,2), source(1) = size(Xq,2); end
if source(2) > size(Yq,1), source(2) = size(Yq,1); end
source_x = round( Xq( 1, source(1) ) ); source_y = round( Yq( source(2), 1 ) );
source = [ source_x source_y ];

end
