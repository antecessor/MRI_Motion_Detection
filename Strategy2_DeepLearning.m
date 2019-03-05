%% non:0 slight:1 mild:2 moderate:3 severe:4
%% Foldering
imagesDir='DataFolderForDNN';
originalFileLocation = fullfile(imagesDir);
%% Save Original Image
% For original images
for i=1:numel(I_person)
    for n=1:size(I_person{i},3)
     imwrite(abs(I_person{i}(:,:,n)),[originalFileLocation '/M0/'  num2str(i) '_' num2str(n) '.png']);
    end
    disp(['Person number ' num2str(i) ' is done...'])
end

% For motion artifact
for i=1:size(image_simMotion,1)
    for j=1:size(image_simMotion,2)
        for n=1:size(image_simMotion{i,j},3)
            imwrite(uint8(image_simMotion{i,j}(:,:,n)),[originalFileLocation '/M' num2str(j) '/'  num2str(i) '_' num2str(n) '.png']);      
        end
    end
    disp(['Person number ' num2str(i) ' is done...'])
end
%% Load + TrainTest
imds = imageDatastore(originalFileLocation, ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');
TrainPercent=.7;
numTrainingFiles =  round(numel(imds.Labels)/5*TrainPercent);
[imdsTrain,imdsTest] = splitEachLabel(imds,numTrainingFiles,'randomize');
%%
layers = [
    imageInputLayer([256 256 1])
    
    convolution2dLayer(3,8,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(5)
    softmaxLayer
    classificationLayer];

options = trainingOptions('sgdm', ...
    'MaxEpochs',20,...
    'InitialLearnRate',1e-4, ...
    'Verbose',false, ...
    'Plots','training-progress');
net = trainNetwork(imdsTrain,layers,options);
%% predict
YPred = classify(net,imdsTest);
YTest = imdsTest.Labels;
accuracy = sum(YPred == YTest)/numel(YTest)
confusionmat(YTest,YPred)