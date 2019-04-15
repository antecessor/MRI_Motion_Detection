TargetMain=[];
TargetDispalcementRMS=[];
TargetRotationRMS=[];
%%


%% Feature Selection
%For motion artifact
F=[];
for i=1:size(image_simMotion,1)
    for j=1:size(image_simMotion,2)
        for n=1:size(image_simMotion{i,j},3)
            F=[F ;FeatureExtraction(abs(image_simMotion{i,j}(:,:,n)))];
            TargetMain=[TargetMain; j];
            [RMS_displacement,RMS_rot]=findRMSDisplacementRotation(fitpars{i,j});
            TargetDispalcementRMS=[TargetDispalcementRMS;RMS_displacement];
            TargetRotationRMS=[TargetRotationRMS;RMS_rot];
        end
    end
    disp(['Person number ' num2str(i) ' is done...'])
end
%For original images
for i=1:numel(I_person)
    for n=1:size(I_person{i},3)
        F=[F ;FeatureExtraction(abs(I_person{i}(:,:,n)))];
        TargetMain=[TargetMain; 0];
        TargetDispalcementRMS=[TargetDispalcementRMS ;0];
        TargetRotationRMS=[TargetRotationRMS;0];
    end
    disp(['Person number ' num2str(i) ' is done...'])
end
%%
% % Normalization
Normalize=@(x) (x-min(x))/(max(x)-min(x));
for i=1:size(F,2)
    Fnew(:,i)=Normalize(F(:,i));
end
%%
% fis=DisplacementRotationByFuzzyMapping(Fnew,TargetDispalcementRMS,TargetRotationRMS,TargetMain,.7)
fis=DisplacementRotationByFuzzyGAMapping(Fnew,TargetDispalcementRMS,TargetRotationRMS,TargetMain,.7)
%% Shuffle
[Fnew,Targetnew]=shuffle(F,TargetMain);
%%
[TrainData,TestData,TargetTrain,TargetTest]=HoldOut(Fnew,Targetnew,.7);
% 
fis1=FuzzyAnfisDeepLearning(TrainData,TargetTrain+1);
% 
out=evalfis(fis1,TrainData);
outtest=evalfis(fis1,TestData);
opt = genfisOptions('FCMClustering','FISType','mamdani');
opt.NumClusters = 5;
fis2 = genfis(out,TargetTrain+1,opt);
% 
% PlotResults(TargetTest,evalfis(fis2,evalfis(fis1,TestData)),'Test-Set')
outtest(outtest>5)=5;
Confusionmatrix = confusionmat(TargetTest+1,round(outtest))
[Accuracy,Precison,Recall,FSCORE,Specificity,~,test]=multiclassparam(TargetTest+1,TargetTest+1,round(outtest),round(outtest));
toc
