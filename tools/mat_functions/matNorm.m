function y = matNorm(x)
[M,N] = size(x,[1 2]);
y = zeros(M,N);
for ii = 1:M
    for jj = 1:N
        y(ii,jj) = norm(squeeze(x(ii,jj,:)));
    end
end
end