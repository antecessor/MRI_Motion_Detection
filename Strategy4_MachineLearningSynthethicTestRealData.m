%% load synthetic Data and learn machine learning
I_person=LoadData_Slices();
noiseBasePars ={.001.^[0:15],.02.*[0:15],.08.*[0:15],.1.*[0:15]}; %% minimal,mild,moderate,severe motion
maxDisp=[.04,.1,.3,0.7];
maxRot=[.04,.1,.3,0.7];
show=0;
image_simMotion=CreateSimulatedImage(I_person,noiseBasePars,maxDisp,maxRot,show);
% load('simulatedImages')
Strategy1_FeatureSelectionMachineLearning
[~,Target]=LoadData_Real(); % for loading Target
%% Feature Extraction
F=[];
for i=1:numel(I)
    F=[F ;FeatureExtraction(I{i})];
    disp(['Image number ' num2str(i) ' is done...'])
end
%% Normalization
Normalize=@(x) (x-min(x))/(max(x)-min(x));
for i=1:size(F,2)
    F(:,i)=Normalize(F(:,i));
end
%% predict
Out=[];
for j=1:size(F,1)
    for i=1:numel(Mdl)
        Out(j,i)=predict(Mdl{i},F(j,:));
    end
end
%%
OutMain=round(mode(Out')');
[Accuracy,Precison,Recall,FSCORE,Specificity,test]=multiclassparam(Target+1,Target+1,OutMain,OutMain);
Confusionmatrix = confusionmat(Target+1,OutMain)