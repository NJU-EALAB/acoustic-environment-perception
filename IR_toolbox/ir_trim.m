function [ IR_trim , peak_idx ] = ir_trim( IR, n_trim, pre_delay)
%Compute Phase Freq Response in dB @linear freq index  

% Change Log:
% 2020-03-02    First Ed. by Liu Ziyun

[~, peak_idx] = max( abs(IR) );

if (peak_idx-1 + n_trim-pre_delay) > length(IR)
    IR_trim = [IR(peak_idx-pre_delay+1:end);IR(1:(peak_idx + n_trim-pre_delay)-length(IR))];
elseif peak_idx-pre_delay<1
    IR_trim = [IR(length(IR)+peak_idx-pre_delay : end); IR( 1 : peak_idx-1 + n_trim-pre_delay)];
else
    IR_trim = IR( peak_idx-pre_delay : peak_idx-1 + n_trim-pre_delay);
end

end
