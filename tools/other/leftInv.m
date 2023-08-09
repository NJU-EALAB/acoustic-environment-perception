function invX = leftInv(X,regCoeff)
if nargin<2
    regCoeff = 0;
end
XX = X'*X;
invX = (XX + regCoeff*max(abs(eig(XX))) * eye(size(XX,1)) )\X';
end
