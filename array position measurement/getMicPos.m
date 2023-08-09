function micPos = getMicPos()
% micPos [3*N]
run mainFixed;
% pos azi
th = azi./180.*pi;
R = [cos(th) -sin(th) 0;
    sin(th) cos(th) 0;
    0 0 1];

d = 0.275./6;
h = 0.1;
micPos0 = [0 3*d h; -3*d -d h;0 -3*d h;3*d -d -0.29;zeros(4,3)].';

micPos = R*micPos0+pos;
% arrayPos = [-5.33 0.12 1.88;0.18 0.16 1.12+elementSpace/2;0 -1.97+0.12 2.23;5.15 0.12 1.94].';
% arrayAxis = [1 0 0;0 0 -1;1 0 0;1 0 0].';
% micPos = reshape([arrayPos-0.5*elementSpace*arrayAxis;arrayPos+0.5*elementSpace*arrayAxis],3,[]);

end