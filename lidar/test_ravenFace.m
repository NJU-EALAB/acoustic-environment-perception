%% test data
vertices = [0 0;1 0;1 1;2 1;2 2;0 2];
wallNum = size(vertices,1);

matIdx = 5;
h=3;
dd=zeros(size(vertices,1),1);
dh=ones(size(vertices,1),1);
hh=h*dh;
points=[vertices dd;vertices hh];
%% define faces
numP = size(points,1);
faces = cell(numP/2+2);
% wall
for ii = 1:numP/2-1
    faces{ii} = [matIdx, ii, ii+1, numP/2+ii+1, numP/2+ii];
end
faces{numP/2} = [matIdx, numP/2, 1, numP/2+1, numP];
% floor
faces{numP/2+1} = [matIdx,1:numP/2];
% ceil
faces{numP/2+2} = [matIdx,numP/2+(1:numP/2)];
%% Create project 
projectName='room_shape';
materials={'ceiling';'backwall';'frontwall';'sidewall1';'floor';'sidewall2';};
rpf = itaRavenProject('C:\ITASoftware\Raven\RavenInput\Classroom\Classroom.rpf');  
rpf.copyProjectToNewRPFFile(['C:\ITASoftware\Raven\RavenInput\' projectName '.rpf' ]);
rpf.setProjectName(projectName);
[rpf, outputFilePath] = setModelToFaces_revise(rpf,points,faces,materials);
rpf.plotModel;