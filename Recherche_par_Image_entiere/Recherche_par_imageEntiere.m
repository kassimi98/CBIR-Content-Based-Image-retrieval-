list= dir('data'); 

n=length(list)-2;

Ireq=imread('ImageRequete.jpg');

v=[];

for i=3:n
   IDB=imread(list(i).name);
   Ires=abs(diff(rgb2gray(IDB-Ireq)));
   [m,s]=find(Ires==0);
   v(i-2)=9480-size(m,1);
end

vsort=sort(v,'ascend');

figure;
subplot (3,2,1); imshow(Ireq), title('Image requéte');
for i=1:5
    [aa,bb,~]=find(v==vsort(i));
    subplot (3,2,i+1); imshow(list(bb(1)+2).name), title(list(bb(1)+2).name);
end
toc