
fileList = dir(['..' filesep() 'Data' filesep() 'import' filesep() 'BCI_dataset' filesep() 'IHC' filesep() 'train' filesep() '*.png']);

for fileIdx = 1:length(fileList)
    filename = filelist(fileIdx).name;
    sym1Idx = strfind(filename,'_');
    sym2Idx = strfind(filename,'.');
    groundtruth_label = filename(sym1Idx(end)+1:sym2Idx(1)-1);

    % ground truth label states u can copy image file 
    % into the corresponding folder in the area 
    srcPath = ['..' filesep() 'Data' filesep() 'import' filesep() 'BCI_dataset' filesep() 'IHC' filesep() 'train' filesep() fileList(fileIdx).name];
    tarPath = ['..' filesep() 'Data' filesep() 'meta' filesep() 'IHC' filesep() 'train' filesep() groundtruth_label filesep() fileList(fileIdx).name];
    copyfile(srcPath,tarPath);
end

fileList = dir(['..' filesep() 'Data' filesep() 'Import' filesep() 'BCI_dataset' filesep() 'IHC' filesep() 'test' filesep() '*.png']);

for fileIdx = 1:length(fileList)
    filename = filelist(fileIdx).name;
    sym1Idx = strfind(filename,'_');
    sym2Idx = strfind(filename,'.');
    groundtruth_label = filename(sym1Idx(end)+1:sym2Idx(1)-1);

    % ground truth label states u can copy image file 
    % into the corresponding folder in the area 
    srcPath = ['..' filesep() 'Data' filesep() 'import' filesep() 'BCI_dataset' filesep() 'IHC' filesep() 'test' filesep() fileList(fileIdx).name];
    tarPath = ['..' filesep() 'Data' filesep() 'meta' filesep() 'IHC' filesep() 'test' filesep() groundtruth_label filesep() fileList(fileIdx).name];
    copyfile(srcPath,tarPath);
end

imdsTrain = imageDatastore(['..' filesep() 'Data' filesep() 'meta' filesep() 'BCI_dataset' filesep() 'IHC' filesep() 'train'],  'IncludeSubfolders',true, 'LabelSource', 'foldernames');
imdsTest = imageDatastore(['..' filesep() 'Data' filesep() 'meta' filesep() 'BCI_dataset' filesep() 'IHC' filesep() 'test'], 'IncludeSubfolders',true, 'LabelSource','foldernames');