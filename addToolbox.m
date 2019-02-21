% add subfolders to the path 

toolbox = which('addToolbox.m');
[toolbox, ~] = fileparts(toolbox);

addpath(toolbox);
addpath([toolbox '/export_fig']);
addpath([toolbox '/fatnavtools']);
addpath([toolbox '/generaltools']);
addpath([toolbox '/niftitools']);
run('./irt/setup.m')
