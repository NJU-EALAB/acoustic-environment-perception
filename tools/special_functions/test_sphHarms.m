clear all
phi = linspace(0,2*pi,361);
th = linspace(0,pi,181);
vct = getMesh(phi,th);
phi = vct(1,:);
th = vct(2,:);

condon = 0;
ver = 2;
N = 8;

tic
sh1 = [];
for n = 0:N
    for m = -n:n
        sh1 = [sh1,sphharm(n,m,th,phi,condon,ver).'];
    end
end
toc
tic
sh2 = sphHarms(N,phi,th,'complex',0);
toc
norm(sh1-sh2)
% [sphHarms(2,1,1,'complex',1); getSH(2,[1,1],'complex')].'