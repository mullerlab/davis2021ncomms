function vars = LoadParameterFile( filepath, myfile )
thisDir = pwd;
cd(filepath)
% init
vars.init = 0;

% open and read file
fid = fopen( myfile, 'r' );
if fid == -1, error( 'Bad filepath.' ); end

% parse and save each line of parameter file
line = fgets( fid );
while line ~= -1
    
    if ( line(1) ~= '#' ) && ~( any( (line == '(') | (line == '[') | (line == '{') ) )
        if line(1) == '$'
            
            s = textscan( line, '$%s = %s' );
            if ~isempty( s ) && ( ~isempty(s{1}) ) %#ok<ALIGN>
                eval( strcat( 'vars.', s{1}{1}, ' = ''', char(s{2}), ''';') );
            end
            
        elseif line(1) == '@'
            s = textscan( line, '%s = %f : %f : %f' );
            if ~isempty( s ) && ( ~isempty(s{1}) ) %#ok<ALIGN>
                eval( strcat( 'vars.', s{1}{1}(2:end), ' = ','[',num2str( linspace(s{2},s{3},s{4})),']',';') );
            end
            
        else
            
            s = textscan( line, '%s = %f' );
            if ~isempty( s ) && ( ~isempty(s{1}) ) %#ok<ALIGN>
                eval( strcat( 'vars.', s{1}{1}, ' = ', num2str(s{2}), ';') );
            end
            
            
            
        end
        
    end
    
    line = fgets( fid );
    
end

% clean up
vars = rmfield( vars, 'init' );

% close file
fclose( fid );

cd(thisDir);