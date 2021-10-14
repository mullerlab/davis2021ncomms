%%%%
%
% Traveling Gaussian Pulse 
% Test Script
% Lyle Muller
% 28 September 2012
%
%%%%%

xf = generate_traveling_gaussian_pulse( 1000, 1000, 500, 1 );
xb = hilbert( xf' - .5 );xb = xb';

figure
set(gcf,'position',[1322 110 535 826])
subplot(211)
imagesc(xf)
subplot(212)
plotyy(1:1000,angle(xb(500,:)),1:1000,xf(500,:))
set(gca,'ytick',[-pi 0 pi])
ylabel('Phase Angle (rad)')
xlabel('Time (samp)')
legend({'Phase Angle','Signal'})