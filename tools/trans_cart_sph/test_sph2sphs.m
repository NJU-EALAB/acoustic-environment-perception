az = 2*pi*rand(1,5)'-pi;
elev = pi*rand(1,5)'-pi/2;
r=ones(1,5)';
[phi,th,r1] =sph2sphs(az,elev,r);
[a,e,r2] =sphs2sph(phi,th,r1);
[az-a,elev-e,r-r2]