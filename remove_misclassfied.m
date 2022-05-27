
% load('./CNN_noise/imds_noise_transfer.mat');
load("stage2.mat");
load("GenerateParameters.mat","hex","cubic");
[hex_name]= {hex(:).name};
[cubic_name]= {cubic(:).name};

cubic_material=string(cubic_name(stage2cubic(:,1))')+'-1vel'+string(stage2cubic(:,2))+'-2vel'+string(stage2cubic(:,3));

hex_material=string(hex_name(stage2hex(:,1))')+'-vel'+string(stage2hex(:,2));

material=[cubic_material;hex_material];

ch_name=find_image_name(imds_noise.Files);
[name,index,strings]=findelements(ch_name,material);
imds_noise.Files(index)=[];


function ch_name=find_image_name(cubic_5)
[ch_folder,ch_name,ch_ext]=cellfun(@fileparts,cubic_5,'UniformOutput',false);
end

function [Al,Al_index,Al_strings]=findelements(ch_name,material_name)
Al_strings=contains(string(ch_name),string(material_name));
Al_index=find(Al_strings);
Al=ch_name(Al_index);
end