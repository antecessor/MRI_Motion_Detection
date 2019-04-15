%% non:0 slight:1 mild:2 moderate:3 severe:4
%% Foldering
imagesDir='DataFolderForDNN';
originalFileLocation = fullfile(imagesDir);
%% Save Original Image

for i=1:numel(I) 
    imwrite(uint8(I{i}),[originalFileLocation '/M' num2str(Target(i)) '/'  num2str(i) '.png']);         
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