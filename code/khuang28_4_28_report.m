clc
close all
stacks = { '-02-synapsinGP_5thA.tif', '-03-VGluT1_3rdA.tif', '-04-VGluT1_8thA.tif', ...
    '-06-VGluT3_1stA.tif',...
    '-11-GAD_6thA.tif', '-12-VGAT_5thA.tif'};
compare = '3_';
for j = 1 : 6
    file = [num2str(j), '_'];
    
    
    tPearson = [];
    tSpearman = [];
    tMandel = [];
    for i = 1 : 41
    
            X = load([file, num2str(i), '.mat']);
            X = X.a;
            Y = load([compare, num2str(i), '.mat']);
            Y = Y.a;
        if sum(sum(X)) ~= 0 && sum(sum(Y)) ~= 0
            %read in each stack    
            
            tPearson(i) = sum(sum((X - mean2(X)) .* (Y - mean2(Y))))  / sqrt(sum(sum((X - mean2(X)).^2 )) * sum(sum((Y - mean2(Y)).^2 )));
            tSpearman(i) = sum(sum( X .* Y))  / sqrt(sum(sum(X.^2)) * sum(sum(Y.^2))   );
            temp = X .* Y;
            tMandel(i) = sum(sum (X(temp > 0))) / sum(sum(X));
        else
             tPearson(i) = 0;
             tSpearman(i) = 0;
             tMandel(i) = 0;
        end
    end

    ay = 1 : 41;
    figure
    plot(ay, log(tPearson),  'b*',ay, log(tSpearman),  'g*', ay, log(tMandel),  'r*')
    legend('Pearson ', 'Spearman', 'Mandel ') 
    xlabel('Stack #')
    ylabel('Correlation - log')
    title([stacks(j), ' vs ', stacks(3)]);
    hold off;

end
