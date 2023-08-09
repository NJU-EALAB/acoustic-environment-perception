function sh = sphHarms(N,phi,th,type,condon)
% spherical harmonic. column n,m: 0,0;1,-1;1,0;1,1;...;N,N-1;N,N (0<=n<=N, -n<=m<=n)
%%
arguments
    N (1,1)
    phi (:,1)
    th (:,1)
    type = 'complex'
    condon = false
end
if length(phi)==1
    phi = phi+0*th;
end
if length(th)==1
    th = th+0*phi;
end
assert(length(phi)==length(th));
%% get chAll
if strcmpi(type,'complex')
    chAll = 1./sqrt(2*pi)*exp(1i*phi*(-N:N));
elseif strcmpi(type,'real')
    chAll = circHarmReal(phi,-N:N);
else
    error('No such type.');
end
%% get sh
sh = zeros(length(phi),(N+1).^2);
for n = 0:N
    ch = chAll(:,N+1+(-n:n));
    shHalf = legendre(n,cos(th),'norm').';
    if strcmpi(type,'complex')
        sh(:,n^2+1:(n+1)^2) = [fliplr((-1).^(1:n).*shHalf(:,2:end)),shHalf].*ch;
    elseif strcmpi(type,'real')
        sh(:,n^2+1:(n+1)^2) = [fliplr(shHalf(:,2:end)),shHalf].*ch;
    end
end
%% condon: add (-1)^m
if condon
    condonGain = zeros(1,(N+1).^2);
    idx = 1;
    for n = 0:N
        for m = -n:n
            condonGain(idx) = (-1).^m;
            idx = idx+1;
        end
    end
    assert(idx==(N+1).^2+1);
    sh = sh.*condonGain;
end

end