vertices = [0 2;2 2;2 1;1 1;1 0;0 0];
wallNum=6
materials_1=1;
materials_2=1;
materials_3=5;
h=3;
dd=zeros(size(vertices,1),1);
dh=ones(size(vertices,1),1);
hh=h*dh;
points=[vertices dd;vertices hh];
if mod(wallNum,2)==0 %偶数情况
    n=floor(wallNum/2)-1; %偶数可以分成n个四边形
    faces=cell(wallNum+2*n,1);%设置总共面数
    %if n==1
    %    for i=1:n
    %        faces(2*(i-1)+1,1)={[5 3*(i-1)+1:4+3*(i-1)]};
    %        faces(2*i,1)={[5 3*(i-1)+1+wallNum:4+3*(i-1)+wallNum]};
    %    end
    %else
    for i=1:n %上下面划分n个四边形，以1为起点开始连接（1 2 3 4；1 4 5 6；……）      
        faces(2*(i-1)+1,1)={[materials_1 1 2+2*(i-1) 3+2*(i-1) 4+2*(i-1)]};
        faces(2*i,1)={[materials_2 1+wallNum 2+2*(i-1)+wallNum 3+2*(i-1)+wallNum 4+2*(i-1)+wallNum]};
    end
    %end
    %for i=1:n
    %    faces(2*(i-1)+1,1)={[5 3*(i-1)+1:4+3*(i-1)]};
    %    faces(2*i,1)={[5 3*(i-1)+1+wallNum:4+3*(i-1)+wallNum]};
    %end
    %faces(n+1,1)={[5 4*n:wallNum 1]};
    %faces(2*n+2,1)={[5 4*n+wallNum:2*wallNum 1+wallNum]};
    %for i=2*n+3:wallNum+2*n+2-1
    %    ii=i-(2*n+2);
    %    faces(i,1)={[1 ii ii+wallNum ii+1+wallNum ii+1]};
    %end
    for i=2*n+1:wallNum+2*n-1%连接房间侧面
        ii=i-(2*n+1)+1;
        faces(i,1)={[materials_3 ii ii+wallNum ii+1+wallNum ii+1]};
    end
    faces(wallNum+2*n,1)={[materials_3 wallNum 2*wallNum wallNum+1 1]};
    %for i=1:n
    %    if wallNum/n-4>1
    %        faces(wallNum+2*n+i,1)={[5 4+3*(i-1)+(i-1)*wallNum:wallNum+(i-1)*wallNum 1+(i-1)*wallNum]};
    %        faces(wallNum+2*n+i+n,1)={[5 4+3*(i-1)+wallNum:wallNum+wallNum 1+wallNum]};
    %    end
    %end
    %faces(wallNum+2*n+2,1)={[1 wallNum 2*wallNum wallNum+1 1]};
else
    n=floor(wallNum/2);%奇数情况，是1个三角形＋n-1个四边形
    faces=cell(wallNum+2*n,1);
    if n==1%三边形，只有三角形的情况
        faces(1,1)={[materials_1 1 2 3 3]};
        faces(2,1)={[materials_2 1+wallNum 2+wallNum 3+wallNum 3+wallNum]};
        for i=2*n+1:wallNum+2*n-1%三角形侧面
            ii=i-(2*n+1)+1;
            faces(i,1)={[materials_3 ii ii+wallNum ii+1+wallNum ii+1]};
        end
        faces(wallNum+2*n,1)={[materials_3 wallNum 2*wallNum wallNum+1 1]};
    else
        faces(1,1)={[materials_1 1 2 3 3]};%上下面划分一个三角形
        faces(2,1)={[materials_2 1+wallNum 2+wallNum 3+wallNum 3+wallNum]};
        for i=1:n-1%上下面划分n-1个四边形
            faces(2*(i-1)+3,1)={[materials_1 1 3+2*(i-1) 4+2*(i-1) 5+2*(i-1)]};
            faces(2*i+2,1)={[materials_2 1+wallNum 3+2*(i-1)+wallNum 4+2*(i-1)+wallNum 5+2*(i-1)+wallNum]};
        end
        for i=2*n+1:wallNum+2*n-1%连接房间侧面
            ii=i-(2*n+1)+1;
            faces(i,1)={[materials_3 ii ii+wallNum ii+1+wallNum ii+1]};
        end
        faces(wallNum+2*n,1)={[materials_3 wallNum 2*wallNum wallNum+1 1]};
    end
end
%% Create project 
projectName='room_shape';
materials={'ceiling';'backwall';'frontwall';'sidewall1';'floor';'sidewall2';};
rpf = itaRavenProject('C:\ITASoftware\Raven\RavenInput\Classroom\Classroom.rpf');  
rpf.copyProjectToNewRPFFile(['C:\ITASoftware\Raven\RavenInput\' projectName '.rpf' ]);
rpf.setProjectName(projectName)
rpf.setModelToFaces(points,faces,materials)
rpf.plotModel

