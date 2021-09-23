import os
import matplotlib.pyplot as plt
import numpy as np
def load_images_from_folder(folder):
    images = []
    names=[]
    for filename in os.listdir(folder):
        img = plt.imread(os.path.join(folder,filename))
        if img is not None:
            images.append(img)
            names.append(filename)
    return images, names

path="C:/Users/AmineKassimi/Documents/Tp_image_mining/obj_decoys"
images, names=load_images_from_folder(path)

#the length of the folder
print("la nbre d'images est:",len(images))

#display the name of the file number 10
print("la nom du fichier num 10 est:",names[10])

#diplay the image number 10
plt.imshow(images[10])
plt.title(names[10])

#diplay the 6 first images
fig, axes = plt.subplots(2, 3, figsize = (10,10))
axes = axes.ravel()

for i in np.arange(0, 6): 
       
    axes[i].imshow( images[i])
    axes[i].set_title(names[i], fontsize = 25)
    
plt.subplots_adjust(hspace=0)