% *WAVE*
%
% PHASE CORRELATION TEST SCRIPT     what is the meaning of phase
%                                       correlation, the in the context of
%                                       two noisy oscillators?
%

clear all
clc

dt = .001;
T = 1;

% fixed parameters
base_amplitude = 1;
base_frequency = 10;

% variables
amplitude_noise_level = linspace(0,base_amplitude,100);
IF_noise_level = linspace(0,base_frequency,100);

% initialization
cc = zeros(length(amplitude_noise_level),length(IF_noise_level));
pval = zeros(length(amplitude_noise_level),length(IF_noise_level));

for ii = 1:length(amplitude_noise_level)
    
    for jj = 1:length(IF_noise_level)
    
    [a1,ph1] = generate_noisy_oscillator( dt, T, base_amplitude, base_frequency, ...
                                        amplitude_noise_level(ii), IF_noise_level(jj) );
    
    [a2,ph2] = generate_noisy_oscillator( dt, T, base_amplitude, base_frequency, ...
                                        amplitude_noise_level(ii), IF_noise_level(jj) );  
                                    
    exp1 = a1 .* exp(1i*ph1);
    exp2 = a2 .* exp(1i*ph2);
    
    phase_1 = angle(exp1);
    phase_2 = angle(exp2);
    
    [cc(ii,jj),pval(ii,jj)] = circ_corrcc( phase_1, phase_2 );
    
    end
    
end

cc = abs(cc);

% plotting
imagesc(smoothn(cc))
ytick = get(gca,'ytick');
set(gca,'yticklabel', double(int8(amplitude_noise_level(ytick)*100))/100);
xtick = get(gca,'xtick');
set(gca,'xticklabel', double(int16(IF_noise_level(xtick)*100))/100);
ylabel('Amplitude Noise Level')
xlabel('IF Noise Level')
cb = colorbar();
set(get(cb,'ylabel'),'string','Phase Correlation')

