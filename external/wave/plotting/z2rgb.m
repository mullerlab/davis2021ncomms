function C = z2rgb(z)
% *WAVE*
%
% Z2RGB    Complex variable color image -- maps a complex
%          matrix into a full color image.
%
%          First produced by: 
%          John Richardson (http://home.gte.net/jrsr/complex.html)
%
%          Example: 
%          [x,y] = meshgrid(-2:1/16:2); z = x+i*y;
%          image(z2rgb(F(z)))
%
% INPUT 
% z - complex data matrix (r,c)
%
% OUTPUT
% C - colormapped output
%

r = abs(z);
a = sqrt(1/6)*real(z);
b = sqrt(1/2)*imag(z);
d = 1./(1+r.^2);
R = 1/2 + sqrt(2/3)*real(z).*d;
G = 1/2 - d.*(a-b);
B = 1/2 - d.*(a+b);
d = 1/2 - r.*d;
d(r<1) = -d(r<1);
C(:,:,1) = R + (d);
C(:,:,2) = G + (d);
C(:,:,3) = B + (d);       % LM (1/12): added scaling factor of 2

