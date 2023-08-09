function N = locationFixed(x,P,S)


N1 = (vecnorm(P(:,1)-x)-S(1));
N2 = (vecnorm(P(:,2)-x)-S(2));
N3 = (vecnorm(P(:,3)-x)-S(3));
N4 = (vecnorm(P(:,4)-x)-S(4));

N = [N1;N2;N3;N4];
N = N-mean(N);
% N = sqrt(N1 + N2 + N3 + N4);



end