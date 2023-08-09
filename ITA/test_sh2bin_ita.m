vs_signal=ita_demosound;
vs_signal.trackLength=4;
vs_signal.channelCoordinates.cart=[0 1 0];
shReal_ita=ita_hoa_encode(vs_signal,2);
shReal = shReal_ita.time;
fs = shReal_ita.samplingRate;
hrir = 'TU-Berlin_QU_KEMAR_anechoic_radius_0.5m.sofa';

[bin_out,bin_out_mat]=sh2bin_ita(shReal,fs,hrir);

figure;
plot(bin_out_mat);
figure;
bar(bin_out.rms);