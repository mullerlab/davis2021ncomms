function [psi] = phase_similarity_index( p1, p2 )
% *WAVE*
%
% PHASE SIMILARITY INDEX     take the phase similarity index (PSI) between
%                               two input phase maps
%
% INPUT
% p1, p2 - phase maps (r,c)
%
% OUTPUT
% psi - phase similarity index, defined as 
%
%       \psi = ( 1 / (N-N1) ) \sum_{i,j} sin( \phi^{1}_{ij} * \phi^{1}_{ij} )
%

assert( ismatrix(p1) & ismatrix(p2), 'matrix required, p1 & p2' )
assert( ( isreal(p1) == 1 ) & ( isreal(p2) ==1 ), 'angular (real-valued) input required' )
assert( isequal( size(p1), size(p2) ), 'p1 and p2 must be the same size' )

N = numel( p1 );

psi = ( 1 ./ N ) * sum( 1 - abs( sin( ( p1(:) - p2(:) ) ./ 2 ) ) );
% psi = ( 1 ./ N ) * sum( 0.5 * ( cos( ( p1(:) - p2(:) ) ) + 1 ) );
