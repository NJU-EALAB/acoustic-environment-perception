function [posData, tagName] = posDataDecode(posData, udpPort)
configureTerminator(udpPort,"CR/LF");
data = jsondecode(readline(udpPort));
% {tagName, mask, range1 [mm], range2 [mm], range3 [mm], range4 [mm],yaw [deg]}
% data =    {'t1'}    {15}    {[1776]}    {[1426]}    {[837]}    {[233]}    {[45]}
tagName = data{1};
posData.(tagName).rawData = cell2mat(data(2:end));
end