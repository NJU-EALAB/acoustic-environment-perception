function [az,elev,r] = sphs2sph(phi,th,r)
[x,y,z] = sphs2cart(phi,th,r);
[az,elev,r] = cart2sph(x,y,z);