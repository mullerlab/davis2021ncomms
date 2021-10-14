function [lz,lz2,lz3] = nssimlfp(vars,vms,ges,gis)
% Estimation of LFP from LIF outputs
% Note: we z-score the LFP across time.
% 
% Based on Mazzoni et al., 2015
% (https://doi.org/10.1371/journal.pcbi.1004584)

time_shift_lfp = 0.006 ./ ( vars.dt * vars.record_downsample_factor );
lfp = abs( circshift( ges.*(vars.Ee-vms), [0 time_shift_lfp] ) - 1.65*gis.*(vars.Ei-vms) );
lz = ( lfp - repmat(nanmean(lfp,2),[1 size(lfp,2)]) ) ./ ...
    repmat(nanstd(lfp,[],2),[1 size(lfp,2)]);
number_bins = floor( 0.8*vars.N / (vars.bin_size.^2) );
NrowLFP = floor(sqrt(number_bins));

lz2 = lz(:,1001:end); % exclude initial transient
lz = lz( : , 1 : (.001/vars.dt)/vars.record_downsample_factor : size(lz,2) ); % downsample further in time
lz3 = lz;
lz(:,1:200) = []; % exclude initial transient
lz = reshape(lz,NrowLFP,NrowLFP,[]);
lz2 = reshape(lz2,NrowLFP,NrowLFP,[]);

end