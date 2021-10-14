%%%%%
%
%  WAVE TEST SCRIPT
%  Correlated Gaussian Noise Test
%  Lyle Muller
%  6 March 2013
%
%%%%%

clear all
clc

% parameters
N = 900;
T = 66;
var_covariance = .025;
lowpass_cutoff = 5;
hipass_cutoff = 20;
Fs = 110;
filter_order = 4;
pixel_spacing = 1;
alpha = 0.01;
trials = 42;

n_points = 20;
cc = 1;sum_sig = zeros( 1, n_points );
mean_covariances = linspace( 0, .4, n_points );
for mean_covariance = mean_covariances
    
    % construct correlation matrix
    C = (randn(N)+mean_covariance).*var_covariance;
    C = C - tril(C);
    C = C + triu(C)';
    C( logical( eye(size(C)) ) ) = 1; % autocorrelation 1
    C = sqrt( C.^2 );
    
    % sample the correlated Gaussian noise
    [x, sampR] = correlatedGaussianNoise( C, T );
    x = reshape( x, [sqrt(N) sqrt(N) T] );
    
    % process the produced matrix
    x = bandpass_filter( x, lowpass_cutoff, hipass_cutoff, filter_order, Fs );
    x = zscore_independent( x );
    xph = hilbert_transform( x );
    wt = instantaneous_frequency( xph, Fs );
    
    % calculate the phase latency basin for each point in time (-6 for edge
    % effects)
    pld = zeros(1,T-6);
    pv = zeros(1,T-6);
    xx = zeros(1,T-6);
    yy = zeros(1,T-6);
    modulation = zeros(1,T-6);
    speed = zeros(1,T-6);
    minimum_latency = zeros(1,T-6);
    
    for ii = 1:(T-6)
                
        [pl,~] = phase_latency( xph, wt, Fs, ii );
        
        [pld(ii),pv(ii),xx(ii),yy(ii),modulation(ii),speed(ii),minimum_latency(ii)] = ...
            phase_latency_correlation_distance( ...
            pl, pixel_spacing );
        
    end
    
    sum_sig(cc) = sum( pv < (alpha/trials) );
    cc = cc+1;
    
end

% plotting
figure;
plot( mean_covariances, sum_sig )
xlabel( 'Mean Covariance' )
ylabel( '# Significant Points' )

