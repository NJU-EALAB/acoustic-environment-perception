clear all
close all
%%
micParams = MicArrayPresets('esma',3, 5);
fs = 48000;
frameSize = 10240;

array2sh = vst.array2sh(micParams,fs,frameSize);

%%
in = ir(1:frameSize,:);
in = [in, repmat(in(:,end),1,64-size(in,2))];
sh_vst = process(array2sh,in);

figure;
plot(sh_vst(:,1:4))