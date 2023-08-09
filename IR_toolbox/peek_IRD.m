function [  ] = peek_IRD( IRD , oct_sm)
% Take a peek of IR and its freq response

for i=1:size(IRD.IR,2)
    [ mag_dB(:,i), f_lin ] = ir2mag_dB(IRD.IR(:,i), IRD.fs, IRD.length);
    mag_dB_sm(:,i) = smoothSpectrum(mag_dB(:,i),f_lin',oct_sm);
end
figure;
subplot(2,1,1);
plot(IRD.IR);
subplot(2,1,2);
semilogx(f_lin,mag_dB_sm);xlim([20 20000]);

end

