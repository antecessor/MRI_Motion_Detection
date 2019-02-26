function [Out,err,cvMean,cvStd,Mdl,Res]=KfoldClass(k,Features_new,Target,fun)

Mdl={};

CVO = cvpartition(Target,'k',k);
err = zeros(CVO.NumTestSets,1);
Out=zeros(size(Target,1),1);

Acc=[]; Pre=[]; Recall=[]; Fscore=[]; Sp=[];

for i = 1:CVO.NumTestSets
    trIdx = CVO.training(i);
    teIdx = CVO.test(i);
    Mdl{i}=fun(Features_new(trIdx,:),Target(trIdx));
%     MdlTree{i} = fitrtree(Features_new(trIdx,:),Target(trIdx));
    ytrain = predict(Mdl{i},Features_new(trIdx,:));
    ytest = predict(Mdl{i},Features_new(teIdx,:));
    Out(teIdx)=ytest;
   [Res(i).Accuracy,Res(i).Precison,Res(i).Recall,Res(i).FSCORE,Res(i).Specificity,Res(i).train,Res(i).test]=multiclassparam(Target(trIdx),Target(teIdx),ytrain,ytest);
    Acc=[Acc Res(i).Accuracy.test];
    Pre=[Pre  Res(i).Precison.test];
    Recall=[Recall Res(i).Recall.test];
    Fscore=[Fscore Res(i).FSCORE.test];
    Sp=[Sp Res(i).Specificity.test];
    
    err(i) = Res(i).Accuracy.test;
end

cvMean.Accuracy=mean(Acc);
cvMean.Precision=mean(Pre);
cvMean.Recall=mean(Recall);
cvMean.Sp=mean(Sp);
cvMean.Fscore=mean(Fscore);

cvStd.Accuracy=std(Acc);
cvStd.Precision=std(Pre);
cvStd.Recall=std(Recall);
cvStd.Sp=std(Sp);
cvStd.Fscore=std(Fscore);



end