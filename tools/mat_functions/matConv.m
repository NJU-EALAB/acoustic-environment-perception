function W = matConv(U,V)
[M,N,O1] = size(U,1:3);
O2 = size(V,3);
P = size(V,2);
assert(all([N,P]==size(V,1:2)));
W = zeros(M,P,O1+O2-1);
for ii = 1:M
    for jj = 1:P
        for kk = 1:N
            W(ii,jj,:) = W(ii,jj,:) + reshape(conv(squeeze(U(ii,kk,:)),squeeze(V(kk,jj,:))),[1 1 O1+O2-1]);
        end
    end
end

end