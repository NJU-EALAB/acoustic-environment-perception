function [azimuth,elevation] = getSoundAzel(wallPos, srcPos, micPos)
% wallPos (3,M)
% srcPos (3,N)
% micPos (3,1)
azimuth = zeros(size(wallPos,2)+1,size(srcPos,2));
elevation = zeros(size(wallPos,2)+1,size(srcPos,2));
wall.x = wallPos;
wall.n = wall.x./vecnorm(wall.x);
for ii = 1:size(srcPos,2)
    mirrorSrcPos = getMirrorSrcPos(srcPos(:,ii),wall);
    pos = [srcPos(:,ii),mirrorSrcPos]-micPos;
    [azimuth(:,ii),elevation(:,ii)] = cart2sph(pos(1,:),pos(2,:),pos(3,:));
end

end