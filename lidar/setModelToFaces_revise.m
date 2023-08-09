function [obj, outputFilePath] = setModelToFaces_revise(obj,points,faces,materials)
% setModelToFaces
% creates a room model using points and faces and automatically
% sets the model of the current project to the so defined room.
% The room has one material assigned to each face (mat1 ..
% mat6), which can be set using
%       rpf.setMaterial(mat1,abs,scat)
%
% Using:
%   outputFileName = rpf.setModelToFaces(points,faces,materials);
%
%   see ita_raven_demo_faces_room for more details on usage
%
% Input:
%   points (matrix Nx3 in meters, columns represnt x, y, and z)
%   faces (cell array, faces are defined pointing to the rows
% of matrix points) the first element points the material
%   materials (cell array) This array does not necesarlly match
% the number of surfaces
% Output:
%   FilePath: full path of save ac3d model
%

nW=length(faces);

outputFileName = ['room_' num2str(nW) '_faces'];

if strfind(obj.modelFileList,'RavenModels')
    outputFilePath = [ obj.modelFileList(1:strfind(obj.modelFileList,'RavenModels')+10) '\' outputFileName ];
    
else
    % if model wasn't stored in RavenModels folder, save it in
    % the folder of the current rpf file.
    outputFilePath = [ fileparts(obj.ravenProjectFile) '\' outputFileName ];
end

fn = floor(size(points,2)/4); % first element of a three elements point

if size(points,2)>3
    idx = (points(:,1));
else
    idx=1:size(points,1);
end


fid = fopen(outputFilePath,'w');
fprintf(fid,'AC3Db\n');

for iW=1:nW
    fprintf(fid,['MATERIAL "' materials{faces{iW}(1)} '" rgb ' num2str(0.0) ' ' num2str(0.0) ' ' num2str(0.9/nW*iW) ' amb 0.2 0.2 0.2  emis 0 0 0  spec 0.2 0.2 0.2  shi 128  trans 0 \n']);
end

fprintf(fid,'OBJECT world\n');
fprintf(fid,['kids ' num2str(nW) '\n']);

for iW=1:nW
    nP=length(faces{iW})-1;
    
    fprintf(fid,'OBJECT poly\n');
    fprintf(fid,'name "polygon_object"\n');
    
    fprintf(fid,['numvert ' num2str(nP) '\n']);
    
    for iP=1:nP
        fprintf(fid,[sprintf('%1.4f %1.4f %1.4f',points(faces{iW}(iP+1)==idx,fn+(1:3))) '\n']);
    end
    
    fprintf(fid,'numsurf 1\n');
    fprintf(fid,'SURF 0x10\n');
    fprintf(fid,['mat ' num2str(iW-1) '\n']);
%     fprintf(fid,'refs 4\n'); 
    fprintf(fid,['refs ' num2str(nP) '\n']);
%     fprintf(fid,'3 0 0\n');
%     fprintf(fid,'2 0 0\n');
%     fprintf(fid,'1 0 0\n');
%     fprintf(fid,'0 0 0\n');
    for iP=1:nP
        fprintf(fid,[sprintf('%d 0 0',nP-iP) '\n']);
    end
    fprintf(fid,'kids 0\n');
    
    
end

fclose(fid);
obj.setModel(outputFilePath);

end