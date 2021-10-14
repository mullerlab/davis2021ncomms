function [xgp,wt] = generalized_phase( x, Fs, lp )
% *WAVE*
%
% GENERALIZED PHASE    calculate the generalized phase of a datacube
%
% INPUT:
% x - datacube (r,c,t)
% Fs - sampling rate (Hz)
% lp - low-frequency data cutoff (Hz)
%
% OUTPUT:
% xgp - output datacube
% wt - instantaneous frequency estimate
%

% parameters
nwin = 3;

% handle input
assert(ndims(x) == 3,'datacube input required');
[dim1,dim2,dim3] = size(x);

% anonymous functions
rewrap = @(xp) ( xp - 2*pi*floor( (xp-pi) / (2*pi) ) - 2*pi );
naninterp = @(xp) interp1( find(~isnan(xp)), xp(~isnan(xp)), find(isnan(xp)), 'pchip' );

% init
dt = 1 / Fs;

% apply analytic signal representation
x = reshape( x, [dim1*dim2, dim3] ); xo = hilbert( x' ); xo = xo';
xo = reshape( xo, [dim1,dim2,dim3] ); ph = angle( xo ); md = abs( xo );

% calculate IF
wt = zeros(size(xo));
wt(:,:,1:end-1) = angle( xo(:,:,2:end) .* conj( xo(:,:,1:end-1) ) ) ./ (2*pi*dt);

% rectify rotation
sign_if = sign( nanmean(wt(:)) );
if ( sign_if == -1 )
    modulus = abs(xo); ang = sign_if .* angle(xo); % rectify rotation
    xo = modulus .* exp( 1i .* ang ); ph = angle( xo ); md = abs( xo );
    wt(:,:,1:end-1) = ... % re-calculate IF
        angle( xo(:,:,2:end) .* conj( xo(:,:,1:end-1) ) ) ./ (2*pi*dt);
end

for ii = 1:dim1
	for jj = 1:dim2

		% check if nan channel
		if all( isnan(ph(ii,jj,:)) ), continue; end

		% find negative frequency epochs (i.e. less than LP cutoff)
		idx = ( squeeze(wt(ii,jj,:)) < lp ); idx(1) = 0; [L,G] = bwlabel( idx );
		for kk = 1:G
			idxs = find( L == kk ); 
			idx( idxs(1):( idxs(1) + ((idxs(end)-idxs(1))*nwin) ) ) = true;
		end

		% "stitch over" negative frequency epochs
		p = squeeze( ph(ii,jj,:) ); p(idx) = NaN; 
		if all( isnan(p) ), continue; end % check if all NaNs
		p = unwrap(p); p(isnan(p)) = naninterp( p ); p = rewrap( p );
		ph(ii,jj,:) = p(1:size(ph,3));

	end
end

% output
xgp = md .* exp( 1i .* ph );
