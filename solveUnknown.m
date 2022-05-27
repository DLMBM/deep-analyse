
%This program counts the distribution of unknown images in the perspective
%of orientations
%this program is for stage 2
digitDatasetPath1 = fullfile('C:\Users\kezhang\Desktop\07-04-2022NewStart\Unknown_material\Unknown_ideal_cubic');
digitDatasetPath2 = fullfile('C:\Users\kezhang\Desktop\07-04-2022NewStart\Unknown_material\Unknown_noise_cubic');

digitDatasetPath3 = fullfile('C:\Users\kezhang\Desktop\07-04-2022NewStart\Unknown_material\Unknown_noise_more_cubic');

digitDatasetPath4 = fullfile('C:\Users\kezhang\Desktop\07-04-2022NewStart\Unknown_material\Unknown_noise_7_cubic');
digitDatasetPath5 = fullfile('C:\Users\kezhang\Desktop\07-04-2022NewStart\Unknown_material\Unknown_noise_5_cubic');

transfer_cubic=fullfile('C:\Users\kezhang\Desktop\07-04-2022NewStart\Unknown_material\Unknown_noise_more_transfer_cubic');
transfer_hex=fullfile('C:\Users\kezhang\Desktop\07-04-2022NewStart\Unknown_material\Unknown_noise_more_transfer_hex');

digitDatasetPath6 = fullfile('C:\Users\kezhang\Desktop\07-04-2022NewStart\Unknown_material\Unknown_ideal_hex');
digitDatasetPath7 = fullfile('C:\Users\kezhang\Desktop\07-04-2022NewStart\Unknown_material\Unknown_noise_hex');
% digitDatasetPath8 = fullfile('C:\Users\kezhang\Desktop\07-04-2022NewStart\Unknown_material\Unknown_more_hex');
digitDatasetPath9 = fullfile('C:\Users\kezhang\Desktop\07-04-2022NewStart\Unknown_material\Unknown_noise_7_hex');
digitDatasetPath10 = fullfile('C:\Users\kezhang\Desktop\07-04-2022NewStart\Unknown_material\Unknown_noise_5_hex');


imds1= imageDatastore(digitDatasetPath1, ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');
imds2= imageDatastore(digitDatasetPath2, ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');

imds3= imageDatastore(digitDatasetPath3, ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');

imds4= imageDatastore(digitDatasetPath4, ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');

imds5= imageDatastore(digitDatasetPath5, ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');

imds6= imageDatastore(digitDatasetPath6, ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');

imds7= imageDatastore(digitDatasetPath7, ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');

% imds8= imageDatastore(digitDatasetPath8, ...
%     'IncludeSubfolders',true, ...
%     'LabelSource','foldernames');

imds9= imageDatastore(digitDatasetPath9, ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');

imds10= imageDatastore(digitDatasetPath10, ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');
imds_transfer_cubic=imageDatastore(transfer_cubic, ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');
imds_transfer_hex=imageDatastore(transfer_hex, ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');
% cubic_5=[imds4.Files;imds5.Files;imds1.Files;imds2.Files];
% hex_5=[imds9.Files;imds10.Files;imds6.Files;imds7.Files];

% cubic_5=[imds4.Files;imds5.Files;imds3.Files];
% hex_5=[imds9.Files;imds10.Files];
% 
% cubic_5=[imds_transfer_cubic.Files];
% hex_5=[imds_transfer_hex.Files];

 cubic_5=[imds4.Files;imds5.Files;imds_transfer_cubic.Files];
 hex_5=[imds9.Files;imds10.Files;imds_transfer_hex.Files];



ch_name=find_image_name(cubic_5);
hc_name=find_image_name(hex_5);
Al=findelements(ch_name,'Aluminium');
Steel=findelements(ch_name,'Steel');
Fe=findelements(ch_name,'Iron');

Mg=findelements(hc_name,'Magnesium');
Tialpha=findelements(hc_name,'Ti(alpha)');
Ti6242=findelements(hc_name,'Ti-6242');
Ti6Al4V=findelements(hc_name,'Ti-6Al-4V');

[Al,chh]=resolve_paramters(Al);
resolve_paramters(Steel);
resolve_paramters(Fe);

Mg=plothc(Mg);
Tialpha=plothc(Tialpha);
Ti6242=plothc(Ti6242);
Ti6Al4V=plothc(Ti6Al4V);
figure(5);
subplot(4,1,1);
resolve_paramters_hex(Mg,'Mg');
subplot(4,1,2);
resolve_paramters_hex(Tialpha,'Tialpha');
subplot(4,1,3);
resolve_paramters_hex(Ti6242,'Ti6242');
subplot(4,1,4);
resolve_paramters_hex(Ti6Al4V,'Ti6Al4V');

% y=zeros(91,4);
% y(1:length(Mg),1)=Mg;
% y(1:length(Tialpha),2)=Tialpha;
% y(1:length(Ti6242),3)=Ti6242;
% y(1:length(Ti6Al4V),4)=Ti6Al4V;
% b=bar(y,1);
% set(b, {'DisplayName'}, {'Mg','Tialpha','Ti6242','Ti6Al4V'}');
% legend() 
% xtips2 = b(2).XEndPoints;
% ytips2 = b(2).YEndPoints;
% labels2 = string(b(2).YData);
% text(xtips2,ytips2,labels2,'HorizontalAlignment','center',...
%     'VerticalAlignment','bottom')
% 
figure;set(gcf,'Color',[1,1,1]);
iii=imageDatastore('F:\images\a', ...
    'IncludeSubfolders',true, ...
    'LabelSource','foldernames');
for i = 1:25
    subplot(5,5,i);
    imshow(iii.Files{i}); 
%     title(string(label(i)) + ", " + num2str(100*max(scores(i)),4) + "%",'FontSize',10);
end


function [Al,Al_index,Al_strings]=findelements(ch_name,material_name)
Al_strings=contains(string(ch_name),string(material_name));
Al_index=find(Al_strings);
Al=ch_name(Al_index);
end

function ch_name=find_image_name(cubic_5)
[ch_folder,ch_name,ch_ext]=cellfun(@fileparts,cubic_5,'UniformOutput',false);
end

function [ch_1vel,Ni_rotation]=plothc(Ni)
Ni=cellfun(@(x) strsplit(x, 'vel'), Ni, 'UniformOutput', false);
Ni = vertcat(Ni{:});
Ni(:,1)=[];
Ni=cellfun(@(x) strsplit(x, '-'), Ni, 'UniformOutput', false);
Ni=vertcat(Ni{:});
Ni(:,3:7)=[];
Ni=strrep(Ni,'ro','');
Ni_rotation=string(Ni(:,2));
Ni_rotation=str2double(Ni_rotation(:));
%cont the number of rotations
Ni_rotation=tabulate(Ni_rotation);
%get the first orientation
ch_1vel=string(Ni(:,1));
ch_1vel=str2double(ch_1vel(:));
%count the how many velocities it has
ch_1vel=tabulate(ch_1vel);
%the second column of tabulate is the number, so only output the second
%column
ch_1vel=ch_1vel(:,2);
end

function resolve_paramters_hex(ch_1vel,name)
t=sum(ch_1vel)*ones(length(ch_1vel),1);
k=ch_1vel./t;

chimg1=heatmap(ch_1vel');colormap jet(255);% set(gca,'YDir','normal'); 
set(gcf,'color','w');
chimg1.YLabel=string(name);
end


function [Al,chh]=resolve_paramters(ch_name)
Al=cellfun(@(x) strsplit(x, '1vel'), ch_name, 'UniformOutput', false);
Al = vertcat(Al{:});
Al(:,1)=[];
Al=cellfun(@(x) strsplit(x, '-'), Al, 'UniformOutput', false);
Al=vertcat(Al{:});
Al(:,4:8)=[];
Al=strrep(Al,'2vel','');
Al=strrep(Al,'ro','');
%get the first orientation
ch_1vel=string(Al(:,1));
ch_1vel=str2double(ch_1vel(:));
%get the second orientation
ch_2vel=string(Al(:,2));
ch_2vel=str2double(ch_2vel(:));
chh=zeros(21);
for i=1:length(ch_1vel)
  chh(ch_1vel(i),ch_2vel(i))=chh(ch_1vel(i),ch_2vel(i))+1;
end
k=sum(chh)*ones(21,21);
aa=chh./k;
figure;set(gcf,'Color',[1,1,1]);
set(gca,'FontSize',20);
chimg1=heatmap(chh);colormap jet(255);% set(gca,'YDir','normal');  
chimg1.XLabel='orientaion1';
chimg1.YLabel='orientation2';
chimg1.YDisplayData=flip(chimg1.YDisplayData);
set(gcf,'color','w');
% saveas(chimg1,filename1);
end

