clear all
conf.maxDelay = 1e4;
%%
modelName = 'test';
srcNum = 25;
spkNum = 16;

new_system(modelName,'Subsystem')
sys = load_system(modelName);
open_system(modelName);
%%
in = add_block('simulink/Sources/In1',[modelName,'/In'],'MakeNameUnique','on');
out = add_block('simulink/Sinks/Out1',[modelName,'/Out'],'MakeNameUnique','on');

lineHandle = connect_block(modelName,in,out);
%%
Simulink.BlockDiagram.arrangeSystem(modelName);
lineHandles = find_system(gcs,'FindAll','On','SearchDepth',1,'Type','Line');
Simulink.BlockDiagram.routeLine(lineHandles);
save_system(modelName);