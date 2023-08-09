function sndHedgehog = IRIS_ita(itaSHReal,conf)
if isfield(conf,'fs')
    assert(itaSHReal.samplingRate==conf.fs);
end
conf.fs = itaSHReal.samplingRate;
SHReal = itaSHReal.time;
wxyz = SHReal(:,[1 4 2 3]);%WYZX -> WXYZ
sndHedgehog = IRIS_BFormat(wxyz,conf);
end