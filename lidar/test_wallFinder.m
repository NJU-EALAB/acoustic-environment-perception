%%
lindarFileName = 'fangjian.txt';
wallNum = 4;
%%
[Angule,Distance] = importfile(lindarFileName);

x = Distance .* sin(Angule * pi / 180) / 1e3;
y = Distance .* cos(Angule * pi / 180) / 1e3;
%%
vertices = wallFinder(lindarFileName, wallNum);
%%
figure;
plot(x,y,'o');
hold on;
plot(vertices(1,:),vertices(2,:));
axis equal