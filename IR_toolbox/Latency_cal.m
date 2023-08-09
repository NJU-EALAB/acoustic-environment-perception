function RIR = Latency_cal(RIR_rec,RIR_ref)
% Calculate the measurement system latency

% Change Log
% 2017-03-06    First Ed. by Shen Yuchen

Max_test = max(RIR_ref)/2;
Cue = find(RIR_ref > Max_test);
Cue = Cue(1)-1;
% RIR = RIR_rec(1:end/2);
RIR = RIR_rec((Cue+1):end);

end