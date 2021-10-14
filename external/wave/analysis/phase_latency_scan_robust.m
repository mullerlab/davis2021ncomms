function [pl,modulus,cc,pv,slope,xx,yy] = ...
                    phase_latency_scan_robust( xph, wt, Fs, pixel_spacing )
% *WAVE*
%
% PHASE LATENCY SCAN ROBUST    an efficient implementation of the PLCD
%                               calculation, for all points along the time 
%                               axis in the input datacube
%
%                               (robust version, spearman + robustfit)
%
% INPUT
% xph - analytic signal representation of the datacube (r,c,t)
% wt - instantaneous frequency datacube (r,c,t)
% Fs - sampling frequency
% pixel_spacing - distance between pixels
%
% OUTPUT
% pl - phase latency datacube (r,c,t)
% modulus - complex modulus at the 0/2pi crossing (r,c,t)
% cc - spearman correlation coefficient, phase latency with distance (1,t)
% pv - p-value, phase latency correlation with distance (1,t)
% slope - phase speed estimate (1,t)
% xx - x-position of wave source (1,t)
% yy - y-position of wave source (1,t)
%

assert( ndims(xph) == 3, 'datacube input required' )
assert( ~isreal(xph) == 1, 'analytic signal form for input required, xph' );
assert( ndims(wt) == 3, 'IF datacube input required' )
assert( isequal( size(xph), size(wt) ), 'datacube sizes must be equal' )

% save size for final reshape
dim = size(xph);

% reshape
xph = reshape( xph, size(xph,1)*size(xph,2), size(xph,3) );
wt = reshape( wt, size(wt,1)*size(wt,2), size(wt,3) );

% init
pl = zeros( size(xph) );
modulus = zeros( size(xph) );
tmp_pl = cell( 1, size(xph,1) );
tmp_mod = cell( 1, size(xph,1) );
xx = zeros( 1, size(xph,3) );yy = zeros( 1, size(xph,3) );
cc = zeros( 1, size(xph,3) );pv = zeros( 1, size(xph,3) );
slope = zeros( 1, size(xph,3) );

% calculate vector phase latency
for ii = 1:size(xph,1)
    [tmp_pl{ii},tmp_mod{ii}] = ...
        vector_phase_latency_npoint( xph(ii,:), wt(ii,:), Fs, 1 );
end

% transfer to phase latency maps
for ii = 1:size(xph,2)
    
    for jj = 1:size(xph,1)
        
        % pop the first PL (if there are any left)
        if ( numel(tmp_pl{jj}) > 0 )
            
            if ( tmp_pl{jj}(1) < (ii/Fs) )
                tmp_pl{jj}(1) = [];
                tmp_mod{jj}(1) = [];
            end
            
            if ( numel(tmp_pl{jj}) > 0 )
                pl(jj,ii) = tmp_pl{jj}(1);
                modulus(jj,ii) = tmp_mod{jj}(1);
            end
            
        end
        
    end
    
end

% clean up
pl = reshape( pl, dim(1), dim(2), dim(3) );
modulus = reshape( modulus, dim(1), dim(2), dim(3) );
clear tmp_pl
clear tmp_mod

% latency correlation with distance calculation
parfor ii = 1:size(pl,3)
    
    % wave source estimate
    tmp_pl = pl(:,:,ii);
    nanfield = (tmp_pl == 0);
    tmp_pl( nanfield ) = NaN;
    smooth_pl = smoothn( tmp_pl, 'robust' );
    smooth_pl( nanfield ) = NaN;
    
    % if unique minimum exists
    if numel( find( smooth_pl == min(smooth_pl(:)) ) ) == 1 
        
        [yy(ii),xx(ii)] = find( smooth_pl == min(smooth_pl(:)) );
        
        % make distance matrix
        [X,Y] = meshgrid( (1:dim(2))-xx(ii), (1:dim(1))-yy(ii) );  %#ok<PFBNS>
        D = sqrt( X.^2 + Y.^2 );
        D = D.*pixel_spacing;
        
        % add in NaNs, flatten, and remove NaNs
        tmp_pl( nanfield ) = NaN;tmp_pl = tmp_pl(:);tmp_pl( isnan(tmp_pl) ) = [];
        D( nanfield ) = NaN;D = D(:);D( isnan(D) ) = [];
        
        % correlation and regression
        [cc(ii),pv(ii)] = ...
                     corr( D, tmp_pl, 'tail', 'right', 'type', 'spearman' ); 
                                                % h0: rho == 0, h1: rho > 0
        
        if ( ( isnan(cc(ii)) ~= 1 ) && ( pv(ii) <= 0.05 ) )
            s = robustfit( D, tmp_pl );slope(ii) = 1./s(2);
        else
            slope(ii) = NaN;
        end        
        
    else
        
        yy(ii) = NaN;xx(ii) = NaN;cc(ii) = NaN;pv(ii) = NaN;slope(ii) = NaN;
        
    end
    
end

