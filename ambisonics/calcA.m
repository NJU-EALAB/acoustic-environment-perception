% A. Politis and V. Pulkki,  “Acoustic intensity, energy-density and diffuseness estimation in a directionally-constrained region.” arXiv, Sep. 13, 2016, Accessed: Jun. 28, 2022. [Online]. Available: http://arxiv.org/abs/1609.03409.
addpath('../../Spherical-Harmonic-Transform/');
%%
N = 2;
% complex(Eq. 19)
xyz1 = sqrt(2*pi/3)*[1 1i 0;0 0 sqrt(2);-1 1i 0];
% real
xyz2 = sqrt(4*pi/3)*[0 1 0;0 0 1;1 0 0];% TODO: verify correctness

xyz = xyz1;
%%
% Gaunt coefficient
G = gaunt_mtx(N, 1, N+1);
G = permute(G,[3 1 2]);
A = zeros((N+2)^2,(N+1)^2,3);
for ii = 1:size(A,1)
    for jj = 1:size(A,2)
        A(ii,jj,1) = xyz(1,1)*G(ii,jj,2)+xyz(3,1)*G(ii,jj,4);
        A(ii,jj,2) = xyz(1,2)*G(ii,jj,2)+xyz(3,2)*G(ii,jj,4);
        A(ii,jj,3) = xyz(2,3)*G(ii,jj,3);
    end
end
A0 = A_xyz(1:size(A,1),1:size(A,2),1:size(A,3));
    
    
    
    