function [phi,th,r] = sph2sphs(az,elev,r)
[x,y,z] = sph2cart(az,elev,r);
[phi,th,r] = cart2sphs(x,y,z);