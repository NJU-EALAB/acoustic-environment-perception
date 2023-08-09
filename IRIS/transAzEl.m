function azElNew = transAzEl(azEl,axis)
arguments
    azEl (:,2)
    axis (3,3)
end
axis = axis./vecnorm(axis);
[x,y,z] = sph2cart(azEl(:,1),azEl(:,2),1);
X = axis*[x,y,z].';
[az,el] = cart2sph(X(1,:),X(2,:),X(3,:));
azElNew = [az;el].';
end