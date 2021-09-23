clc

index = input('Voulez vous lancer l''indexation? taper Y si oui:','s');
if (index=='Y')
 [features, Image_names]=CBIR_Indexation(7) ;
end

Ireq=imread('ImageRequete.jpg');

CBIR_Recherche(Ireq,features, Image_names);


function [features, Image_names]=CBIR_Indexation(fsize)

list= dir('obj_decoys'); 

n=length(list)-2;

features=zeros(n-2,fsize);

disp('Debut d''Indexation')
for i=3:n
 IDB=imread(strcat(list(i).folder,'/',list(i).name));
 %IDB=imread(list(i).name);
 features(i-2,:)=[getFeatures(IDB, fsize), i-2];
 filename(i-2)=string(list(i).name);
end
Image_names=filename;
disp('Fin d''Indexation');

end
function features = getFeatures(img, ~)
   features=color_Moments(img);
end

function colorFeature = color_Moments(img)

R = double(img(:, :, 1));
G = double(img(:, :, 2));
B = double(img(:, :, 3));
colorFeature=[mean(R(:)), std(R(:)), mean(G(:)), std(G(:)), mean(B(:)), std(B(:))];
colorFeature= colorFeature / mean(colorFeature);

end

function CBIR_Recherche(Ireq,features, Image_names)

disp('Recherche...');

[~, fsize]=size(features);
feature_req=getFeatures(Ireq, fsize);

Distance(:,1) = pdist2(features(:,1:fsize-1),feature_req,'euclidean');
Sorted_Distance=sort(Distance,'ascend');

figure;
subplot (3,2,1); imshow(Ireq), title('Image requéte');
for i=1:5
 [aa,bb,~]=find(Distance==Sorted_Distance(i));
 subplot (3,2,i+1); imshow(imread(char(Image_names(aa(1))))), 
title(char(Image_names(aa(1))));
end
end


