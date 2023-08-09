clc
clear all
close all
%% load data
filename = 'C:\Users\29210\Desktop\LidarScan\gl120.txt';
[Angule,Distance,Quality] = importfile(filename);

x = Distance .* sin(Angule * pi / 180) / 1e3;
y = Distance .* cos(Angule * pi / 180) / 1e3;
pos = [x,y].';
%% get leftDown and upRight
L12 = 1;
d = 0.5;
err = @(opt)errSqu(opt(1:2),opt(3:4),pos,L12);
% find init point
method = 1;
if method == 1
    % method 1
    opt0 = [min(x);min(y);max(x);max(y)];
    x1 = opt0(1);
    x2 = opt0(3);
    y1 = opt0(2);
    y2 = opt0(4);
    err0 = inf;
    for x1 = min(x):d:max(x)
        tic
        for x2 = x1:d:max(x)
            for y1 = min(x):d:max(x)
                for y2 = y1:d:max(x)
                    if norm(err([x1;y1;x2;y2]))<err0
                        opt0 = [x1;y1;x2;y2];
                        err0 = norm(err([x1;y1;x2;y2]));
                    end
                end
            end
        end
        toc
    end
elseif method == 2
    % method 2
    
end
% opt using lsqnonlin
options = optimoptions('lsqnonlin','FiniteDifferenceType','central','FunctionTolerance',1e-14,'OptimalityTolerance',1e-10,'Display','iter');
opt = lsqnonlin(err,opt0,[],[],options);
ld = opt(1:2);
ur = opt(3:4);
x1 = ld(1);
x2 = ur(1);
y1 = ld(2);
y2 = ur(2);
%% plot
figure;
plot(x,y,'o');
hold on;
plot([x1 x1 x2 x2 x1],[y1 y2 y2 y1 y1]);
%%
%%
function err = errSqu(ld,ur,pos,L12)
x1 = ld(1);
x2 = ur(1);
y1 = ld(2);
y2 = ur(2);
x = pos(1,:);
y = pos(2,:);

% 9 area
%  x1 x2
% 1|2|3
% -|-|-       y2
% 4|5|6
% -|-|-       y1
% 7|8|9
ax1 = (x<x1);
ax2 = (x1<=x)&(x<x2);
ax3 = (x2<=x);
ay1 = (y<y1);
ay2 = (y1<=y)&(y<y2);
ay3 = (y2<=y);
e1 = vecnorm(pos(:,ax1&ay3)-[x1;y2]).';
e2 = abs(pos(2,ax2&ay3)-y2).';
e3 = vecnorm(pos(:,ax3&ay3)-[x2;y2]).';
e4 = abs(pos(1,ax1&ay2)-x1).';
e5 = min([abs(pos(1,ax2&ay2)-x1);abs(pos(1,ax2&ay2)-x2);abs(pos(2,ax2&ay2)-y1);abs(pos(2,ax2&ay2)-y2)],[],1).';
e6 = abs(pos(1,ax3&ay2)-x2).';
e7 = vecnorm(pos(:,ax1&ay1)-[x1;y1]).';
e8 = abs(pos(2,ax2&ay1)-y1).';
e9 = vecnorm(pos(:,ax3&ay1)-[x2;y1]).';
err = [e1;e2;e3;e4;e5;e6;e7;e8;e9];
if L12 == 1
    err = sqrt(err);
end
end