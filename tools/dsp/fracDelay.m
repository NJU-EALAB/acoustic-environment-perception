function [h, delayE, delayP] = fracDelay(delay, N)
% h fractional filter coefficents
% delayE design group delay of h        %if N==2 delayE depend on delay2
% delayP delay before h
% delay  % Fractional delay [samples].
% N   % Filter order. recommend odd number

% to be done: add fs
N = N+1;% filter length
delay0 = delay;
delay1 = round(delay0);
delay2 = delay0-delay1;
delay2 = delay2(:);
n = 0:N-1;
if N==1
    h = 1+0*delay2;
    delayE = 0;
elseif N==2
    if delay2>0
        h = [1-delay2, delay2];
        delayE = delay2;
    else
        h = [-delay2, 1+delay2];
        delayE = 1+delay2;
    end
else
    if mod(N,2)<0.1
        h = sinc(n - N / 2 + 1 - delay2);
        delayE = delay2+N/2-1;
    else
        h = sinc(n - (N - 1) / 2 - delay2);
        delayE = delay2+(N-1)/2;
    end
    win = blackman(N+2)';
    win = win(2:end-1);
    h = h.*win;% Multiply sinc filter by window
end
% Normalize to get unity gain.
h = h./sum(h,2);
delayP = round(delay-delayE);
delayP = delayP-min(delayP);
% fvtool(h(1,:),'analysis','grpdelay');
% ylim([delayE-1 delayE+1])
end