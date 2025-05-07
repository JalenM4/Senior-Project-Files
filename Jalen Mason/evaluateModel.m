%% Load the Image Datastore and Trained Model
load(['..' filesep() '..' filesep() 'Data' filesep() 'Common Data' filesep() 'ImgDB.mat'], 'imdsTest');
load(['..' filesep() '..' filesep() 'Data' filesep() 'Common Data' filesep() 'mobilenetv2-ILR-5.mat'], 'netTrained');

%% Prepare Test Dataa
inputSize = netTrained.Layers(1).InputSize;
augImdsTest = augmentedImageDatastore(inputSize, imdsTest);

%% Classify Test Images
predictedLabels = classify(netTrained, augImdsTest);
trueLabels = imdsTest.Labels;

%% Overall Accuracy
accuracy = mean(predictedLabels == trueLabels);
fprintf('Overall Accuracy: %.2f%%\n', accuracy * 100);

%% Confusion Matrix
confMat = confusionmat(trueLabels, predictedLabels);
figure;
confusionchart(trueLabels, predictedLabels);
title('Confusion Matrix');

%% Per-Class Precision and Recall
classNames = categories(trueLabels);
numClasses = numel(classNames);
precision = zeros(numClasses, 1);
recall = zeros(numClasses, 1);

for i = 1:numClasses
    idx = trueLabels == classNames{i};
    pred = predictedLabels == classNames{i};

    TP = sum(idx & pred);
    FP = sum(~idx & pred);
    FN = sum(idx & ~pred);

    precision(i) = TP / (TP + FP + eps);
    recall(i) = TP / (TP + FN + eps);

    fprintf('Class: %-15s | Precision: %.2f%% | Recall: %.2f%%\n', ...
        classNames{i}, precision(i) * 100, recall(i) * 100);
end

%% Optional: Display Sample Predictions
figure;
perm = randperm(numel(imdsTest.Files), 9);
for i = 1:9
    subplot(3, 3, i);
    img = readimage(imdsTest, perm(i));
    resizedImg = imresize(img, inputSize(1:2));
    label = predictedLabels(perm(i));
    trueLabel = trueLabels(perm(i));
    imshow(resizedImg);
    title(sprintf('True: %s\nPred: %s', string(trueLabel), string(label)), ...
        'FontSize', 10);
end
sgtitle('Sample Predictions');
