% Load the pretrained GoogLeNet network
net = googlenet;

% Get the image input size of the network
inputSize = net.Layers(1).InputSize;

% Create a figure to display the image and results
fig = figure;

% Set up the user interface to select an image
[file, path] = uigetfile({'*.jpg;*.png;*.gif','All Image Files'});
if isequal(file,0)
    disp('User selected Cancel');
else
    % Read the selected image
    img = imread(fullfile(path,file));

    % Resize the image to match the network input size
    imgResized = imresize(img, inputSize(1:2));

    % Classify the image using the network
    [label, scores] = classify(net, imgResized);

    % Get the top predicted class and its score
    [~, idx] = max(scores);
    predictedClass = net.Layers(end).Classes(idx);
    score = scores(idx);

    % Display the image and classification results
    imshow(img);
    title({['Predicted Class: ' char(predictedClass)], ...
           ['Confidence: ' num2str(score*100, '%.2f') '%']});
end