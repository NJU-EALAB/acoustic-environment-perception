function data = getLocationMoving(data,ancPos)
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

%get location
S = data.rawData(2:5); % Distance vector in row
S = (S.').*1e-3;
[N1, N2] = locationMoving(ancPos,S);

data.locationMoving = N1;
    


end