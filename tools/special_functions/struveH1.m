function H = struveH1(x)
%1阶struve函数
    if x>30 
        warning('x应小于30否则结果存在较大误差');
    end
    H = 0;
    h = -x;
    for m = 1 : 5000
        h = -x/(2*m-1)*x/(2*m+1)*h;
        H = H + h;
    end
    H=H*2/pi;
    if abs(H) > 40
        error('结果不准确');
    end
end