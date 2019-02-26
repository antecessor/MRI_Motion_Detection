function [Accuracy,Precison,Recall,FSCORE,Specificity,train,test]=multiclassparam(train_gold,test_gold,train_result,test_result)
%% 1 means hast 2 means nist!!!
siz=max(test_gold);
test_gold1=conv2vec(test_gold,siz);
train_gold1=conv2vec(train_gold,siz);
train_result1=conv2vec(train_result,siz);
test_result1=conv2vec(test_result,siz);

for i=1:siz
[train(i),test(i)]=calculate_info_theory(train_gold1(:,i)-1,test_gold1(:,i)-1,train_result1(:,i)-1,test_result1(:,i)-1); % 0 and 1s
end

[Accuracy.test,Precison.test,Recall.test,FSCORE.test,Specificity.test] =calcmulti(test,siz);
[Accuracy.train,Precison.train,Recall.train,FSCORE.train,Specificity.train] =calcmulti(train,siz);
end