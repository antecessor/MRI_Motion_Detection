clc
clear
run('addToolbox.m') 
% %% Load Data
[I,Target]=LoadData_Real();
%% showing add motion artifact
% m=1;
% addMotionArtifactToMRI(I_person{3},noiseBasePars{m},maxDisp(m),maxRot(m),1);
% imshowDifferentMotion(I_person,image_simMotion,1,40)
%% non:0 slight:1 mild:2 moderate:3 severe:4 
%% Machine Learning
% Strategy1_FeatureSelectionMachineLearning
%% Deep learning
% Strategy2_DeepLearning
%% Fuzzy
% Strategy3_FuzzyAnfisDeepLearning
Strategy3_FuzzyAnfisGA