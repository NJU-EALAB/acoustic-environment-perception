function f = getLogFreq(f1,f2,oct)
arguments
    f1(1,1)
    f2(1,1)
    oct(1,1)
end
k = 2.^(oct);
N = floor(abs(log2(f2./f1))./oct)+1;
if f1>f2
    k = 1./k;
end
f = f1*(k.^(0:N-1));
f = f(:);
end