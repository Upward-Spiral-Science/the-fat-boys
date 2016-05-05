%% Load all images
compare = dir('E:\KDM-SYN-100824B');

loc_tot = cell(1,size(compare,1) - 2);

for i = 1:(size(compare,1) - 2)
    i
    name = compare(i).name;
    disp(name)
    fname = ['E:\KDM-SYN-100824B\',name];
    info = imfinfo(fname);
    imageStack_alt = [];
    numberOfImages = length(info);
    for k = 1:41
        currentImage = imread(fname, k, 'Info', info);
        imageStack_alt(:,:,k) = double(currentImage(600:1500,300:1000));
    end

    max_loc_alt =[];
    for k = 1:size(imageStack,3)
        [rows_t, cols_t] = nonmaxsuppts(imageStack_alt(:,:,k),3,mean(mean(imageStack_alt(:,:,k))));
        z_t = k * ones(length(rows_t),1);
        max_loc_alt = [max_loc_alt; rows_t,cols_t,z_t];
    end
    loc_tot{i} = max_loc_alt;
end
%% 
dist_mean_res = zeros(size(compare,1) - 2,size(compare,1) - 2);
dist_median_res = zeros(size(compare,1) - 2,size(compare,1) - 2);
for i = 1:(size(compare,1) - 2)
   i
   for j =  1:(size(compare,1) - 2)
       max_loc = loc_tot{i};
       max_loc_alt = loc_tot{j};
       [~,D] = knnsearch([max_loc_alt(:,1) * 100, max_loc_alt(:,2) * 100, max_loc_alt(:,3) * 70],...
       [max_loc(:,1) * 100, max_loc(:,2) * 100, max_loc(:,3) * 70]);
       dist_mean_res(i,j) = mean(D);
       dist_median_res(i,j) = median(D);
   end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load images
%fname = 'E:\KDM-SYN-100824B\-01-synapsinR_7thA.tif';
%fname = 'E:\KDM-SYN-100824B\-24-dapi_1stA (2).tif';
%fname = 'E:\KDM-SYN-100824B\-23-tubulin_8thA.tif';
fname = 'E:\KDM-SYN-100824B\-16-GABABR1_3rdA.tif';
info = imfinfo(fname);
imageStack = [];
numberOfImages = length(info);
for k = 1:41
    currentImage = imread(fname, k, 'Info', info);
    imageStack(:,:,k) = double(currentImage(600:1500,300:1000));
end

max_loc =[];
for i = 1:size(imageStack,3)
    [rows_t, cols_t] = nonmaxsuppts(imageStack(:,:,i),3,mean(mean(imageStack(:,:,i))));
    z_t = i * ones(length(rows_t),1);
    max_loc = [max_loc; rows_t,cols_t,z_t];
end

%%
a = imageStack(:,:,1);
[rows, cols] = nonmaxsuppts(a,3,mean(a(:)));
imshow(a / 2000)
hold on
plot(cols,rows,'o')
%%
PSF = fspecial('gaussian',7,0.1);
V = .01;
NOISEPOWER = V*prod(size(a));
[J LAGRA] = deconvreg(a,PSF,NOISEPOWER);
%%
[ca,chd,cvd,cdd] = swt2(a,3,'sym4');
%%
index = sub2ind(size(a),rows,cols);
mask = zeros(size(a));
mask(index) = 1;
imshow(mask)
a = 2;
iptsetpref('ImshowBorder','tight');
name = ['result',num2str(a)];
print(gcf,name,'-dpng','-fillpage')
clf

%% 1-Nearest Neighbors

max_loc =[];
for i = 1:size(imageStack,3)
    [rows_t, cols_t] = nonmaxsuppts(imageStack(:,:,i),3,mean(mean(imageStack(:,:,i))));
    z_t = i * ones(length(rows_t),1);
    max_loc = [max_loc; rows_t,cols_t,z_t];
end

compare = dir('E:\KDM-SYN-100824B');

dist_res = zeros(1,size(compare,1) - 2);
dist_tot = cell(1,size(compare,1) - 2);

for i = 1:(size(compare,1) - 2)
    i
    name = compare(i).name;
    disp(name)
    fname = ['E:\KDM-SYN-100824B\',name];
    info = imfinfo(fname);
    imageStack_alt = [];
    numberOfImages = length(info);
    for k = 1:41
        currentImage = imread(fname, k, 'Info', info);
        imageStack_alt(:,:,k) = double(currentImage(600:1500,300:1000));
    end

    max_loc_alt =[];
    for k = 1:size(imageStack,3)
        [rows_t, cols_t] = nonmaxsuppts(imageStack_alt(:,:,k),3,mean(mean(imageStack_alt(:,:,k))));
        z_t = k * ones(length(rows_t),1);
        max_loc_alt = [max_loc_alt; rows_t,cols_t,z_t];
    end
    
    [~,D] = knnsearch([max_loc_alt(:,1) * 100, max_loc_alt(:,2) * 100, max_loc_alt(:,3) * 70],...
        [max_loc(:,1) * 100, max_loc(:,2) * 100, max_loc(:,3) * 70]);
    dist_res(i) = mean(D);
    dist_tot{i} = D;
end

%% Old Nearest Neighbors
flattened = permute(imageStack,[1 3 2]);
flattened = reshape(flattened,[],size(imageStack,2),1);
compare = dir('E:\KDM-SYN-100824B');
%corr_res = zeros(1,size(compare,1) - 2);
dist_res = zeros(1,size(compare,1) - 2);
dist_tot = cell(1,size(compare,1) - 2);
[rows, cols] = nonmaxsuppts(flattened,3,mean(flattened(:)));
index = sub2ind(size(flattened),rows,cols);
mask = zeros(size(flattened));
mask(index) = 1;
imshow(mask)


for i = 1:(size(compare,1) - 2)
    i
    name = compare(i).name;
    disp(name)
    fname = ['E:\KDM-SYN-100824B\',name];
    info = imfinfo(fname);
    imageStack = [];
    numberOfImages = length(info);
    for k = 1:41
        currentImage = imread(fname, k, 'Info', info);
        imageStack_alt(:,:,k) = double(currentImage(600:1500,300:1000));
    end
    flattened_alt = permute(imageStack_alt,[1 3 2]);
    flattened_alt = reshape(flattened_alt,[],size(imageStack_alt,2),1);

    [rows_alt, cols_alt] = nonmaxsuppts(flattened_alt,3,mean(flattened_alt(:)));
    index = sub2ind(size(flattened_alt),rows_alt,cols_alt);
    mask_alt = zeros(size(flattened_alt));
    mask_alt(index) = 1;
    %imshow(mask_alt)

    %iptsetpref('ImshowBorder','tight');
    %name = ['mask',num2str(i)];
    %print(gcf,name,'-dpng')
    %clf
    
    %corr_res(i) = corr2(mask,mask_alt);
    %disp(corr_res(i))
    
    [~,D] = knnsearch([rows_alt cols_alt],[rows cols]);
    dist_res(i) = mean(D);
    dist_tot{i} = D;
end
%%
dist_res = zeros(1,size(compare,1) - 2);
for i = 1:(size(compare,1) - 2)
    dist_res(i) = median(dist_tot{i});
end


%% 
divide =  max(max(max(imageStack(:,:,:))));

for i = 1:size(imageStack,3)
    zplanes(i) = surface([1, 500; 1, 500], [1,1; 500, 500], zeros(2) + 10 * i - 10,...
    imageStack(:,:,i) / divide * 255,'FaceColor', 'texturemap',...
    'CDataMapping', 'direct','EdgeColor','none');
end

daspect([1 1 1])
colormap(gray)

view(25,25)
drawnow;
set(get(handle(gcf),'JavaFrame'),'Maximized',1);
pause(0.1);

alpha_vals = ones(size(imageStack,1),size(imageStack,2),size(imageStack,3));
alpha_vals(imageStack(:,:,:) / divide * 255 < 100) = 0.4;
alpha_vals(imageStack(:,:,:) / divide * 255 < 25) = 0;
for i = 1:size(imageStack,3) 
    set(zplanes(i),'FaceAlpha','texture','AlphaDataMapping','none','AlphaData',alpha_vals(:,:,i));
end

drawnow;
%%
[~,I] = sort(dist_median_res);
rowI = I(2,:);
[~,I] = sort(dist_median_res');
colI = I(2,:);
eq = rowI == colI;
names = {'Synap_1,'	'Synap_2,'	'VGlut1_1,'	'VGlut1_2,'	'VGlut2,'	'VGlut3,'	'PSD,'	'Glur2,'...
    'NMDAR,'	'NR2B,'	'GAD,'	'VGat,'	'PV,'	'Gephryn,'	'GABAR,'	'GABABR,'	'CR1,'	'5HT1A,'	'NOS,'	'TH,'...
    'VAChT,'	'Synpod,'	'Tubulin,'	'DAPI'};

[names{eq}]

