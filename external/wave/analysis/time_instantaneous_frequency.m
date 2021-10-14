function [time_freq] = time_instantaneous_frequency( wt, Fs, frequency_step, timvec )
% *WAVE*
%
% TIME-INSTANTANEOUS FREQUENCY PLOT      makes the time-frequency plot
%                                           associated with the
%                                           instantaneous frequencies from
%                                           a phase derivative
%
% INPUT
% wt - instantaneous frequency datacube (r,c,t)
% Fs - sampling frequency (sc)
% timvec - vector of time stamps
%
% OUTPUT
% time_freq - time-frequency representation
%

assert( ndims(wt) == 3, 'datacube input required (wt)' )
assert( isvector(timvec) == 1, 'vector input required (timvec)' )

frequency_vector = 0:frequency_step:(Fs/2);
time_freq = zeros(length(frequency_vector),length(timvec));

for ii = 1:length(timvec)
   
    time_freq(:,ii) = histc( reshape(wt(:,:,ii),[],1), frequency_vector );
    
end
