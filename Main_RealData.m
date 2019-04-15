clc
clear
run('addToolbox.m') 
% %% Load Data
[I,Target]=LoadData_Real();
%% non:0 slight:1 mild:2 moderate:3 severe:4 
%% Machine Learning
Strategy1_FeatureSelectionMachineLearning_RealData
%% Deep learning
Strategy2_DeepLearning
%% Fuzzy
% Strategy3_FuzzyAnfisDeepLearning
% Strategy3_FuzzyAnfisGA