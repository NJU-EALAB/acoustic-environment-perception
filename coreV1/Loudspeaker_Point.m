clear;
%% 原点
point_0 = [0, 0, 0];
%% 墙面
point_wall = zeros(8,3);
point_wall(:,3) = [zeros(4,1); 3.65*ones(4,1)];
point_wall([1,2,5,6],1) = -6.01*ones(4,1);
point_wall([3,4,7,8],1) = (11.78-6.01)*ones(4,1);
point_wall([1,4,5,8],2) = 9.14*ones(4,1);
point_wall([2,3,6,7],2) = (9.14-15.38)*ones(4,1);
%% 前方 FS1-6
point_FS = zeros(5,3);
point_FS(:,2) = sqrt(5.84^2-(2.35-1.2)^2) * ones(5,1);
point_FS(:,3) = 2.35 * ones(5,1);
point_FS(3,1) = 0;
point_FS(4,1) = point_FS(3,1) + 1.58;
point_FS(5,1) = point_FS(4,1) + 1.55;
point_FS(2,1) = point_FS(3,1) - 1.60;
point_FS(1,1) = point_FS(2,1) - 1.41;
%% 顶部 CS (1:4)-(1:4)
point_CS = zeros(16,3);
point_CS(:,3) = 2.84*ones(16,1);
% CS (1-3)-4
point_CS(4:4:16,1) = point_FS(5,1);
point_CS(4,2) = point_FS(5,2) - 2.60;
point_CS(8,2) = point_CS(4,2) - 2.30;
point_CS(12,2) = point_CS(8,2) - 3.12;
% CS (1-3)-3
point_CS([3,7,11],1) = point_CS(12,1) - 1.76;
point_CS(11,2) = point_CS(12,2) - 0.12;
point_CS(7,2) = point_CS(11,2) + 2.73;
point_CS(3,2) = point_CS(7,2) + 2.83;
% CS (1-3)-2
point_CS([2,6,10],:) = point_CS([3,7,11],:) - [2.51,0,0];
% CS (1-3)-1
point_CS([1,5,9],1) = point_CS(10,1) - 1.76;
point_CS(9,2) = point_CS(10,2) + 0.12;
point_CS(5,2) = point_CS(9,2) + 3.12;
point_CS(1,2) = point_CS(5,2) + 2.30;
% CS 4-(1-4)
point_CS([13:16],:) = point_CS([9:12],:);
point_CS([13:16],2) = (point_CS(12,2)-2.35) * ones(4,1);
%% 侧面 RS1-4 LS1-4
% RS1-4
point_RS = zeros(4,3);
point_RS(:,3) = 2.35*ones(4,1);
point_RS(:,1) = point_CS(16,1) + 1.35;
point_RS(4,2) = point_CS(16,2) + 0.35;
point_RS(3,2) = point_RS(4,2) + 2.40;
point_RS(2,2) = point_RS(3,2) + 2.35;
point_RS(1,2) = point_RS(2,2) + 2.46;
% LS1-4
point_LS = zeros(4,3);
point_LS(:,3) = 2.35*ones(4,1);
point_LS(:,1) = point_CS(13,1) - 1.35;
point_LS(4,2) = point_CS(16,2) + 0.35;
point_LS(3,2) = point_LS(4,2) + 2.40;
point_LS(2,2) = point_LS(3,2) + 2.35;
point_LS(1,2) = point_LS(2,2) + 2.46;
%% 后方 BS2-3
point_BS = zeros(2,3);
point_BS([1:2],3) = 2.84 * ones(2,1);
point_BS(1,1) = point_CS(14,1) + 0.4;
point_BS(2,1) = point_CS(15,1) - 0.4;
% point_BS([1,2],2) = (9.14-15.38) * ones(2,1);
point_BS(1,2) = point_CS(14,2) - 1;
point_BS(2,2) = point_CS(15,2) - 1;

%% PLOT
figure;
scatter3(point_0(:,1),point_0(:,2),point_0(:,3));
hold on;
axis equal;
scatter3(point_wall(:,1),point_wall(:,2),point_wall(:,3));
scatter3(point_FS(:,1),point_FS(:,2),point_FS(:,3));
scatter3(point_CS(:,1),point_CS(:,2),point_CS(:,3));
scatter3(point_RS(:,1),point_RS(:,2),point_RS(:,3));
scatter3(point_LS(:,1),point_LS(:,2),point_LS(:,3));
scatter3(point_BS(:,1),point_BS(:,2),point_BS(:,3));
%% 变坐标系
pos = [point_FS;[0 6 0];point_BS;point_LS;point_RS;point_CS;];
pos = [pos(:,2) -pos(:,1) pos(:,3)];
figure;
scatter3(pos(:,1),pos(:,2),pos(:,3));
xlabel('x');
