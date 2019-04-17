clc
clear
run('addToolbox.m') 
% %% Load Data
I_person=LoadData_Slices();
%% Add motion artifact
%% ToDo : See what is the problem with light?
noiseBasePars ={1.^[0:8],2.*[0:8],3.*[0:8],4.*[0:8]}; %% minimal,mild,moderate,severe motion
maxDisp=[0.91, 1.48, 1.55, 1.85];
maxRot=[ 0.28, 0.54, 1.53, 1.80];
show=1;
Normalize=@(I) (I-min(I(:)))/(max(I(:))-min(I(:)));
for i=1:numel(I_person)
    for m=1:4
        [image_simMotion{i,m},fitpars{i,m}]=addMotionArtifactToMRI(I_person{i},noiseBasePars{m},maxDisp(m),maxRot(m),show);           
        for j=1:size(image_simMotion{i,m},3)
            image_simMotion{i,m}(:,:,j)=uint8(255*Normalize(abs(image_simMotion{i,m}(:,:,j))));
        end
    end
    disp(['Person number ' num2str(i) ' is done...'])
end
%% load images that are saved
load('simulatedImages.mat')
%% showing add motion artifact
% m=1;
% addMotionArtifactToMRI(I_person{3},noiseBasePars{m},maxDisp(m),maxRot(m),1);
% imshowDifferentMotion(I_person,image_simMotion,1,40)
%% non:0 slight:1 mild:2 moderate:3 severe:4 
%% Machine Learning
Strategy1_FeatureSelectionMachineLearning
%% Deep learning
% Strategy2_DeepLearning
%% Fuzzy
% Strategy3_FuzzyAnfisDeepLearning
% Strategy3_FuzzyAnfisGA