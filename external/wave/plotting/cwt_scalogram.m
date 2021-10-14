function cwt_scalogram( x, scales, Fs, wtype, plot_type, log_scale )
% *WAVE*
%
% CWT SCALOGRAM     makes the time-(pseudo)frequency plot from the
%                       continuous-wavelet transform (CWT), scaling
%                       everything to the correct frequency axis
%
% INPUT
% x - timeseries (1,t)
% Fs - sampling frequency
%
% OUTPUT
% image/contour plot
%

assert( isvector(x) == 1, 'timeseries input required' )
assert( ischar(plot_type) == 1, 'string input required for plot type' )
assert( ischar(wtype) == 1, 'string input required for wtype' )
assert( ( strcmp(plot_type,'imagesc') || strcmp(plot_type,'contour') ), 'bad plot specification' )
assert( (log_scale == 1) || (log_scale == 0), 'bad scale specification' )

C = cwt( x, 1:scales, wtype );
SC = wscalogram( '', C, 'scales', 1:scales );

% plotting
figure
if strcmp( plot_type, 'imagesc' )
    imagesc(SC)
elseif strcmp( plot_type, 'contour' )
    contour(SC)
end

if log_scale == 1; set( gca, 'yscale', 'log' ); end

ytick = get( gca, 'ytick' );
ytick_label = scal2frq( ytick, wtype, 1/Fs );
ytick_label_str = cell(1,length(ytick_label));
for ii = 1:length(ytick_label)
    ytick_label_str{ii} = sprintf('%2.1f',ytick_label(ii));
end
set( gca, 'yticklabel', ytick_label_str );
set( gca, 'ydir', 'reverse' )
ylabel('Frequency (Hz)')

xtick = get( gca, 'xtick' );
time = (1/Fs):(1/Fs):length(x)/Fs;
xtick_label = time( xtick );
set( gca, 'xticklabel', xtick_label );
xlabel('Time (s)')

cb = colorbar;
set( get(cb,'ylabel'), 'string', '% Energy Per Coefficient' )
