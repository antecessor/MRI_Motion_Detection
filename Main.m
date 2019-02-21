clc
clear
run('addToolbox.m') 
%% Load Data
I_person=LoadData_Slices();
%% Add motion artifact
image_simMotion=addMotionArtifactToMRI(I_person{2});
