clc

index = input('Voulez vous lancer l''indexation? taper Y si oui:','s');
if (index=='Y')
 [features, Image_names]=CBIR_Indexation(7) ;
end

Ireq=imread('ImageRequete.jpg');

CBIR_Recherche(Ireq,features, Image_names);

function features = getFeatures(img, fsize)
    features=zeros(fsize-1,1);
    if (fsize>=7)
    features = color_Moments(img);
    end
    if (fsize>=39)
    features = [features, hsvHistogramFeatures(img)];
    end
    if (fsize>=43)
    features = [features, textureFeatures(img)];
    end
end

function texture_features= textureFeatures(img)
    glcm = graycomatrix(rgb2gray(img),'Symmetric', true);
    stats = graycoprops(glcm);
    texture_features=[stats.Contrast, stats.Correlation, stats.Energy, 
    stats.Homogeneity];
    texture_features=texture_features/sum(texture_features);
end


function colorFeature = color_Moments(img)

R = double(img(:, :, 1));
G = double(img(:, :, 2));
B = double(img(:, :, 3));

colorFeature=[mean(R(:)), std(R(:)), mean(G(:)), std(G(:)), mean(B(:)), std(B(:))];
end


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

function hsvColor_Histogram = hsvHistogramFeatures(img)

[rows, cols, numOfBands] = size(img);

img = rgb2hsv(img);

h = img(:, :, 1);
s = img(:, :, 2);
v = img(:, :, 3);

numberOfLevelsForH = 8; % 8 niveau pour h
numberOfLevelsForS = 2; % 2 niveau pour s
numberOfLevelsForV = 2; % 2 niveau pour v
 
maxValueForH = max(h(:));
maxValueForS = max(s(:));
maxValueForV = max(v(:));

hsvColor_Histogram = zeros(8, 2, 2);
quantizedValueForH=ceil((numberOfLevelsForH .* h)./maxValueForH);
quantizedValueForS= ceil((numberOfLevelsForS .* s)./maxValueForS);
quantizedValueForV= ceil((numberOfLevelsForV .* v)./maxValueForV);
index = zeros(rows*cols, 3);
index(:, 1) = reshape(quantizedValueForH',1,[]);
index(:, 2) = reshape(quantizedValueForS',1,[]);
index(:, 3) = reshape(quantizedValueForV',1,[]);

for row = 1:size(index, 1)
 if (index(row, 1) == 0 || index(row, 2) == 0 || index(row, 3) == 0)
 continue;
 end
 hsvColor_Histogram(index(row, 1), index(row, 2), index(row, 3)) = hsvColor_Histogram(index(row, 1), index(row, 2), index(row, 3)) + 1;
end

hsvColor_Histogram = hsvColor_Histogram(:)';
hsvColor_Histogram = hsvColor_Histogram/sum(hsvColor_Histogram);
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
