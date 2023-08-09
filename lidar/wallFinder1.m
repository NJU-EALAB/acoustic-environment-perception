function vertices = wallFinder1(lindarFileName, wallNum)
% lindarFileName：激光雷达导出文件路径
% wallNum：多边形墙壁数量
% vertices：多边形顶点坐标，matrix size == [2,wallNum]
%% load data
% lindarFileName = 'gl120.txt';
[Angule,Distance] = importfile(lindarFileName);

x = Distance .* sin(Angule * pi / 180) / 1e3;
y = Distance .* cos(Angule * pi / 180) / 1e3;
pos = [x,y].';
    
%% get vertices
xlimit =[min(x)-1,max(x)+1];
ylimit = [min(y)-1,max(y)+1];
%%4、确定像素分辨率
pixSize = 0.1;
%% 5、计算总的行列号
row = ceil((ylimit(2) - ylimit(1))/pixSize);
col = ceil((xlimit(2) - xlimit(1))/pixSize);
%% 5、预设一张纯黑图像
img = uint8(zeros(row, col));
%% 6、遍历点云，将点放到图像对应位置处%6.1 获取点的个数
[r,~] = size(pos');
%% 6.2遍历所有点

for i= 1:1:r
x0 = pos(1,i);yo = pos(2,i);%计算当前点对应的行号
rID = floor((yo - ylimit(1))/pixSize)+1;%计算当前点对应的列号
cID = floor((x0 - xlimit(1))/pixSize)+1;%改变图像对应位置的像素值
img(rID,cID)= 255;
end
rID1=floor((0 - ylimit(1))/pixSize)+1;
cID1 = floor((0 - xlimit(1))/pixSize)+1;


imshow(img);
BW=edge(img,'canny');
imshow(BW);
plot(x0,yo)


[ H, theta, rho ] =hough(img,'RhoResolution',1,'Theta',-90:0.5:89);
peaks=houghpeaks(H,wallNum,'threshold', ceil(0.3*max(H(:))));
lines = houghlines(img,theta,rho,peaks,'FillGap',100,'MinLength',6);
%% 画图
imshow(img), hold on;
for k = 1:length(lines)
xy = [lines(k).point1; lines(k).point2];
plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');%画出线段
plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');%起点
plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');%终点
end


plot(lines(1).point1,lines(1).point2);hold on;
plot(lines(2).point1,lines(2).point2);hold on;
plot(lines(3).point1,lines(3).point2);hold on;
plot(lines(4).point1,lines(4).point2)
%%
k = 1 : length(lines) 
xy1 = [lines(k).point1];
xy2 = [lines(k).point2];
A=reshape(xy1,2,length(lines));
B=reshape(xy2,2,length(lines));
%X=[A(1,:); B(1,:)];
%Y=[A(2,:); B(2,:)];
%line(X,Y);


for k = 1:length(lines)
    for m=1:length(lines)
        if m~=k
       d1(m,k) = abs(det([B(:,k)'-A(:,k)';A(:,m)'-A(:,k)']))/norm(B(:,k)'-A(:,k)');
       d2(m,k)= abs(det([B(:,k)'-A(:,k)';B(:,m)'-A(:,k)']))/norm(B(:,k)'-A(:,k)');
        end
    end
end
d1(logical(eye(size(d1))))=inf;
d2(logical(eye(size(d2))))=inf;

for i = 1 : size(d1, 1)
[d1_min(i),in] = min(d1(i, :)); % 将每行当成一个行向量，取其最小值
[g,h] = ind2sub(size(d1),in);
fprintf('找到的第%d条线段的d1中最小值为：%d 距离最近的是第%d条直线',i,d1_min(i),g);
L(i)=g;
end
for i = 1 : size(d2, 1)
[d2_min(i),in] = min(d2(i, :)); 
[c,d] = ind2sub(size(d2),in);
fprintf('找到的第%d条线段的d2中最小值为：%d 距离最近的是第%d条直线',i,d2_min(i),c);
F(i)=c;
end


for k = 1:length(lines)
    n=L(:,k);
    [x_intersect1(k) y_intersect1(k)]=node(A(:,k)',B(:,k)',A(:,n)',B(:,n)');
end
for k = 1:length(lines)
    n=F(:,k);
    [x_intersect2(k) y_intersect2(k)]=node(A(:,k)',B(:,k)',A(:,n)',B(:,n)');
end
XY1=[x_intersect1' y_intersect1'];
XY2=[x_intersect2' y_intersect2'];
XY=[XY1;XY2];
XY=unique(XY,'row','sorted');
Y_transform=(XY(:,2)-rID1).*pixSize;
X_transform=(XY(:,1)-cID1).*pixSize;
XY_transform=[X_transform Y_transform];

cx = mean(X_transform);
cy = mean(Y_transform);
a = atan2(Y_transform - cy, X_transform - cx);
[~, order] = sort(a, 'descend');
x_1 = X_transform(order);
y_1 = Y_transform(order);
vertices=[x_1 y_1].';
vertices1=[vertices vertices(:,1)];


function [X Y]= node( X1,Y1,X2,Y2 )

if X1(1)==Y1(1)
   X=X1(1);
   k2=(Y2(2)-X2(2))/(Y2(1)-X2(1));
   b2=X2(2)-k2*X2(1); 
   Y=k2*X+b2;
end
if X2(1)==Y2(1)
   X=X2(1);
   k1=(Y1(2)-X1(2))/(Y1(1)-X1(1));
   b1=X1(2)-k1*X1(1);
   Y=k1*X+b1;
end
if X1(1)~=Y1(1)&X2(1)~=Y2(1)
   k1=(Y1(2)-X1(2))/(Y1(1)-X1(1));
   k2=(Y2(2)-X2(2))/(Y2(1)-X2(1));
   b1=X1(2)-k1*X1(1);
   b2=X2(2)-k2*X2(1);
    if k1==k2
      X=[];
      Y=[];
    else
   X=(b2-b1)/(k1-k2);
   Y=k1*X+b1;
   end
end
end


%% check output
assert(all(size(vertices,[1 2])==[2,wallNum]));
end