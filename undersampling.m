function [imdsTrain_noise,imdsValidation_noise,imdsTest_noise,imds_noise]=undersampling()
digitDatasetPath1 = fullfile('F:\newimage\hex');
digitDatasetPath2 = fullfile('F:\newimage\cubic');
digitDatasetPath3 = fullfile('F:\images\misclassified');
digitDatasetPath4 = fullfile('F:\newimage\');
imds_cubic = imageDatastore(digitDatasetPath2, ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');
imds_cubic=splitEachLabel(imds_cubic,0.87,'randomize');
imds_cubic.Labels(:)='cubic';
imds_hex = imageDatastore(digitDatasetPath1, ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');
imds_hex.Labels(:)='hex';
imds_misclassified= imageDatastore(digitDatasetPath3, ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');
imds_noise= imageDatastore(digitDatasetPath4, ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');

imds_noise.Files=[imds_cubic.Files;imds_hex.Files;imds_misclassified.Files];
imds_noise.Labels=[imds_cubic.Labels;imds_hex.Labels;imds_misclassified.Labels];
% 
% imds_noise.Files=[imds_cubic.Files;imds_hex.Files];
% imds_noise.Labels=[imds_cubic.Labels;imds_hex.Labels];
imds_noise=splitEachLabel(imds_noise,0.2,'randomize');
[imdsTrain_noise,imdsValidation_noise,imdsTest_noise] = splitEachLabel(imds_noise,0.7,0.2,0.1,'randomize');
% save('bayesian.mat','imdsTest_noise','imdsValidation_noise','imdsTrain_noise','imds_noise');
save('cnn2_material_1.mat','imds_noise');
end

