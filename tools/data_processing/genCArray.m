data = fir.';
%%
[M,N] = size(data);
str1 = num2str(data,'%e,');
str2 = [repmat('{',[M,1]),str1(:,1:end-1),repmat('}',[M,1])];
if M==1
    str = [str2,'\n'];
else
    str3 = [repmat(', ',[M,1]),str2,repmat('\n',[M,1])];
    str = reshape(str3',[],1)';
    str = [str(3:end-2),'\n'];
end

fprintf(str);