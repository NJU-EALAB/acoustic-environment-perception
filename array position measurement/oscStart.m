% system('python ./oscServerPosMsg.py &');
if isempty(gcp('nocreate'))
    parpool(1);
end
p = gcp;
f = parfeval(p,@pyrunfile,0,'oscServerPosMsg.py');
t = timer('StartDelay',10,'TimerFcn',@(~,~)assert(isempty(f.Error),f.Error.message));
start(t)

% cancelAll(gcp().FevalQueue);
% delete(gcp('nocreate'))