function [ TF, f_lin ] = irir2tf(ir1, ir2, fs, nfft)

[ mag_lin1 , f_lin ] = ir2rtf( ir1, fs, nfft);
[ mag_lin2 , ~ ] = ir2rtf( ir2, fs, nfft);

TF = mag_lin1 - mag_lin2;

end
