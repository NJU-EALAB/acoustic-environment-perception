function [ Ynm ] = sphharm(n,m,theta,phi,condon,version,debug)
% SPHHARMONICS spherical harmonics
if nargin < 7    debug = 0;end
if nargin < 6    version = 1;end
if nargin < 5    condon = 1;end

% warning: if m<0, Ynm_v1 == -Ynm_v2
if version == 1
    [ Ynm ] = (-1)^m*sphharmonics(n,m,pi/2-theta,phi);% == shengxueyuanli P224 (2.4.10d)
elseif version == 2
    [ Ynm ] = harmonicY(n,m,theta,phi);% == mathematica
else
    error('No such version.');
end

if condon == 0
    Ynm = (-1)^m*Ynm;
end

if debug
    assert(1e-6>abs(sphharm(n,m,theta,phi,1,1,0)-sphharm(n,m,theta,phi,1,2,0))./abs(sphharm(n,m,theta,phi,1,1,0)+sphharm(n,m,theta,phi,1,2,0)));
    assert(1e-6>abs(sphharm(n,m,theta,phi,0,1,0)-sphharm(n,m,theta,phi,0,2,0))./abs(sphharm(n,m,theta,phi,0,1,0)+sphharm(n,m,theta,phi,0,2,0)));
end
    