close all
dir_path = 'D:\GH\Downloads\230303易科自测';
files = read_mat_files(dir_path);
comment = string;
eDir = [];
eRef = [];
eRev = [];
for i = 1:length(files)
    data = load(files{i});
    fs = data.RirData.samplingRate;
    ir = data.RirData.time;
    comment(i,:) = string(data.RirData.comment);
    [eDir(i,:), eRef(i,:), eRev(i,:)] = eDirRefRev(ir,fs);
end
res = table(comment,eDir,eRef,eRev);
disp(res);
%%
%%
% 定义一个函数，输入是当前目录的路径，输出是一个包含所有mat文件名的单元数组
function files = read_mat_files(dir_path)
    % 获取当前目录下的所有文件和文件夹的信息
    dir_info = dir(dir_path);
    % 初始化一个空的单元数组，用来存储mat文件名
    files = {};
    % 遍历所有的文件和文件夹
    for i = 1:length(dir_info)
        % 如果是文件，而且扩展名是.mat
        if ~dir_info(i).isdir && strcmp(dir_info(i).name(end-3:end), '.mat')
            % 将文件名添加到单元数组中
            files{end+1} = fullfile(dir_path, dir_info(i).name);
        end
    end
end