function [epsilon_avg,epsilon_std] = vector_reconstruction_error( xo, xn )
% *WAVE*
%
% VECTOR RECONSTRUCTION ERROR    returns an estimate of the signal
%                                reconstruction error, based on the 
%                                formula:
%
%                                           sum_i ( X_{i,n} - X_{i,o} )^2 
%                                epsilon =  -----------------------------
%                                                sum_i ( X_{i,o} )^2
%
%                                given in:
%
%                                Goswami JC and Hoefel AE (2004) Algorithms
%                                for estimating instantaneous frequency.
%                                Signal Processing 84: 1423 - 1427.
%
% INPUT
% xo - original signal datacube (r,c,t)
% xn - new signal datacube (r,c,t)
%
% OUTPUT
% epsilon_avg - reconstruction error (average) 
% epsilon_std - reconstruction error (standard deviation)
%

assert( isvector(xo) == 1, 'vector input required, original signal' );
assert( isvector(xn) == 1, 'vector input required, new signal' );
assert( isequal( size(xo), size(xn) ), 'vectors must be the same size' );

squared_difference_matrix = ( xn - xo ).^2;
squared_matrix = xo.^2;

squared_difference_matrix = sum( squared_difference_matrix, 3 );
squared_matrix = sum( squared_matrix, 3 );

epsilon = squared_difference_matrix ./ squared_matrix;
epsilon_avg = nanmean( epsilon(:) );
epsilon_std = nanstd( epsilon(:) );