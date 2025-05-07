load(['..' filesep() '..' filesep() 'Data' filesep() 'Common Data' filesep() 'ImgDB.mat' ])
% Load the pretrained 
net = vgg19;

layers = net.Layers;
layers(end-2:end) = [];


numClasses = numel(categories(imdsTrain.Labels)); 
layers = [
    layers
    fullyConnectedLayer(numClasses, 'WeightLearnRateFactor',10, 'BiasLearnRateFactor',10)
    softmaxLayer
    classificationLayer];

lgraph = layerGraph(layers);
%dlnet = dlnetwork(lgraph);

% Get the image input size of the network
inputSize = net.Layers(1).InputSize;

[imdsTrain, imdsVal] = splitEachLabel(imdsTrain, 0.8, 'randomized');

% Training Options
options = trainingOptions('sgdm', ...
    'LearnRateSchedule', 'piecewise', ...
    'LearnRateDropFactor', 0.700, ...
    'LearnRateDropPeriod', 5, ...
    'MiniBatchSize', 64, ...
    'MaxEpochs', 10, ...
    'InitialLearnRate', 0.0005, ...
    'ValidationData', [], ...
    'ValidationFrequency', 10, ...
    'ValidationPatience', Inf, ...
    'Verbose', false, ...
    'Plots', 'training-progress');

%[imdsTrain,imdsTest] = splitEachLabel(imds,numTrainFiles,"randomized");

augimdsTrain = augmentedImageDatastore([224, 224, 3], imdsTrain);
augimdsVal = augmentedImageDatastore([224, 224, 3], imdsVal);

netTrained = trainNetwork(augimdsTrain, lgraph, options);
% change name every train
save(['..' filesep() '..' filesep() 'Data' filesep() 'Common Data' filesep() 'VGG19-LRDF-3.mat' ], 'netTrained')


predictedLabels = classify(netTrained, imdsTest);
valLabels = imdsTest.Labels;

% Compute overall accuracy.
accuracy = mean(predictedLabels == valLabels);
fprintf('Overall Accuracy: %.2f%%\n', accuracy * 100);

% Compute per-class percentages.
classNames = categories(predictedLabels);
counts = countcats(predictedLabels);
percentages = (counts / numel(predictedLabels)) * 100;
for i = 1:numel(classNames)
    fprintf('Class %s: %.2f%%\n', classNames{i}, percentages(i));
end