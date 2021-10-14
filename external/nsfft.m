function A = nsfft(lz)

rng(0)
A = nan(size(lz));
for idx = 1 : size(lz,2)
    lz2  = squeeze(  lz( : , idx , : )  );
    F = fftshift(  abs( fft2(lz2) )  );
    S = fftshift(  abs(fft2( lz2(  randperm( size(lz2,1) ) , : )  ) )  );
    T = fftshift( abs(  fft2( lz2( : , randperm( size(lz2,2) ) ) )  ) );
    A(idx,:,:) = 10*log10( (2*F) ./ (S+T) );
end
A = squeeze(nanmean(A,1));

end