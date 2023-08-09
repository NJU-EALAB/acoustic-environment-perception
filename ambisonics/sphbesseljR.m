function jR = sphbesseljR(l,z,ka)
% Spherical Bessel function with rigid sphere modification
dh = 1/(2*l+1)*(l*sphbesselh(l-1,1,ka)-(l+1)*sphbesselh(l+1,1,ka));
dj = 1/(2*l+1)*(l*sphbesselj(l-1,ka)-(l+1)*sphbesselj(l+1,ka));
jR = sphbesselj(l,z)-sphbesselh(l,1,z)./dh.*dj;
end