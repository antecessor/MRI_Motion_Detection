% add subfolders to the path 

retroMoCoPath = which('addRetroMoCoBoxToPath.m');
[retroMoCoPath, ~] = fileparts(retroMoCoPath);

addpath(retroMoCoPath);
addpath([retroMoCoPath '/export_fig']);
addpath([retroMoCoPath '/fatnavtools']);
addpath([retroMoCoPath '/generaltools']);
addpath([retroMoCoPath '/images']);
addpath([retroMoCoPath '/niftitools']);
if exist([retroMoCoPath '/mapVBVD_20160905'],'dir')
    addpath([retroMoCoPath '/mapVBVD_20160905']);
end