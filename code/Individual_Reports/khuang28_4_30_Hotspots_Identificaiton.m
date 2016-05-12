% for deriving and displaying the local max for each marker across all 41
% stacks
% only showing a few sample images due to the huge memory size of the
% output images.
%file directory : https://www.dropbox.com/sh/zijowsqbaojr37x/AACYiMFXrqTKdxifd37c9Aiya?dl=0
clc;
system('caffeinate -dims &');
stacks = {'A.tif', '-02-synapsinGP_5thA.tif', '-03-VGluT1_3rdA.tif', '-04-VGluT1_8thA.tif', '-05-VGluT2_2ndA.tif',...
    '-06-VGluT3_1stA.tif', '-07-psd_8thA.tif', '-08-GluR2_2ndA.tif', '-09-NMDAR1_6thA.tif', '-10-NR2B_9thA.tif'...
    '-11-GAD_6thA.tif', '-12-VGAT_5thA.tif'};
%stacks = {'A.tif', '-03-VGluT1_3rdA.tif', '-04-VGluT1_8thA.tif', ...
 %   '-06-VGluT3_1stA.tif', '-07-psd_8thA.tif', '-08-GluR2_2ndA.tif', '-09-NMDAR1_6thA.tif', '-10-NR2B_9thA.tif'...
 %   '-11-GAD_6thA.tif', '-12-VGAT_5thA.tif'};
stacks = { 'A.tif','-02-synapsinGP_5thA.tif', '-03-VGluT1_3rdA.tif', '-04-VGluT1_8thA.tif', '-05-VGluT2_2ndA.tif',...
    '-06-VGluT3_1stA.tif', '-07-psd_8thA.tif',  '-08-GluR2_2ndA.tif', '-09-NMDAR1_6thA.tif', '-10-NR2B_9thA.tif',...
    '-11-GAD_6thA.tif', '-12-VGAT_5thA.tif', '-13-PV_1stA.tif', '-14-gephyrin_1stA.tif', '-15-GABARa1_4thA.tif', '-16-GABABR1_3rdA.tif','-17-CR1_2ndA.tif' ...
    '-18-5HT1A_6th.tif', '-19-NOS_9thA.tif', '-20-TH_5thA.tif', '-21-VAChT_4thA.tif', '-22-Synpod_3rdA.tif', '-23-tubulin_8thA.tif', ...
    '-24-dapi_1stA (2).tif'};
%stacks = {'-15-GABARa1_4thA.tif', '-16-GABABR1_3rdA.tif'};


%first 3 stacks of the first 3 markers
pointss = {[], [], [], [], [], [],[], [], [], [], [], [], [], [], [], [], [], [],[], [], [], [], [], []};
l = 0;
parfor j = 1 : 24
    j
    file = stacks{j};
    Centers = [];
    disp(j)
for i = 1 : 41
    %counter for publishing purposes
    l = l + 1;
%read in each stack    
[X,map] = imread(file,i);
a = double(X(600:1500,300:1000));  
%a =   medfilt2(a, [3, 3]);
%a(a < median(a(:))) = 0;
a ( a <= mean(a(a>0)) ) = 0;
[rows, cols] = suppresion(a,15,mean(a(:)) + std2(a(a>0)) * 2);

pointss{j} = [pointss{j}; rows, cols, ones(numel(rows), 1) *i];
end



end

stack = 24;

[columnsInImage, rowsInImage] = meshgrid(1:700, 1:900);
pointsss = {[], [], [], [], [], [],[], [], [], [], [], [], [], [], [], [], [], [],[], [], [], [], [], []};
parfor i = 1 : stack
    i
    impose = [];
       
    for h = 1 : 41
        temp = zeros(900, 700);
        
        point = pointss{i};
        ppts = point(point(:,3) == h, 1:2);
        
        for pppt = 1 : numel(ppts) / 2
            pppppt = ppts(pppt, :);
            temp(pppppt(1), pppppt(2)) = 1;
        end
        
        
        impose(:, :, h) = temp;
        
    end
    
    for j = 1 : stack
        
        point = pointss{j};
        for h = 1: 41
            temp_point = point(point(:,3) == h, 1:2);
            temp = impose(:, :, h);
            temp_pointss = [];
            for k = 1 : numel(temp_point(:, 2))
                
                 
                 circlePixels = (rowsInImage - temp_point(k, 1)).^2 + (columnsInImage - temp_point(k, 2)).^2 <= 2.^2;
                 
                 temp_pointss = [temp_pointss; sum(sum(temp( circlePixels))), h, j]; 
                
            end
            
            pointsss{i} = [ pointsss{i}; temp_pointss];
            
        end
        
    end
    
end

channel = { 'synapsin1','synapsin2', 'vglut1-1', 'vglut-1-2', 'vglut2',...
    'vglut3', 'psd',  'glur2', 'nmdar1', 'nr2b',...
    'gad', 'vgat', 'pv', 'gephyrin', 'GABARa1-1', 'GABABR1-2','CR1' ...
    '5HT1A', 'NOS', 'TH', 'VAChT', 'Synpod', 'tubulin', ...
    'dapi'};

for i = 1 : 24
    destroy = pointsss{i}; 
    figure;
    
    count = 1;
    for j = 1 : 24
        temp = destroy(destroy(:,2) == j, 1); subplot(4, 6, count);
        histogram(temp,5); disp([i, j]); count = count + 1; 
        title(['Neighbor Hotspots from ',channel{j}]);
        ylabel('#of surrounding hotspots');
        xlabel('# of hotspots');
    end
    text(0.5, 1,['\bf Hospots from',channel{i}] ,'HorizontalAlignment', ... 
'center','VerticalAlignment', 'top')

end

close all;
channel = { 'synapsin1','synapsin2', 'vglut1-1', 'vglut-1-2', 'vglut2',...
'vglut3', 'psd',  'glur2', 'nmdar1', 'nr2b',...
'gad', 'vgat', 'pv', 'gephyrin', 'GABARa1-1', 'GABABR1-2','CR1' ...
'5HT1A', 'NOS', 'TH', 'VAChT', 'Synpod', 'tubulin', ...
'dapi'};
for i = 1 :24
destroy = pointsss{i};
figure('Position', [50, 50, 1200, 800]);

count = 1;

for j = 1 : 24
temp = destroy(destroy(:,2) == j, 1); subplot(6, 4, count);
[n, xout]  = hist(temp,5);
bar(xout, n, 'barwidth', 1, 'basevalue', 1);
set(gca,'YScale','log')
count = count + 1;
title(['Neighbor Peaks from ',channel{j}]);
ylabel('#of Neighbor Peaks');
xlabel('# of Peaks');
end
text(.001, 80000000000000000000000000000000000000000,['Hospots from ',channel{i}], 'FontSize',16)

end
