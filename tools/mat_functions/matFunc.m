function Y = matFunc(funcHandle,X)
[M,N] = size(X,[1 2]);
O = length(funcHandle(squeeze(X(1,1,:))));
Y = zeros(M,N,O);
for ii = 1:M
    for jj = 1:N
        Y(ii,jj,:) = funcHandle(squeeze(X(ii,jj,:)));
    end
end
end