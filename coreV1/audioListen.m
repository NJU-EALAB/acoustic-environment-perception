ii = 3;
y1 = filter(binaural{ii}(:,1),1,data(1:10*fs,1));
y2 = filter(binaural{ii}(:,2),1,data(1:10*fs,1));
y = [y1,y2];
audiowrite('a3.wav',y./max(abs(y))./2,fs,'BitsPerSample',24);


