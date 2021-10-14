%%%%%
%
% Phase Similarity Index (PSI) Test
% Lyle Muller
% 8 June 2015
%
%%%%%

%% test with random phases

clear all; clc %#ok<CLSCR>

trials = 1000; N = 10;
psi = zeros( 1, trials );
for ii = 1:trials
    
    p1 = ( rand( N ) * 2*pi ) - pi; p2 = ( rand( N ) * 2*pi ) - pi;
    psi(ii) = phase_similarity_index( p1, p2 );
    
end

fg1 = figure; hist( psi(:), 25 ); 
set( gca, 'fontname', 'arial', 'fontsize', 14 )
xlabel( 'Phase Similarity Index (PSI)' ); ylabel( 'Count' )


%% test with increasing perturbation

clear all; clc %#ok<CLSCR>
distance = linspace( 0, 2*pi, 100 );

trials = 1000; N = 10;
psi = zeros( trials, length(distance) );

for ii = 1:length( distance )
    
    for jj = 1:trials
        
        p1 = ( rand( N ) * 2*pi ) - pi; p2 = p1 + distance(ii);
        psi(jj,ii) = phase_similarity_index( p1, p2 );
        
    end
    
end

fg2 = figure; set( gca, 'fontname', 'arial', 'fontsize', 14 )
errorbar( distance, mean(psi), std(psi), 'linewidth', 2 ); 
xlim( [distance(1) distance(end)] ); ylim( [0 1] )
xlabel( 'Angular Distance (rad)' ); ylabel( 'Phase Similarity Index (PSI)' )
set( gca, 'xtick', [0 pi 2*pi] ); set( gca, 'xticklabel', {'0','\pi','2\pi'} )
set( gca, 'ytick', 0:.2:1 )

fg3 = figure; set( gca, 'fontname', 'arial', 'fontsize', 14 )
h1 = polar( distance, mean(psi) ); 


