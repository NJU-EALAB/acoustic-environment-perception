function [angle_rad, angle_deg] = getIncludedAngle(x1,x2)
% different row denotes different dim
angle_rad = acos(sum(x1.*x2,1)./vecnorm(x1,2,1)./vecnorm(x2,2,1));
angle_deg = angle_rad./pi.*180;
end