function pos = aziEleDis2Pos(azel,azelPos,dis,disPos)
arguments
    azel (2,:)
    azelPos (3,1)
    dis (1,:)
    disPos (3,1) 
end
disPos = disPos-azelPos;
[x,y,z] = sph2cart(azel(1,:),azel(2,:),1);
angle_dis = getIncludedAngle(disPos,[x;y;z]);
ST = dis./sin(angle_dis);% Sine theorem
angle_disPos = asin(vecnorm(disPos,2,1)./ST);
r = ST.*sin(angle_dis+angle_disPos);
[x,y,z] = sph2cart(azel(1,:),azel(2,:),r);
pos = [x;y;z]+azelPos;
end





