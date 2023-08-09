function [  ] = peek_IRD_cell_trim( IRD , oct_sm, n_trim, pre_delay, mic_sen_mkp)
% Take a peek of IR and its freq response

if nargin < 5
    mic_sen_mkp = 0;

    if nargin < 4
        pre_delay = 16;

        if nargin < 3
            n_trim = 8192;
            
            if nargin < 2
                oct_sm = 3;
            end
     
        end
    end
end
        


for i=1:size(IRD.IR,1)
    for j=1:size(IRD.IR,2)
        idx = (i-1)*size(IRD.IR,2)+j;
        IR_original(:,idx) = IRD.IR{i,j};
        IR(:,idx) = ir_trim ( IRD.IR{i,j}, n_trim, pre_delay); 
        [ mag_dB(:,idx), f_lin ] = ir2mag_dB(IR(:,idx), IRD.fs, n_trim);
        mag_dB_sm(:,idx) = smoothSpectrum(mag_dB(:,idx),f_lin',oct_sm);
        mag_dB_sm(:,idx) = mag_dB_sm(:,idx)+mic_sen_mkp;
    end
end
figure;
subplot(3,1,1);
plot(IR_original);
subplot(3,1,2);
plot(IR);
subplot(3,1,3);
semilogx(f_lin,mag_dB_sm);xlim([20 20000]);

end

