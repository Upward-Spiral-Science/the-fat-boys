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

for j = 1 : 6
    file = stacks{j};
   
    
    for i = 1 : 41
    
       
    
        %read in each stack    
        [X,map] = imread(file,i);
        a = imresize(X, .3);  
        h = fspecial('gaussian', [7,7], 2.5);
    
        % perform deconvolution
        [a,~] = deconvblind(a, h); 
        original = a;
        
        %apply unsharp mask
        a = imsharpen(a, 'Amount', 2, 'Threshold', .8);
    
        %apply sharp threshold 
        a =   medfilt2(a, [3, 3]);
        a(a < median(a(:))) = 0;
        a ( a <= mean(a(a>0)) + std2(a(a>0)) * 6) = 0;
        

        save([ num2str(j), '_', num2str(i)], 'a');
        
    end



end

