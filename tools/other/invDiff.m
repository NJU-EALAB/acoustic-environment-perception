function x = invDiff(y,x1,xend)
%�������̣����м��㣬������xendΪһ�ף�x1��xendΪ������
if nargin == 2
    x=cumsum([x1,y],2);
else
    y1=cumsum([zeros(length(x1),1),y],2);
    x=cumsum([x1,y1],2);
    x=x+(xend-x(:,end))./(length(x)-1)*(0:length(x)-1);
end

