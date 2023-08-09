function b = getFilter(x,y)
x = x(:);
y = y(:);
% b = zeros(length(y),1);
% options = optimoptions('lsqnonlin','MaxIterations',1e3,'StepTolerance',1e-10,'FunctionTolerance',1e-14,'OptimalityTolerance',1e-10,'MaxFunctionEvaluations',1e6,'Display','iter','UseParallel',false);
% err = @(b)filter(x,1,b)-y;
% tic
% b = lsqnonlin(err,b,[],[],options);
% toc
x = [x(:);zeros(length(y)-numel(x),1)];

l = length(y);
l = 5000;

lms = dsp.LMSFilter('Length',l);
[y0,err,wts] = lms(1e4*x(1:10000),1e4*y(3e4:4e4-1));

end