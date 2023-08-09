function mirrorSrcPos = getMirrorSrcPos(srcPos,wall)
assert(all([3,1]==size(srcPos,[1:2])));
assert(all(size(wall.x,1:2)==size(wall.n,1:2)));
lenX = size(wall.x,2);
mirrorSrcPos = zeros(3,lenX);
    for ii = 1:lenX
        n = wall.n(:,ii);
        x = wall.x(:,ii);
        n = n./norm(n);
        d = srcPos-x;
        d1 = d-2*n.'*d*n;
        mirrorSrcPos(:,ii) = d1+x;
    end
