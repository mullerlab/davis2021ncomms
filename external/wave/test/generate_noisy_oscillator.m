function [rho,theta] = generate_noisy_oscillator( dt, T, base_amplitude, base_frequency, ...
                                                    amplitude_noise_level, ...
                                                    frequency_noise_level )
% *WAVE*
%
% GENERATE NOISY OSCILLATOR     generates an oscillation with defined
%                                   amplitude and frequency noise
%
% INPUT
% dt - time step
% T - epoch length
% base_amplitude - A_0
% base_frequency - omega_0
% amplitude_noise_level - scaling of the amplitude noise
% frequency_noise_level - scaling of the frequency nosie
%
% OUTPUT
% rho - amplitude output
% theta - phase output
%                                           
                                            
time_axis = dt:dt:T;

frequency_vector = base_frequency + randn(1,length(time_axis))*frequency_noise_level;

rho = base_amplitude + randn(1,length(time_axis))*amplitude_noise_level;
theta = cumtrapz( 2 * pi * frequency_vector * dt );
