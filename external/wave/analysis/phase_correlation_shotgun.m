function [cc,pv,curl_point,tmp_cc,tmp_pv] = phase_correlation_shotgun( pl )
% *WAVE*
%
% PHASE CORRELATION SHOTGUN    
%
%
% INPUT
% pl - phase field (r,c)
%
% OUTPUT
% cc - circular correlation coefficient, rotation angle about curl point
% pv - p-value of the correlation
% curl_point - center of rotation field
%

assert( ismatrix(pl), 'data matrix input required, pl' )

% circular correlation over all points (x,y)
tmp_cc = zeros( size(pl,1), size(pl,2) ); tmp_pv = zeros( size(pl,1), size(pl,2) );
for ii = 1:size( pl, 1 )
	for jj = 1:size( pl, 2 )

		[X,Y] = meshgrid( (1:size(pl,2))-jj, (1:size(pl,1))-ii );
		[T,~] = cart2pol( X, Y );
		T = T(:); tmp_pl = pl(:); T( isnan(tmp_pl) ) = []; tmp_pl( isnan(tmp_pl) ) = [];
		[ tmp_cc(ii,jj), tmp_pv(ii,jj) ] = circ_corrcc( tmp_pl, T );

	end
end

% assign curl point as maximum absolute correlation coefficient
curl_point = zeros( 1, 2 );
[curl_point(2),curl_point(1)] = find( abs(tmp_cc) == max(abs(tmp_cc(:))) );

% assign maximum to cc and pv
cc = tmp_cc( curl_point(2), curl_point(1) );
pv = tmp_pv( curl_point(2), curl_point(1) );
