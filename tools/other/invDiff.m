function x = invDiff(y,x1,xend)
%差分逆过程，按行计算，不输入xend为一阶，x1、xend为列向量
if nargin == 2
    x=cumsum([x1,y],2);
else
    y1=cumsum([zeros(length(x1),1),y],2);
    x=cumsum([x1,y1],2);
    x=x+(xend-x(:,end))./(length(x)-1)*(0:length(x)-1);
end

