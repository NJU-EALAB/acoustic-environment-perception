elementSpace = 0.275;
arrayPos = [-5.33 0.12 1.88;0.18 0.16 1.12+elementSpace/2;0 -1.97+0.12 2.23;5.15 0.12 1.94].';
arrayAxis = [1 0 0;0 0 -1;1 0 0;1 0 0].';
micPos = reshape([arrayPos-0.5*elementSpace*arrayAxis;arrayPos+0.5*elementSpace*arrayAxis],3,[]);
srcPosReal = [2.03,4.58,2.12;0 4.63 2.12;-1.45 3.93 2.12].';
srcPosMeas = [2.058,4.503,2.225;0.037 4.52 2.146;-1.533 3.899 2.079].';
dSrcPos = vecnorm(srcPosReal-srcPosMeas,2,1);

figure;
scatter3(micPos(1,:),micPos(2,:),micPos(3,:),'DisplayName','microphone','LineWidth',2);
hold on;xlabel('x');ylabel('y');zlabel('z');legend;axis equal;
scatter3(srcPosReal(1,:),srcPosReal(2,:),srcPosReal(3,:),'DisplayName','real source','LineWidth',2);
scatter3(srcPosMeas(1,:),srcPosMeas(2,:),srcPosMeas(3,:),'DisplayName','measurement source','LineWidth',2);
