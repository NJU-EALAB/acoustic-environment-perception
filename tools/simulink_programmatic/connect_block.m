function lineHandle = connect_block(sys,outBlk,inBlk,outPortNum,inPortNum)
if nargin<5
    inPortNum = 1;
end
if nargin<4
    outPortNum = 1;
end
h1 = get_param(outBlk,'PortHandles');
h2 = get_param(inBlk,'PortHandles');
lineHandle = add_line(sys,h1.Outport(outPortNum),h2.Inport(inPortNum),'autorouting','smart');
end

