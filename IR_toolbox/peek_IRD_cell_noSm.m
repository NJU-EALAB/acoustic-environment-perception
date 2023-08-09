function [  ] = peek_IRD_cell( IRD , oct_sm, mic_sen_mkp)
% Take a peek of IR and its freq response

if nargin < 3
    mic_sen_mkp = 0;
end

for i=1:size(IRD.IR,1)
    for j=1:size(IRD.IR,2)
        idx = (i-1)*size(IRD.IR,2)+j;
        IR(:,idx) = IRD.IR{i,j}; 
        [ mag_dB(:,idx), f_lin ] = ir2mag_dB(IR(:,idx), IRD.fs, IRD.length);
        mag_dB_sm(:,idx) = mag_dB(:,idx);
        mag_dB_sm(:,idx) = mag_dB_sm(:,idx)+mic_sen_mkp;
    end
end
figure;
subplot(2,1,1);
plot(IR);
subplot(2,1,2);
semilogx(f_lin,mag_dB_sm);xlim([20 20000]);

end

