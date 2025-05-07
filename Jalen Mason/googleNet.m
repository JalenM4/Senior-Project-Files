function [learnableLayer, classLayer] = findLayersToReplace(lgraph)
    if ~isa(lgraph,'nnet.cnn.LayerGraph')
        error('Input must be a layerGraph object');
    end

    % Look for a classification layer
    classLayer = [];
    for i = 1:numel(lgraph.Layers)
        if isa(lgraph.Layers(i),'nnet.cnn.layer.ClassificationOutputLayer')
            classLayer = lgraph.Layers(i);
            break;
        end
    end

    % Look for the last fully connected or convolution layer
    learnableLayer = [];
    for i = numel(lgraph.Layers):-1:1
        if isa(lgraph.Layers(i),'nnet.cnn.layer.FullyConnectedLayer') || ...
           isa(lgraph.Layers(i),'nnet.cnn.layer.Convolution2DLayer')
            learnableLayer = lgraph.Layers(i);
            break;
        end
    end
end


net = googlenet;
lgraph = layerGraph(net);  % Use layer graph to retain DAG structure

% Determine the number of classes
numClasses = numel(categories(imdsTrain.Labels));

% Replace final layers
% 1. Find the name of the last learnable layer
[learnableLayer,classLayer] = findLayersToReplace(lgraph);

% 2. Create new layers
newLearnableLayer = fullyConnectedLayer(numClasses, ...
    'Name','new_fc', ...
    'WeightLearnRateFactor',10, ...
    'BiasLearnRateFactor',10);

newClassLayer = classificationLayer('Name','new_classoutput');

% 3. Replace layers
lgraph = replaceLayer(lgraph, learnableLayer.Name, newLearnableLayer);
lgraph = replaceLayer(lgraph, classLayer.Name, newClassLayer);

% Get the image input size required by AlexNet (typically [227 227 3])
inputSize = net.Layers(1).InputSize;

%% Create augmented image datastores for training and validation
augimdsTrain = augmentedImageDatastore(inputSize, imdsTrain);
augimdsVal   = augmentedImageDatastore(inputSize, imdsVal);

%% Set training options
options = trainingOptions('sgdm', ...
    'LearnRateSchedule', 'piecewise', ...
    'LearnRateDropFactor', 0.2, ...
    'LearnRateDropPeriod', 5, ...
    'MiniBatchSize', 64, ...
    'MaxEpochs', 10, ...
    'InitialLearnRate', 0.00015, ...
    'ValidationData', augimdsVal, ...
    'ValidationFrequency', 10, ...
    'Verbose', false, ...
    'Plots', 'training-progress');

%% Train the network
netTrained = trainNetwork(augimdsTrain, lgraph, options);

%% Save the trained network
save(['..' filesep() '..' filesep() 'Data' filesep() 'Common Data' filesep() 'googleNet-ILR-5.mat'], 'netTrained');

