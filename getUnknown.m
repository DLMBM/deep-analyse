%load the ideal CNN and related files
% load('./CNN_noise/CNN_noise_more.mat','net_noise_more');
% load('./CNN_noise/imds_noise_more.mat','imdsTest_noise','imdsValidation_noise');

%load the noisy CNN and related files
% load('./CNN_noise/CNN_noise.mat','net_noise');
% load('./CNN_noise/imds.mat','imdsTest','imdsValidation');

net=net1_4;

YPredValidation = classify(net,imdsValidation_noise);
YValidation = imdsValidation_noise.Labels;
YPredTest= classify(net,imdsTest_noise);
YTest=imdsTest_noise.Labels;

IndexTest=find(YTest~=YPredTest)
IndexValidation=  find(YValidation~=YPredValidation);
M=size(IndexValidation);
N=size(IndexTest);

UnknownValidation="./Unknown_cnet1_4";
UnknownTest="./Unknown_cnet1_4";

for i=1 : M
% differTestName(i)=imdsTest.Files(IndexTest(i));
differValidationName(i)=imdsValidation_noise.Files(IndexValidation(i));
%differName = differName(differName ~= differName(i));
% movefile(string(differValidationName(i)),UnknownValidation); 
copyfile(string(differValidationName(i)),UnknownValidation); 
end

for j=1:N
differTestName(j)=imdsTest_noise.Files(IndexTest(j));
% movefile(string(differTestName(j)),UnknownTest); 
copyfile(string(differTestName(j)),UnknownTest); 
end

save("cnn1_4_unknown_statistic.mat",'differValidationName', ...
    'differTestName', ...
    'YPredValidation','YValidation','YPredTest', ...
    'YTest',"N",'M','IndexTest','IndexValidation');
