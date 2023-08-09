function y = pageFunc(fun,varargin)
L = size(varargin{1},3);
for ii = 2:numel(varargin)
    if 1 == size(varargin{ii},3)
        varargin{ii} = repmat(varargin{ii},1,1,L);
    end
    assert(L == size(varargin{ii},3));
end

cellOut = getDim3(varargin,1);
y0 = fun(cellOut{:});
y = zeros(size(y0,1),size(y0,2),L);
y(:,:,1) = y0;
for ii = 2:L
    cellOut = getDim3(varargin,ii);
    y(:,:,ii) = fun(cellOut{:});
end
end

function cellOut = getDim3(cellIn,dim)
cellOut = cell(numel(cellIn),1);
for ii = 1:numel(cellIn)
    cellOut{ii} = cellIn{ii}(:,:,dim);
end
end