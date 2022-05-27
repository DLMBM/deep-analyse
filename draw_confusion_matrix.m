function [a]=draw_confusion_matrix(net_noise_more_transfer_3,imdsValidation_noise)
a=figure;set(gcf,'Color',[1,1,1]);
YPredValidation = classify(net_noise_more_transfer_3,imdsValidation_noise);
YValidation = imdsValidation_noise.Labels;
plotconfusion(YValidation,YPredValidation);
title('CNN noise confusion matrix','FontSize',20);
end