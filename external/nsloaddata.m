function [vars, ids, times, vms, gis, ges] = nsloaddata(paramfile,outputdir)

[filepath,name,ext] = fileparts(paramfile);

vars = LoadParameterFile( filepath , [name ext] );

if isfield(vars,'output_file_code')
    code = vars.output_file_code;
else
    code = 0;
end

[ ids, times ] = load_netsim_spikes( fullfile(outputdir, sprintf( '%08uspk.bin' , code ) ) );
vms = load_netsim_data( fullfile(outputdir, sprintf( '%08uvms.bin' , code ) ) );
gis = load_netsim_data( fullfile(outputdir, sprintf( '%08ugi.bin' , code ) ) );
ges = load_netsim_data( fullfile(outputdir, sprintf( '%08uge.bin' , code ) ) );
number_bins = floor( 0.8*vars.N / (vars.bin_size.^2) );
vms = reshape( vms, number_bins, [] );
ges = reshape( ges, number_bins, [] );
gis = reshape( gis, number_bins, [] );

end