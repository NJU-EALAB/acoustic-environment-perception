clc
clear all
close all
format short

l = 1.09;
x = l*(sqrt(2)/2 + 1/2);
y = l*(sqrt(2)/2 + 1/2);

pos(1,:) = [x,0];
pos(2,:) = [x,-l/2];
pos(3,:) = [x - (sqrt(2)/4)*l,-y + (sqrt(2)/4)*l];
pos(4,:) = [l/2,-y];
pos(5,:) = [0,-y];
pos(6,:) = [-l/2,-y];
pos(7,:) = [-x + (sqrt(2)/4)*l,-y + (sqrt(2)/4)*l];
pos(8,:) = [-x,-l/2];
pos(9,:) = [-x,0];
pos(10,:) = [-x,l/2];
pos(11,:) = [-x + (sqrt(2)/4)*l,y - (sqrt(2)/4)*l];
pos(12,:) = [-l/2,y];
pos(13,:) = [0,y];
pos(14,:) = [l/2,y];
pos(15,:) = [x - (sqrt(2)/4)*l,y - (sqrt(2)/4)*l];
pos(16,:) = [x,l/2];
% pos(17,:) = [-1.25,-2.3];
% pos(18,:) = [-1.6,-1.1];
pos2(1,:) = [0,-y,2.4];
pos2(2,:) = [-x + (sqrt(2)/4)*l,-y + (sqrt(2)/4)*l,2.4];
pos2(3,:) = [-x,0,2.4];
pos2(4,:) = [-x + (sqrt(2)/4)*l,y - (sqrt(2)/4)*l,2.4];
pos2(5,:) = [0,y,2.4];
pos2(6,:) = [x - (sqrt(2)/4)*l,y - (sqrt(2)/4)*l,2.4];
pos2(7,:) = [x,0,2.4];
pos2(8,:) = [x - (sqrt(2)/4)*l,-y + (sqrt(2)/4)*l,2.4];
pos2(9,:) = [x/3,-l/2,2.4];
pos2(10,:) = [-x/3,-l/2,2.4];
pos2(11,:) = [-x/3,l/2,2.4];
pos2(12,:) = [x/3,l/2,2.4];

for j = 1:16
    if pos(j,2) >= 0
        ang(j,1) = -atan(pos(j,1)/pos(j,2))/pi*180 - 90;
    else
        ang(j,1) = -atan(pos(j,1)/pos(j,2))/pi*180 + 90;
    end
end

for j = 1:12
    if pos2(j,2) >= 0
        ang2(j,1) = -atan(pos2(j,1)/pos2(j,2))/pi*180 - 90;
    else
        ang2(j,1) = -atan(pos2(j,1)/pos2(j,2))/pi*180 + 90;
    end
end

fprintf('  <reproduction_setup>\n')
for k = 1:16
    fprintf('   <loudspeaker>\n')
    fprintf('      <!-- position is relative to the reference point! -->\n')
    fprintf('      <position x="%f" y="%f"/>\n',pos(k,1),pos(k,2))
    fprintf('      <orientation azimuth="%f"/>\n',ang(k))
    fprintf('    </loudspeaker>\n')
end
fprintf('  </reproduction_setup>\n')
fprintf('up\n')
fprintf('  <reproduction_setup>\n')
for k = 1:12
    fprintf('   <loudspeaker>\n')
    fprintf('      <!-- position is relative to the reference point! -->\n')
    fprintf('      <position x="%f" y="%f"  z="%f"/>\n',pos2(k,1),pos2(k,2),pos2(k,3))
    fprintf('      <orientation azimuth="%f"/>\n',ang2(k))
    fprintf('    </loudspeaker>\n')
end
fprintf('  </reproduction_setup>\n')