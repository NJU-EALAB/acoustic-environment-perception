function data = getLocationFixed(data,ancPos,tagZ)

if nargin == 3
    lb = [-100;-100;tagZ];
    ub = [100;100;tagZ];
else
    lb = [-100;-100;-100];
    ub = [100;100;100];
end
%decide use data or not
a = [];


mask = data.rawData(1);

% mask = 1010;
a(4) = bitget(mask,4);
a(3) = bitget(mask,3);
a(2) = bitget(mask,2);
a(1) = bitget(mask,1);
for i = 1:4
    if a(i) == 0
        error('%d is not working.\n',i);
    end
end

S = data.rawData(2:5); % Distance vector in row
S = (S.').*1e-3;
%get location
fun = @(x)locationFixed(x,ancPos,S);
x0 = locationMoving(ancPos,S);
options = optimoptions('lsqnonlin','Display','off');
x_2 = lsqnonlin(fun,x0,lb,ub,options);


data.error = norm(locationFixed(x_2,ancPos,S));
data.locationFixed = x_2;


end