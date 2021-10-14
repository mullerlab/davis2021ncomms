function [spikePhase, randPhase, SPI, prefPhase] = NetsimSpikePhase(lz,ids,times,vars,filtBand)
% Calculate the spike-phase index for NETSIM data. ZD 10/06/2021
% The calculation is performed for the excitatory neurons in each LFP pool
% Inputs: 
% LFP - 2D LFP Data (LFP Index x Time)
% ids - Spike unit IDs
% times - Spike times
% vars - Simulation parameter structure 
% 
% Outputs:
% spikePhase - LFP phase at every spike time 
% randPhase - Matched random LFP phases
% SPI - The spike-phase index for each LFP bin
% prefPhase - The mean phase angle of each LFP bin's spikephase
% distribution

% Initalize Variables
Ne = floor( 0.8 * vars.N ); NrowE = floor(sqrt(Ne));
number_bins = floor( 0.8*vars.N / (vars.bin_size.^2) );
NrowLFP = floor(sqrt(number_bins));
[b, a] = butter(4,[filtBand(1) filtBand(2)]/500);
bins = .2:.001:vars.stop_record_time; % Do not include first 200 ms
spikePhase = [];
randPhase = [];

% Define LFP indices of each excitatory neuron
lfpIdx = 1;
for i = 1:Ne-1
    lfpR = ceil(ceil(((i))/NrowE)/vars.bin_size);
    lfpC = floor(mod(((i)),NrowE)/vars.bin_size)+1;
    lfpIdx(i+1) = (lfpR-1)*NrowLFP+lfpC;
end

% Calculate spike phases from each LFP bin
SPI = [];
for i = 1:size(lz,1)
    thisLFP = lz(i,200:end); % Eliminate first 200 ms
    spkIdx = find(lfpIdx == i); % Take the units in this LFP bin
    theseSpikes = histc(times(ismember(ids,spkIdx)),bins); % Get the spikes from those units
    randSpikes = theseSpikes(randperm(length(theseSpikes))); % Randomize spike times
    if sum(theseSpikes) > 0
        filtLFP = filtfilt(b,a,thisLFP);
        angLFP = generalized_phase(reshape(filtLFP,1,1,size(filtLFP,2)),1000,5); phaseLFP = angle(reshape(angLFP,1,size(filtLFP,2)));
        thisBinPhase = [];
        for j = 1:max(theseSpikes) % In case more than one spike in each time bin
            spikePhase = [spikePhase phaseLFP(theseSpikes >= j)];
            randPhase = [randPhase phaseLFP(randSpikes >= j)];
            thisBinPhase = [thisBinPhase phaseLFP(theseSpikes >= j)];
        end
        SPI(i) = circ_r(thisBinPhase');
        prefPhase(i) = circ_mean(thisBinPhase');
    end
end