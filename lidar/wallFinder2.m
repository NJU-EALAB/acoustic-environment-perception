function vertices = wallFinder2(lindarFileName, wallNum)
% lindarFileName：激光雷达导出文件路径
% wallNum：多边形墙壁数量
% vertices：多边形顶点坐标，matrix size == [2,wallNum]
%% load data
% lindarFileName = 'gl120.txt';
[Angule1,Distance1] = importfile(lindarFileName);
%Distance1=Distance(Distance<10000,:);
%[~,ind]=ismember(Distance1,Distance,'rows');
%Angule1=Angule(ind);
x = Distance1 .* sin(Angule1 * pi / 180) / 1e3;
y = Distance1 .* cos(Angule1 * pi / 180) / 1e3;

pos = [x,y].';
%% get leftDown and upRight
%err = @(opt)errSqu(opt(1:2),opt(3:4),pos,vertices,wallNum);
% find init point
a = [Angule1,Distance1];
a = sortrows(a,1);
Angule = a(:,1);
Distance = a(:,2);
i = 360/wallNum;
c = [0:i:360];
for k = 1:wallNum
 [~, closestPOSITION(k)]=min(abs(Angule-c(:,k)));
end

for k=1:wallNum
Angule_1(k) = Angule(closestPOSITION(:,k));
Distance_1(k) = Distance(closestPOSITION(:,k));
end
x_1 = Distance_1 .* sin(Angule_1 * pi / 180) / 1e3;
y_1 = Distance_1 .* cos(Angule_1 * pi / 180) / 1e3;
vertices0 = [x_1;y_1].';
err = @(vertices)errSqu(pos,vertices,wallNum);



% opt using lsqnonlin
pos_1=min(pos,[],2);
pos_2=max(pos,[],2);
pos1=ones(size(vertices0));
pos_1=(pos1'.*pos_1)';
pos_2=(pos1'.*pos_2)';
ld = pos_1;
ur = pos_2;
options = optimoptions('lsqnonlin','FiniteDifferenceType','central','FunctionTolerance',1e-14,'OptimalityTolerance',1e-10,'Display','iter');
vertices = lsqnonlin(err,vertices0,ld,ur,options);



%% plot
% figure;
% plot(x,y,'o');
% hold on;
% vertices1=[vertices;vertices(1,:)];
% plot(vertices1(:,1),vertices1(:,2),'-o');
% axis equal
%%
%%
end
function err = errSqu(pos,vertices,wallNum)
vertices1=[vertices;vertices(1,:)];
for i=1:wallNum
   for k=1:size(pos,2)%%%%
  d(i,k) = juli( vertices1(i,1),vertices1(i,2),vertices1(i+1,1),vertices1(i+1,2),pos(1,k),pos(2,k) );%%%%
  end
end
err=min(d,[],1);
end
function d = juli( x1,y1,x2,y2,x0,y0 )
if ((y0-y1)*(x0-x2)==(y0-y2)*(x0-x1))&&((max(x1, x2) >= x0 && min(x1, x2) <= x0))&& ((max(y1, y2) >= y0 && min(y1, y2) <= y0))
    d=0;
else
    a2 = (x1-x2)*(x1-x2)+(y1-y2)*(y1-y2);
    b2 = (x0-x2)*(x0-x2)+(y0-y2)*(y0-y2);
    c2 = (x1-x0)*(x1-x0)+(y1-y0)*(y1-y0);
    a = sqrt(a2);
    b = sqrt(b2);
    c = sqrt(c2);
    pos1 = (a2+b2-c2)/(2*a*b);    
    angle1 = acos(pos1);         
    realangle1 = angle1*180/pi; 

    g2 = (x2-x1)*(x2-x1)+(y2-y1)*(y2-y1);
    h2 = (x0-x1)*(x0-x1)+(y0-y1)*(y0-y1);
    f2 = (x2-x0)*(x2-x0)+(y2-y0)*(y2-y0);
    g = sqrt(g2);
    h = sqrt(h2);
    f = sqrt(f2);
    pos2 = (g2+h2-f2)/(2*g*h);    
    angle2 = acos(pos2);         
    realangle2 = angle2*180/pi;
    if realangle1>90
        d = vecnorm([x0;y0]-[x2;y2]).' ;
    elseif realangle2>90
        d = vecnorm([x0;y0]-[x1;y1]).';
    else
%         realangle1<=90&&realangle2<=90
        X1=[x1 y1];
        X2=[x2 y2];
        X0=[x0 y0];
        d = abs(det([X1-X2;X0-X2]))/norm(X1-X2);
    end
end
end