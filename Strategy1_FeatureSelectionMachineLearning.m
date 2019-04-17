%% non:0 slight:1 mild:2 moderate:3 severe:4
Target=[];
%% Feature Selection
% For motion artifact
F=[];
for i=1:size(image_simMotion,1)
    for j=1:size(image_simMotion,2)
        for n=1:size(image_simMotion{i,j},3)
            F=[F ;FeatureExtraction(abs(image_simMotion{i,j}(:,:,n)))];
            Target=[Target; j];
        end
    end
    disp(['Person number ' num2str(i) ' is done...'])
end
% For original images
for i=1:numel(I_person)
    for n=1:size(I_person{i},3)
        F=[F ;FeatureExtraction(abs(I_person{i}(:,:,n)))];
        Target=[Target; 0];
    end
    disp(['Person number ' num2str(i) ' is done...'])
end
%% Shuffle
[Fnew,Targetnew]=shuffle(F,Target);
%% Normalization
Normalize=@(x) (x-min(x))/(max(x)-min(x));
for i=1:size(Fnew,2)
    Fnew(:,i)=Normalize(Fnew(:,i));
end
%%
tic
validationPercent=.30;
numValidation=round(size(Fnew,1)*validationPercent);
FVal=Fnew(end-numValidation:end,:);
TVal=Targetnew(end-numValidation:end);
FTrainTest=Fnew(1:end-numValidation-1,:);
TTrainTest=Targetnew(1:end-numValidation-1);

k=10;
fun=@(Train,Target) fitctree(Train,Target);
[Out,err,cvMean,cvStd,Mdl,Res,Val]=KfoldClass(k,FTrainTest,TTrainTest+1,FVal,TVal+1,fun);
Val

Confusionmatrix = confusionmat(TVal+1,Val.out)
toc