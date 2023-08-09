function [phi,th,r] = cart2sphs(x,y,z)
%cart2SPH Transform Cartesian to spherical coordinates.
% phi -pi~pi
% th 0~pi
% r0~inf

hypotxy = hypot(x,y);
r = hypot(hypotxy,z);
th = atan2(hypotxy,z);
phi = atan2(y,x);
