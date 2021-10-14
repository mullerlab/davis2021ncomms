function plot_phase_latency( pl, mask_r, mask_c )
% *WAVE*
%
% PLOT PHASE LATENCY     plots the smoothed phase latency, excluding
%                           0's and NaN's
%
% INPUT
% pl - phase latency matrix (r,c)
%
% OUTPUT
% smoothed phase latency plot
%

assert( ndims(pl) == 2, 'data matrix input required' );
if nargin > 1
   pl = pl(mask_r, mask_c);
end

out = (pl == 0);
pl(out) = NaN;
pls = smoothn(pl);
pls(out) = NaN;
h = imagesc(pls);colorbar();axis image
set( h, 'alphadata', ~isnan( pls ) );