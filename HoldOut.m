function [TrainData,TestData,TargetTrain,TargetTest]=HoldOut(Features_new,Target,pr)
%% Shuffle
IndRand=randperm(numel(Target));
Features_new=Features_new(IndRand,:);
Target=Target(IndRand);
%% Train Test
TrainPercent=pr;
IndexTrain=1:round(TrainPercent*numel(Target));
IndexTest=round(TrainPercent*numel(Target))+1:numel(Target);
TargetTrain=Target(IndexTrain);
TrainData=Features_new(IndexTrain,:);
TargetTest=Target(IndexTest);
TestData=Features_new(IndexTest,:);

end