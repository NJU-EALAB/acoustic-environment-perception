function ir = fr2ir(frFunc,filterOrder,freqSampN,window)
%Compute IR using frequency resp.
% @(f)frFunc(f) is a function handle containing the desired complex response at each of the points specified in f.
% f = 1 -> realFreq = fs/2
% filterOrder is length(ir)-1
% freqSampN is length of frequency sample
% window is {the name of window for IR, the location type of the center of the window}
arguments
    frFunc
    filterOrder
    freqSampN = max(filterOrder,1024)+1;
    window = {'hamming','middle'};
end
%% get freq resp
f = linspace(0,2,freqSampN+1).';
f = f(1:ceil(end/2));
fr = frFunc(f);
fr = fr(:);
fr(1) = 0;
if mod(freqSampN,2)% odd N
    fr = [fr; conj(flip(fr(2:end)))];
else% even N
    fr(end) = 0;
    fr = [fr; conj(flip(fr(2:end-1)))];
end
assert(length(fr)==freqSampN);
%% get ir using ifft
ir = ifftshift(ifft(fr));
%% add window
if strcmpi(window{1},'hamming')
    wind = hamming(filterOrder+1);
elseif strcmpi(window{1},'rect')
    wind = rectwin(filterOrder+1);
else
    error('No such window{1}.');
end

ir = [zeros(filterOrder+1,1);ir;zeros(filterOrder+1,1)];
if strcmpi(window{2},'middle')
    irIdx = floor(length(ir)/2);
elseif strcmpi(window{2},'max')
    [~,irIdx] = max(abs(ir));
else
    error('No such window{2}.');
end

ir = wind.*ir(irIdx-floor(filterOrder/2):irIdx+ceil(filterOrder/2));

assert(all(size(ir,[1 2])==[filterOrder+1,1]));

end
