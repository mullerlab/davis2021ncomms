function plot_instantaneous_frequency( wt, nbins, Fs )
% *WAVE*
%
% PLOT INSTANTANEOUS FREQUENCY  plot IF distribution, given an IF estimate
%                               wt.
%
% INPUT:
% wt - instantaneous frequency datacube (r,c,t)
% nbins - number of bins to histogram
%
% OUTPUT:
% two-dimensional instantaneous frequency plot
%

assert(ndims(wt) == 3,'datacube input required');
hist_wt = zeros(nbins,size(wt,3));
bins = linspace(0, Fs/2, nbins);

for tt = 1:size(wt,3)
    tmp_wt = wt(:,:,tt);
    hist_wt(:,tt) = histc(tmp_wt(:),bins);
end

pcolor(hist_wt);shading flat