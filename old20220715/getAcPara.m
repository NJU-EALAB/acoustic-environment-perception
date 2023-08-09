function Ac = getAcPara(varargin)
%varargin -> temperature 
if nargin==0
    Ac.c = 343;
else
    Ac.c = (331.4+0.6*varargin{1});
end
Ac.rho = 1.21;
Ac.pRef = 20 * 10^(-6);  %Ref-SPL in Pa
end