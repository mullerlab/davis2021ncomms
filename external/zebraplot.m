function wl_slice = zebraplot( pm , pm_sh )

wl_slice = pm;
wl_slice(1./pm(:) < prctile(1./pm_sh(:),99)) = 0;
wl_slice(1./pm(:) > prctile(1./pm_sh(:),99)) = 1;
wl_slice = squeeze(wl_slice(:,30,:));

end