function H = struveH1(x)
%1��struve����
    if x>30 
        warning('xӦС��30���������ڽϴ����');
    end
    H = 0;
    h = -x;
    for m = 1 : 5000
        h = -x/(2*m-1)*x/(2*m+1)*h;
        H = H + h;
    end
    H=H*2/pi;
    if abs(H) > 40
        error('�����׼ȷ');
    end
end