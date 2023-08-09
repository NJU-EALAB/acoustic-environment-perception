function [h] = dbesselh(nu,k,z)
%DBESSELH First derivative of the Bessel function of the third kind.
%   H = DBESSELH(NU,K,Z), for K = 1 or 2, computes the derivative of the
%   Hankel function, dH^(K)_NU(Z)/dZ, for each element of the complex 
%   array Z.
%
%   H = DBESSELH(NU,Z) uses K = 1.
%
%   See also:
%   DBESSELJ, DBESSELY
%
%   Copyright 2012 Jan Sch?fer, Institut f¨¹r Lasertechnologien (ILM)
%   Author: Jan Sch?fer (jan.schaefer@ilm.uni-ulm.de)
%   Organization: Institut f¨¹r Lasertechnologien in der Medizin und
%       Me?technik an der Universit?t Ulm (http://www.ilm-ulm.de)

if nargin == 2
    z = k;
    k = 1;
end %if nargin == 2

n = abs(nu);
if nu < 0
    h = ((-1)^n)*(n./z.*besselh(n,k,z)-besselh(n+1,k,z));
else
    h = n./z.*besselh(n,k,z)-besselh(n+1,k,z);
    
end
end