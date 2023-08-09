function lag = getLag(sig, semaphore, precision)
if nargin<3
    precision = 1;
end
if precision == 1
    lag = zeros(1,size(sig,2));
    assert(size(semaphore,2)==1);
    assert(size(semaphore,1)~=1);
    for ii = 1:size(sig,2)
        [r, lags] = xcorr(sig(:,ii), semaphore);
        [~, I] = max(abs(r));
        lag(ii) = lags(I);
    end
elseif precision>0 && precision<1
    [p,q] = rat(1/precision);
    sig = resample(sig,p,q);
    semaphore = resample(semaphore,p,q);
    lag = precision*getLag(sig, semaphore);
else
    error('invalid precision');
end
end