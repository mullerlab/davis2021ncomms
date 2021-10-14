%
% fisher z-transform test, summary statistics
% lyle muller
% 16 december 2014
%

clear all; clc %#ok<CLSCR>

% CC values from a concocted sample

N = 1e4;
mean_r = 0.5; std_r = 0.1;
iterations = 100;
cc = zeros( 1, iterations );

for ii = 1:iterations

    r = ( randn(1) * std_r ) + mean_r;
    x = randn( 1, N );
    SD = sqrt( 1 - r^2 );
    e = randn( 1, N ) * SD;
    y = r*x + e;
    cc(ii) = corr( x', y' );

end

z = .5 * log( (1+cc) ./ (1-cc) );
mean_obs = ( exp(2*mean(z)) - 1 ) ./ ( exp(2*mean(z)) + 1 );
std_obs = ( exp(2*std(z)) - 1 ) ./ ( exp(2*std(z)) + 1 );

sprintf( 'mean r measured: %1.2f, std r measured: %1.4f', ...
    mean_obs, std_obs ./ sqrt(100) )
sprintf( 'standard error of z: %1.4f', 1 ./ sqrt( N - 3 ) )











