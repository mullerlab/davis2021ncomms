function [a,b,stats,corr] = linear_regression(x,y)
% *WAVE*
% 
% LINEAR REGRESSION     linear regression, a la Frederic Chavane
%                           linear regression of y = a.x + b
%                           x and y should be vectors of similar length
% 
% INPUT
% x,y - vectors (same length)
%
% OUTPUT
% a - slope
% b - intercept
% stats vector - [ R F pf t pt ]
%   where R is the r2 regression coefficient
%   F the F statistics and p its p-value, pf
%   t-statistic on the slope a (testing if different than 0), and its p-value, pt
% corr vector = [varx vary cov corrcoef tr ptr]
%   where varx, vary is the variance of x and y
%   cov the covariance between x & y
%   corrcoef the correlation coefficient
%
% REVISION HISTORY
% Created, Fredo, March 2001
% Adapted, Lyle, December 2012
%

 N=size(x,1);

 if or(size(x,2)>1,size(y,2)>1), error('x and y should be vectors'), end;
 if size(x,1)~=size(y,1), error('x and y should have the same length'), end;
   
   
 %%%%%%%%%%%%%% SLOPE AND INTERCEPT
 
 Sxx=nansum((x-nanmean(x)).^2);
 Syy=nansum((y-nanmean(y)).^2);
 Sxy=nansum((x-nanmean(x)).*(y-nanmean(y)));

 a=Sxy/Sxx;             % the slope
 b=nanmean(y)-a*nanmean(x);      % the intercept
 
 %%%%%%%%%%%%%%  STATS VECTOR
 
 SSE=nansum((y-a*x-b).^2) ; 	% Sum of Square Error
 SSR=Syy-SSE;  		% Sum of Square Regression 
 	
 R=SSR/Syy;       		% the r2 correlation coefficient

 F=SSR*(N-2)/SSE;     		% the F statistic =  MSR/MSE 
                                % where MSR=SSR/1 and MSE=SSE/(N-2) (Mean Square Regression and Mean Square Error)
 pf = 1-fcdf(F,1,N-2) ; 	% its corresponding p-value
 
 t  = a/sqrt(SSE/((N-2)*Sxx));   % t-statistic => t= (a-0) / std error of  a
 pt = 1-tcdf(t,N-1);             % p value for the test: H0: slope = 0, 
                                 %                       H1: slope > 0 (one-tailed) 
 
 stats=[R F pf t pt];
 
 %%%%%%%%%%%%%% CORR VECTOR
 
 varx=(Sxx)/(N-1); 		% the variance of x
 vary=(Syy)/(N-1); 		% the variance of y
 cov=(Sxy)/(N-1);  		% the co-variance of x & y
 corrcoef=cov/sqrt(varx*vary);  % the correlation coefficient, which is equal to the square root of R

 tr = corrcoef*sqrt((N-2)/(1-(corrcoef^2)));
 ptr =1-tcdf(tr,N-2);                         % probability that the corrcoef is significant

 corr=[varx vary cov corrcoef tr ptr];
