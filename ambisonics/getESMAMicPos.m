function [azel,radius,sphType,maxOrder] = getESMAMicPos(rotationNum,maxOrder,clockwiseFlag)
if nargin<3
    clockwiseFlag = 1;
end
if clockwiseFlag
    dAzi = -360/rotationNum;
else
    dAzi = 360/rotationNum;
end
[radius,azimu,eleva] = EMA16unit;
azimu = azimu(:)+(0:dAzi:dAzi*(rotationNum-1));
azimu = mod(azimu(:),360);
eleva = repmat(eleva(:),rotationNum,1);
azel = [azimu,eleva]./180.*pi;
sphType = 'rigid';
if nargin < 2
    maxOrder = floor(sqrt(length(eleva))-1);
end
end

%%
%%
function [radiu,azimu,eleva] = EMA16unit
% radius
radiu = 0.1;% 628.9/2/pi, unit: m

% location of mic on the circle
% 4	40	76	112	148	184	220	309	345	381	417	453	489	525	561	597
% location of hole on the circle
% 255.5

% location of mic on the circle in order
x = [220e-3, 184e-3, 148e-3, 112e-3, 76e-3, 40e-3, 4e-3, 597e-3, 561e-3, 525e-3, 489e-3, 453e-3, 417e-3, 381e-3, 345e-3, 309e-3];
% assuming the hole is pointing to the 0 degree
% degree of the first point
rad_1 = (255.5e-3 - 220e-3) / radiu;
rad_inter = 36e-3 / radiu;
rad_all = rad_1 : rad_inter : rad_1 + rad_inter * 15;
deg_all = rad_all * 180 / pi;
deg_all(9:16) = 360 - deg_all(9:16);
deg_all = deg_all - 90;

% radiu = 0.1 * ones(1, 16); % radius in m of mic
azimu = [zeros(1,8), 180 * ones(1,8)]; % azimuth in degree of mic
eleva = deg_all; % elevation in degree of mic
end