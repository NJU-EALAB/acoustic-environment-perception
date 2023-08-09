function y = pageFunc123(fun,varargin)
if numel(varargin)==1
    y = pageFunc1(fun,varargin{:});
elseif numel(varargin)==2
    y = pageFunc2(fun,varargin{:});
elseif numel(varargin)==3
    y = pageFunc3(fun,varargin{:});
else
    error('Not support such nargin.');
end
end

function y = pageFunc1(fun,x1)
L = size(x1,3);
y0 = fun(x1(:,:,1));
y = zeros(size(y0,1),size(y0,2),L);
y(:,:,1) = y0;
for ii = 2:L
    y(:,:,ii) = fun(x1(:,:,ii));
end
end

function y = pageFunc2(fun,x1,x2)
L = size(x1,3);
assert(L == size(x2,3));
y0 = fun(x1(:,:,1),x2(:,:,1));
y = zeros(size(y0,1),size(y0,2),L);
y(:,:,1) = y0;
for ii = 2:L
    y(:,:,ii) = fun(x1(:,:,ii),x2(:,:,ii));
end
end

function y = pageFunc3(fun,x1,x2,x3)
L = size(x1,3);
assert(L == size(x2,3));
assert(L == size(x3,3));
y0 = fun(x1(:,:,1),x2(:,:,1),x3(:,:,1));
y = zeros(size(y0,1),size(y0,2),L);
y(:,:,1) = y0;
for ii = 2:L
    y(:,:,ii) = fun(x1(:,:,ii),x2(:,:,ii),x3(:,:,ii));
end
end
