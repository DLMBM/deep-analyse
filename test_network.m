% functions that display classification results of your network
function [a]=test_network(net_ideal512_5,imds_real)
[label,scores] = classify(net_ideal512_5,imds_real);
[c_folder,c_name,c_ext]=cellfun(@fileparts,imds_real.Files,'UniformOutput',false);
a=figure;set(gcf,'Color',[1,1,1]);
for i = 1:16
    subplot(4,4,i);
    imshow(imds_real.Files{i}); 
    title(string(c_name(i))+ "pred: " +  string(label(i)) + ", " + num2str(100*max(scores(i)),4) + "%",'FontSize',15);
end
end