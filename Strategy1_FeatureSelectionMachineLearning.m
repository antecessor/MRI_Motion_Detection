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
%%
[Fnew,Targetnew]=shuffle(F,Target);
%%
k=10;
fun=@(Train,Target) fitcknn(Fnew,Targetnew);
[Out,err,cvMean,cvStd,Mdl,Res]=KfoldClass(k,Fnew,Targetnew,fun);
cvMean