function [hh,hl,hv,fg] = plot_vector_field_distribution( ph )
% *WAVE*
%
% PLOT VECTOR FIELD DISTRIBUTION
%
% INPUT
% ph - complex scalar field representing vector directions
%
% OUTPUT
% vector field plot
%

% checks
assert( ndims(ph)>1, 'ndims ph must be greater than 1' )
assert( ~isreal(ph), 'complex-valued input required, ph' )

% init
ph = angle( ph );
xi = linspace( -pi, pi, 100 );

% plotting
fg = figure; hold on;
hh = zeros( size(ph,1), size(ph,2) ); hl = zeros( size(ph,1), size(ph,2) );
hv = zeros( size(ph,1), size(ph,2) );
for rr = 1:size( ph, 1 )
    for cc = 1:size( ph, 2 )
        
        yi = hist( reshape(ph(rr,cc,:),1,[]), xi ); yi = ( yi ./ max(yi) ) * 0.4;
        hh(rr,cc) = ...
            plot( (yi.*exp(1i.*xi)) + (cc+(1i*rr)), 'color', [.7 .7 .7], 'linewidth', 2 );
        hl(rr,cc) = ...
            plot( (cc+(1i*rr)), 'k.', 'markersize', 20 ); 
        
        % vector field plot
        tmp_mean = reshape(ph(rr,cc,:),[],1) ;
        tmp_mean = tmp_mean( ~isnan(tmp_mean) );
        vec_mean = circ_mean( tmp_mean );
        hv(rr,cc) = ...
            plot( [ (cc+(1i*rr))  (cc+(1i*rr))+.35*(exp(1i.*vec_mean)) ], ...
            'k', 'linewidth', 2 );
        
    end
end
set( gca, 'ydir', 'reverse', 'linewidth', 2, 'xticklabel', {}, 'yticklabel', {} )
box on; grid on
