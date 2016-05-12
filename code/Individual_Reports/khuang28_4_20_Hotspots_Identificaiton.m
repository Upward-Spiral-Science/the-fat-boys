% for deriving and displaying the local max for each marker across all 41
% stacks
% only showing a few sample images due to the huge memory size of the
% output images.
%file directory : https://www.dropbox.com/sh/zijowsqbaojr37x/AACYiMFXrqTKdxifd37c9Aiya?dl=0
system('caffeinate -dims &');
stacks = {'-01-synapsinR_7thA.tif', '-02-synapsinGP_5thA.tif', '-03-VGluT1_3rdA.tif', '-04-VGluT1_8thA.tif', '-05-VGluT2_2ndA.tif',...
    '-06-VGluT3_1stA.tif', '-07-psd_8thA.tif', '-08-GluR2_2ndA.tif', '-09-NMDAR1_6thA.tif', '-10-NR2B_9thA.tif'...
    '-11-GAD_6thA.tif', '-12-VGAT_5thA.tif'};
stacks = {'A.tif', '-03-VGluT1_3rdA.tif', '-04-VGluT1_8thA.tif', ...
    '-06-VGluT3_1stA.tif', '-07-psd_8thA.tif', '-08-GluR2_2ndA.tif', '-09-NMDAR1_6thA.tif', '-10-NR2B_9thA.tif'...
    '-11-GAD_6thA.tif', '-12-VGAT_5thA.tif'};
stacks = { '-02-synapsinGP_5thA.tif', '-03-VGluT1_3rdA.tif', '-04-VGluT1_8thA.tif', ...
    '-06-VGluT3_1stA.tif',...
    '-11-GAD_6thA.tif', '-12-VGAT_5thA.tif'};


%first 3 stacks of the first 3 markers
pointss = {[], [], [], [], [], []};
l = 0;
for j = 1 : 6
    file = stacks{j};
    Centers = [];
    
for i = 1 : 41
    %counter for publishing purposes
    l = l + 1;
%read in each stack    
[X,map] = imread(file,i);
a = X;  
original = a;
a =   medfilt2(a, [3, 3]);
a(a < median(a(:))) = 0;
a ( a <= mean(a(a>0)) + std2(a(a>0)) * 6) = 0;
CC = bwconncomp(imfill(a, 'holes'));
s = regionprops(CC,'Centroid',  'Area', 'MajorAxisLength');
positions = cat(1, s.Centroid);
areas = cat(1, s.Area);
axis = cat(1, s.MajorAxisLength);
taxis = axis(areas > mean(areas(:)) + std2(areas(:)) * 5);
tcentroid = positions(areas > mean(areas(:)) + std2(areas(:)) * 5, :);
if numel(taxis) > 0
    [columnsInImage, rowsInImage] = meshgrid(1:size(a,2), 1:size(a, 1));
circlePixels = (rowsInImage - tcentroid(1,2)).^2 + (columnsInImage - tcentroid(1,1)).^2 <= taxis(1).^2;
for k = 2 : length(tcentroid)/2
circlePixels = (rowsInImage - tcentroid(k,2)).^2 + (columnsInImage - tcentroid(k,1)).^2 <= taxis(k).^2 + circlePixels;
end
end
%find local hotspots
a(circlePixels) = 0;

BW = imregionalmax(a);
a(~BW) = 0;

%set theshreshold to eliminate low-intensity signal from the local hotspots
m = mean(a(a~= 0));
s = std2(a(a ~= 0));
a ( a < m + 2 * s) = 0;
%deriving the coordinate for each hotpsot left
CC = bwconncomp(imfill(a, 'holes'));
s = regionprops(CC,'centroid');
centroids = cat(1, s.Centroid);
%display the stack and each local hotspot
gcf = figure(100);
imshow(original);
hold on;
title([file, '_', num2str(i),'_local_max_','.tif']);
if numel(centroids) ~= 0
    plot(centroids(:,1),centroids(:,2), 'y.')
    pointss{j} = [pointss{j}; centroids(:,1),centroids(:,2), ones(numel(centroids(:,2)), 1) * i];
    f = getframe(gcf);
else 
    pointss{j} = [-1, -1, -1];
end

hold off;
end



end