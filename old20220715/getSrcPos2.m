function [srcPos,micPos] = getSrcPos2(doa, pos, srcPos0)
if nargin == 2% [srcPos,micPos] = getSrcPos2(IRPath,chIdx);
    IRPath = doa;
    chIdx = pos;
    doa = zeros(3,0);
    pos = zeros(3,0);
    
    Ac = getAcPara(25);
    c = Ac.c;
    
    srcPos0 = [0 2 2].';
    
    load(IRPath);
    micPos = zeros(3,0);
    for ii = 1:numel(Data)
        micPos0 = Data{ii}.micPos(:,chIdx);
        micPos = [micPos,micPos0];
        fs = Data{ii}.fs;
        IR = cell2mat(Data{ii}.IR(chIdx,:).');
        [doa(:,ii), pos(:,ii)] = getDOA(micPos0, IR, fs, c);
    end
end
[srcPos] = getSrcPos2_(doa, pos, srcPos0);
end

%%
%%
function [srcPos] = getSrcPos2_(doa, pos, srcPos0)
% INPUT
% doa: [3,1]
% pos: mean mic pos[3,1]
% srcPos0: init srcPos[3,1]
% OUTPUT
% srcPos: source position [3,1]
if nargin<5
    srcPos0 = zeros(size(pos,1),1);
end
err = @(srcPos)errAngle(srcPos, doa, pos);
options = optimoptions('lsqnonlin','FiniteDifferenceType','central','FunctionTolerance',1e-14,'OptimalityTolerance',1e-10,'Display','off');
srcPos = lsqnonlin(err,srcPos0,[],[],options);
end

%%
%%
function err = errAngle(srcPos, doa, pos)
assert(all([3,1]==size(srcPos)));
posVec = srcPos-pos;
posVec = posVec./vecnorm(posVec);
doa = doa./vecnorm(doa);
err = acos(sum(posVec.*doa,1).');
end