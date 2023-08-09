function [rpf, outputFilePath]=raven_setModelToFaces(vertices,h,pathname,projectName)
materials_1=1;
materials_2=2;
materials_3=3;
%wallNum=app.EditField_3.Value;
%lindarFileName=app.file;
%app.vertices=wallFinder2(lindarFileName, wallNum);
%a=roundn(vertices,-2);
%app.EditField_2.Value =  mat2str(a);
dd=zeros(size(vertices,1),1);
dh=ones(size(vertices,1),1);
hh=h*dh;
points=[vertices dd;vertices hh];
%% define faces
numP = size(points,1);
faces = cell(numP/2+2);
% wall
for ii = 1:numP/2-1
    faces{ii} = [materials_1, ii, ii+1, numP/2+ii+1, numP/2+ii];
end
faces{numP/2} = [materials_1, numP/2, 1, numP/2+1, numP];
% floor
faces{numP/2+1} = [materials_2,1:numP/2];
% ceil
faces{numP/2+2} = [materials_3,numP/2+(1:numP/2)];
%% Create project
%projectName='room_shape';
materials={'wall';'floor';'ceil';};
rpf = itaRavenProject('untitled.rpf');
rpf.copyProjectToNewRPFFile([pathname projectName]);
rpf.setProjectName(projectName);
[rpf, outputFilePath] = setModelToFaces_revise(rpf,points,faces,materials);
end