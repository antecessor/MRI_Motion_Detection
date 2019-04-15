function [TrainData,TargetTrain,TestData,TargetTest]=HoldOutDivision(MainFeature,Target,TrainPercent)

TrainData=[];
TestData=[];
TargetTrain=[];
TargetTest=[];
for i=1:numel(unique(Target))   
    T=find(Target==i);
    NumberTrainPercent=round(numel(T)*TrainPercent);
    TrainData=[TrainData; MainFeature(T(1:NumberTrainPercent),:)];
    TargetTrain=[TargetTrain;Target(T(1:NumberTrainPercent))];
    TestData=[TestData;MainFeature(T(NumberTrainPercent+1:end),:)];
    TargetTest=[TargetTest;Target(T(NumberTrainPercent+1:end))];
end
end