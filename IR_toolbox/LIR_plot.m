function [r, f_lin, Mag_dB_L, Mag_dB_R] = LIR_plot(Data)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

k=0;
for i=1:size(Data,1)
    for j=1:size(Data{1,1}.IR,1)
        k = k+1;
        LIR_L(:,k) = Data{i}.IR{j,1} ;
        LIR_R(:,k) = Data{i}.IR{j,2} ;
    end    
end 

% [Mag_dB_L, f_lin] = LIR_rms_Avg(LIR_L,3);
% [Mag_dB_R, ~    ] = LIR_rms_Avg(LIR_R,3);
 
[Mag_dB_L, f_lin] = LIR_dB_Avg(LIR_L,3);
[Mag_dB_R, ~    ] = LIR_dB_Avg(LIR_R,3); 

% figure; 
% semilogx(f_lin,[Mag_dB_L Mag_dB_R]);xlim([200 7000]);
  
mag_inRange_L = Mag_dB_L(find(f_lin>200,1,'first'):find(f_lin<7000,1,'last'));
mag_inRange_R = Mag_dB_R(find(f_lin>200,1,'first'):find(f_lin<7000,1,'last'));

Mean =mean([mag_inRange_L;mag_inRange_R]);
Up = max([mag_inRange_L;mag_inRange_R]) - Mean;
Down = min([mag_inRange_L;mag_inRange_R]) - Mean;

% ylim([Mean-4.5 Mean+4.5]);
% line([200 7000],[Mean-3 Mean-3]);
% line([200 7000],[Mean+3 Mean+3]);

r = [Mean Up Down];

end

