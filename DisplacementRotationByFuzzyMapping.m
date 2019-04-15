function fis=DisplacementRotationByFuzzyMapping(Data,TargetDisp,TargetRot,TargetFinal,TrainPercent)

%% Shuffle and Hold out
[Datanew,TargetDispnew,TargetRotnew,TargetFinalnew]=shuffle3(Data,TargetDisp,TargetRot,TargetFinal);
[TrainData,TestData,TargetTrainDisp,TargetTestDisp]=HoldOut(Datanew,TargetDispnew,TrainPercent);
[~,~,TargetTrainRot,TargetTestRot]=HoldOut(Datanew,TargetRotnew,TrainPercent);
[~,~,TargetTrainFinal,TargetTestFinal]=HoldOut(Datanew,TargetFinalnew,TrainPercent);
%% Displacement
mdlTreeDisp=FuzzyAnfisDeepLearning(TrainData,TargetTrainDisp);
OutTraintDisp=evalfis(mdlTreeDisp,TrainData);
OutTestDisp=evalfis(mdlTreeDisp,TestData);
RMSErrorDisp=sqrt(mean((OutTestDisp-TargetTestDisp).^2))
%% Rotation
mdlTreeRot=FuzzyAnfisDeepLearning(TrainData,TargetTrainRot);
OutTraintRot=evalfis(mdlTreeRot,TrainData);
OutTestRot=evalfis(mdlTreeRot,TestData);
RMSErrorRot=sqrt(mean((OutTestRot-TargetTestRot).^2))

%% Fuzzy Map
opt = genfisOptions('FCMClustering','FISType','mamdani');
opt.NumClusters = 5;
fis = genfis([OutTraintDisp OutTraintRot],TargetTrainFinal,opt);
outtest=round(evalfis(fis,[OutTestDisp OutTestRot]));
[Accuracy,Precison,Recall,FSCORE,Specificity,~,test]=multiclassparam(TargetTestFinal,TargetTestFinal,outtest,outtest);


end