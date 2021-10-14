% function [varargout]=readfloat(filename,s)
% to read the list of variables in the file, do e.g
% list = readfloat('filename','anystring')
%
% Alexander Sterkin (c) 29 October 1998

% function [h1,h2,h3,h4,h5,h6,h7,h8,h9,h10, ...
% h11,h12,h13,h14,h15,h16,h17,h18,h19,h20] ...
% =readfloat(filename,s)

% remember that it's really important to z-score these data, because the
% default unit is like 1e-3

function [varargout]=readfloat(filename)

fid = fopen(filename,'r','ieee-be')

hlen=fread(fid,1,'int32');
h0=fread(fid,hlen,'uchar');
h0=char(h0)';

if(nargin == 2),
  h1=h0;
  varargout={h0};
  fclose(fid);
  return;
end;

k=1;
while( 1 ),
  m=fread(fid,1,'int32');
  n=fread(fid,1,'int32');
  if(feof(fid) == 1), break;end;
% eval(['h' num2str(k) '=fread(fid,[m n],''float32'');']);
% fprintf('k=%d m=%d n=%d\n',k,m,n);
  eval('varargout(k)={fread(fid,[m n],''float32'')};');
  k=k+1;
end;
fclose(fid);