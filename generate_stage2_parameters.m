
load("stage2.mat");
%get the orientations and crystal index
stage2_cubic_param=stage2cubic(:,1:3);
stage2_hex_param=stage2hex(:,1:2);
%get the portion of misclassfied planes
[mis_hex_numbers,mis_cubic_numbers]=mis_portion(stage2hex(:,3),stage2cubic(:,4));

a=give_rotations(stage2_cubic_param,mis_cubic_numbers,1900);
b=give_rotations(stage2_hex_param,mis_hex_numbers,1900);

fringes=6:2:10;
interval=1:2;
random_noise=[0.19,0.2];
noise_std=[0.49,0.5];

cubicparameters=combvec(a,interval,fringes,noise_std,random_noise);
hexparameters=combvec(b,interval,fringes,noise_std,random_noise);

% save('stage2params.mat','cubicparameters','hexparameters');


function a=give_rotations(stage2_cubic_param,mis_cubic_numbers,n)
mis_cubic_numbers=round(mis_cubic_numbers*n);
a=[];

for i=1:(length(mis_cubic_numbers))
rotation=randperm(360,mis_cubic_numbers(i));
c=combvec(stage2_cubic_param(i,:)',rotation);
a=[a,c];
end
end

function [mis_hex_numbers,mis_cubic_numbers]=mis_portion(stage2hex,stage2cubic)
mis_cubic_numbers=stage2cubic;
ave_cubic=sum(mis_cubic_numbers(:));
mis_cubic_numbers=mis_cubic_numbers(:)/ave_cubic;

mis_hex_numbers=stage2hex;
ave_hex=sum(mis_hex_numbers(:));
mis_hex_numbers=mis_hex_numbers(:)/ave_hex;

end