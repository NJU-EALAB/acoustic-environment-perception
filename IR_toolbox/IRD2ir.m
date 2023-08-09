function [ IR ] = IRD2ir( IRD )

for i=1:size(IRD.IR,1)
    for j=1:size(IRD.IR,2)
        idx = (i-1)*size(IRD.IR,2)+j;
        IR(:,idx) = IRD.IR{i,j}; 

    end
end

end

