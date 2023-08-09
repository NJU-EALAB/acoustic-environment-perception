function [bin_out, bin_out_mat]=sh2bin_ita(shReal, fs, hrir)
% Adapted according to ita_hoa_binaural_test.
% function bin_out=ita_hoa_binaural_test(pos,directPlay)
% Encodes and decodes a virtual sound source position to the desired position
% and decodes it using the vrlab setup. Afterwards it is mix down to a
% binaural audio object. pos has to be a 1x3 array. play indicates whether
% a direct playback is desired.

% Coresponding: MKO@akustik.rwth-aachen.de

bformat = itaAudio;
% Set sampling rate
bformat.samplingRate = fs;
% Let's set the time data, you could use your own MATLAB data here !
bformat.time = shReal;

% bformat=ita_hoa_encode(vs_signal,2);
% Need to be confirmed: ita_hoa_encode seems to be N3D, while ita_hoa_decode seems to be SN3D.
% Note: ita_hoa_decode does not appear to have a radial filter.
ls_signals=ita_hoa_decode(bformat,ita_setup_LS_VRLab('virtualSpeaker',true),'vrlab',true);
bin_out=ita_binauralMixdown(ls_signals,'LSPos',ita_setup_LS_VRLab,'HRTF',hrir);

% bar(ls_signals.rms);
bin_out_mat = bin_out.time;
end

