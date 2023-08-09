function out = frameProcessor(matlabSys0,in,frameLen,stepLen,catDim)
if ~iscell(matlabSys0)
    matlabSys = {matlabSys0};
end
for jj = 1:numel(matlabSys)
    matlabSys{jj}.reset;
end
if nargin < 4
    stepLen = frameLen;
end
if nargin < 5
    catDim = 1;
end

ii = 0;
while true
    ii = ii+1;
    idx = (ii-1)*stepLen+1:min( (ii-1)*stepLen+frameLen , size(in,1) );
    buffer = in(idx,:);
    for jj = 1:numel(matlabSys)
        buffer = matlabSys{jj}(buffer);
    end
    if ii == 1
        out = buffer;
    else
        out = cat(catDim,out,buffer);
    end
    if idx(end) == size(in,1)
        break;
    end
end

end