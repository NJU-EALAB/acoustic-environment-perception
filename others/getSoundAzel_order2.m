function [azimuth,elevation] = getSoundAzel_order2(wallPos, srcPos, micPos)
% wallPos (3,M)
% srcPos (3,N)
% micPos (3,1)
% % % azimuth = zeros(size(wallPos,2)+1,size(srcPos,2));
% % % elevation = zeros(size(wallPos,2)+1,size(srcPos,2));
warning('temp order2');
wall.x = wallPos;
wall.n = wall.x./vecnorm(wall.x);
for ii = 1:size(srcPos,2)
    mirrorSrcPos = getMirrorSrcPos(srcPos(:,ii),wall);
    mirrorSrcPos2 = zeros(3,0);
    for jj = 1:size(mirrorSrcPos,2)
        mirrorSrcPos2 = [mirrorSrcPos2,getMirrorSrcPos(mirrorSrcPos(:,jj),wall)];
    end
    pos = [srcPos(:,ii),mirrorSrcPos,mirrorSrcPos2]-micPos;
    [azimuth(:,ii),elevation(:,ii)] = cart2sph(pos(1,:),pos(2,:),pos(3,:));
end

end