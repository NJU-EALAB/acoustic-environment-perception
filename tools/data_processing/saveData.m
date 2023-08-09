savestr = ['./data/SFR-',date];
if exist([savestr,'.mat'],'file')
    saveidx = 2;
    while true
        if exist([savestr,'_',num2str(saveidx),'.mat'],'file')
            saveidx = saveidx+1;
        else
            save([savestr,'_',num2str(saveidx),'.mat']);
            disp(['Save: ',savestr,'_',num2str(saveidx),'.mat']);
            break;
        end
    end
else
    save([savestr,'.mat']);
    disp(['Save: ',savestr,'.mat']);
end