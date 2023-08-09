%%
% P\S format
% Reference points
% P1 = [0 0 1]';
% P2 = [2 0 0]';
% P3 = [2 2 0]';
% P4 = [0 2 0]';
% 
% %distances
% s1 = 2.449;  % distance to P1
% s2 = 1.732; % distance to P2
% s3 = 1.732; % distance to P3
% s4 = 1.732; % distance to P4
% 
% P =[P1 P2 P3 P4]; % Reference points matrix
% S = [s1 s2 s3 s4]; % Distance vector

function [N1, N2] = location(P,S,weightFlag)
 
% P1 = [0 0 1]';
% P2 = [2 0 0]';
% P3 = [2 2 0]';
% P4 = [0 2 0]';
% 
% %distances
% s1 = 2.449;  % distance to P1
% s2 = 1.732; % distance to P2
% s3 = 1.732; % distance to P3
% s4 = 1.732; % distance to P4
% 
% P =[P1 P2 P3 P4]; % Reference points matrix
% S = [s1 s2 s3 s4]; % Distance vector

if nargin==2
    weightFlag = 0;
end

A = [ones(4,1),-2*P.'];
b = S.'.^2-vecnorm(P).'.^2;

    
if rank (A)==3
    Xp=pinv(A)*b;
    xp = Xp(2:4,:);
    Z = null(A,'r');
    z = Z(2:4,:);
    %Polynom coeff.
    a2 = z(1)^2 + z(2)^2 + z(3)^2 ;
    a1 = 2*(z(1)*xp(1) + z(2)*xp(2) + z(3)*xp(3))-Z(1);
    a0 = xp(1)^2 +  xp(2)^2+  xp(3)^2-Xp(1);
    p = [a2 a1 a0];
    t = roots(p);

    %Solutions
    N1 = Xp + t(1)*Z;
    N1 = N1(2:4,:);
    N2 = Xp + t(2)*Z;
    N2 = N2(2:4,:);
else
    Xpdw=pinv(A)*b;

    if weightFlag == 0
        N1 = Xpdw(2:4,:);
        N2 = N1;
    else 
       m = A.*Xpdw-b;
       W = 1./(norm(m,2));
       C = W'*W;
       Xpdw =inv(A'*C*A)*A'*C*b; % Solution with Weights Matrix
       N1 = Xpdw(2:4,:);
       N2 = N1;
    end
   
end


end
