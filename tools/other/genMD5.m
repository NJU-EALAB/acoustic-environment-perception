function MD5 = genMD5(varargin)
% generates an MD5 hash for input arguments using jsonencode.
intext = jsonencode(varargin);
MD5 = mlreportgen.utils.hash(intext);
end
