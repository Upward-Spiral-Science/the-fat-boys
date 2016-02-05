image = imread('E:\KDM-SYN-100824B\-01-synapsinR_7thA.tif');
pivots=load('synapsinR_7thA.tif.Pivots.txt');

imshow(image)
hold on
plot(pivots(:,1),pivots(:,2),'o')
colormap(gray(10))

