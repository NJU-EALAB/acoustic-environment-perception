function vct = getMesh(x,y,z)
% Cartesian grid in 2-D/3-D space. Output vct is 2/3*N matrix based on the
% coordinates contained in vectors x y z.
if nargin == 2
    [X,Y] = meshgrid(x,y);
    vct = [X(:),Y(:)].';
elseif nargin == 3
    [X,Y,Z] = meshgrid(x,y,z);
	vct = [X(:),Y(:),Z(:)].';
else
    error('nargin')
end