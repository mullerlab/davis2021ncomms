function runNetsim(wd,param_pathfile,outputdir)

param_pathfile = GetFullPath(param_pathfile);
outputdir = GetFullPath(outputdir);

if ~exist(outputdir,'dir'), mkdir(outputdir); end

param_pathfile = strrep(param_pathfile,' ','\ ');
outputdir = strrep(outputdir,' ','\ ');

cd('./NETSIM')
system('make clean');
system('make COMPILE_TYPE=performance');
system( sprintf( './netsim -f %s -o %s' , param_pathfile , outputdir ) );
cd(wd)

end