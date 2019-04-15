function fis=DisplacementRotationByFuzzyGAMapping(Data,TargetDisp,TargetRot,TargetFinal,TrainPercent)

%% Shuffle and Hold out
[Datanew,TargetDispnew,TargetRotnew,TargetFinalnew]=shuffle3(Data,TargetDisp,TargetRot,TargetFinal);
[TrainData,TestData,TargetTrainDisp,TargetTestDisp]=HoldOut(Datanew,TargetDispnew,TrainPercent);
[~,~,TargetTrainRot,TargetTestRot]=HoldOut(Datanew,TargetRotnew,TrainPercent);
[~,~,TargetTrainFinal,TargetTestFinal]=HoldOut(Datanew,TargetFinalnew,TrainPercent);
%% Displacement
data.TrainInputs=TrainData;
data.TrainTargets=TargetTrainDisp;
data.TestInputs=TestData;
data.TestTargets=TargetTestDisp;
fis1=CreateInitialFIS(data);
fis1=TrainAnfisUsingGA(fis1,data);  
TrainOutputs=evalfis(data.TrainInputs,fis1);
PlotResults(data.TrainTargets,TrainOutputs,'Train Data');
TestOutputs=evalfis(data.TestInputs,fis1);
RMSErrorDisp=sqrt(mean((TestOutputs-TargetTestDisp).^2))
%% Rotation
data.TrainInputs=TrainData;
data.TrainTargets=TargetTrainRot;
data.TestInputs=TestData;
data.TestTargets=TargetTestRot;
fis2=CreateInitialFIS(data);
fis2=TrainAnfisUsingGA(fis2,data);  
TrainOutputs=evalfis(data.TrainInputs,fis2);
PlotResults(data.TrainTargets,TrainOutputs,'Train Data');
TestOutputs=evalfis(data.TestInputs,fis2);
RMSErrorRot=sqrt(mean((TestOutputs-TargetTestRot).^2))

%% Fuzzy Map
opt = genfisOptions('FCMClustering','FISType','mamdani');
opt.NumClusters = 5;
fis = genfis([OutTraintDisp OutTraintRot],TargetTrainFinal,opt);
outtest=round(evalfis(fis,[OutTestDisp OutTestRot]));
[Accuracy,Precison,Recall,FSCORE,Specificity,~,test]=multiclassparam(TargetTestFinal,TargetTestFinal,outtest,outtest);


end