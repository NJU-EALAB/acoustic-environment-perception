function [x,y,z] = sphs2cart(phi,th,r)
%SPH2cart Transform spherical to Cartesian coordinates.

z = r .* cos(th);
rxy = r .* sin(th);
x = rxy .* cos(phi);
y = rxy .* sin(phi);
