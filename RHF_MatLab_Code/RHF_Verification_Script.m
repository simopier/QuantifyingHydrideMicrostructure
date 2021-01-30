%-------------------------------------------------------------------------%
%                                                                         %
%       Script developed by Pierre-Clement A Simon and Cailon Frank       %
%       From Penn State University                                        %
%                                                                         %
%       Published in                                                      %
%           P.-C.A. Simon, C. Frank, L.-Q. Chen, M.R. Daymond, M.R. Tonks,%
%           A.T. Motta. Quantifying the effect of hydride microstructure  %
%           on zirconium alloys embrittlement using image analysis.       %
%           Journal of Nuclear Materials, 547 (2021) 152817               %
%   https://www.sciencedirect.com/science/article/pii/S0022311521000404   %
%                                                                         %
%       Full MATLAB Code available at:                                    %
%           https://github.com/simopier/QuantifyingHydrideMicrostructure  %
%                                                                         %
%-------------------------------------------------------------------------%

% Description:
% This is the script used to perform the verification of the RHF definition
% and implementation. This is not part of the algorithm.
% To reproduce the verification process, simply run this script. 
% It calls the function RHF_Verification.m to perform the analysis. 


% Clean workspace
close all
clear

% Warning message
disp('be aware that to properly run this code, a few changes should be made to RHF_file.m for the length of the cut to be expressed as a ratio. \n See RHF_file.m and un-comment the necessary lines.')
pause(5)

% Initialization
CodeFolder = 'RHF_MatLab_Code';

startingLowThreshold = 250;
startingHighThreshold = 500;
SpotSize = 0;
HoleSize = 0;
resolution = 1;
lengthCut = Inf;
lengthCut_vect = [5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100 200 300 400 500 600 700 800 900 1000];
lengthCut_ratio_vect = [ 0.025 0.05 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1];


color1 = [1 133 113]/255;
color1Fill = [128 205 193]/255;
color2 = [166 97 26]/255;
color2Fill = [223 194 125]/255;

color_grad_1 = [84 48 5]/255;
color_grad_2 = [140 81 10]/255;
color_grad_3 = [191 129 45]/255;
color_grad_4 = [223 194 125]/255;
color_grad_5 = [246 232 195]/255;
color_grad_6 = [199 234 229]/255;
color_grad_7 = [128 205 193]/255;
color_grad_8 = [53 151 143]/255;
color_grad_9 = [1 102 94]/255;
color_grad_10 = [0 60 48]/255;

colorFill_vect = [color_grad_1 ;color_grad_2 ;color_grad_3 ;color_grad_4 ;color_grad_5 ;color_grad_6 ;color_grad_7 ;color_grad_8 ;color_grad_9 ;color_grad_10];
color_vect     = [color_grad_1 ;color_grad_1 ;color_grad_2 ;color_grad_3 ;color_grad_4 ;color_grad_7 ;color_grad_8 ;color_grad_9 ;color_grad_10 ;color_grad_10];


folderName_Single = 'RHF_Verification_Single_Hydrides_Microstructure';
folderNameResults_Single = 'RHF_Verification_Single_Hydrides_Expected_Results';
fileNameResults_Single = 'RHF_Verification_Single_Images.csv';
resultsFolderName_Single = 'RHF_Verification_Single_Hydrides_Results';

folderName_Parallel = 'RHF_Verification_Parallel_Hydrides_Microstructure';
folderNameResults_Parallel = 'RHF_Verification_Parallel_Hydrides_Expected_Results';
fileNameResults_Parallel = 'RHF_Verification_Parallel_Images.csv';
resultsFolderName_Parallel = 'RHF_Verification_Parallel_Hydrides_Results';

folderName_Oriented = 'RHF_Verification_Oriented_Hydrides_Microstructure';
folderNameResults_Oriented = 'RHF_Verification_Oriented_Hydrides_Expected_Results';
fileNameResults_Oriented = 'RHF_Verification_Oriented_Images.csv';
resultsFolderName_Oriented = 'RHF_Verification_Oriented_Hydrides_Results';

folderName_Random = 'RHF_Verification_Random_Hydrides_Microstructure';
folderNameResults_Random = 'RHF_Verification_Random_Hydrides_Expected_Results';
fileNameResults_Random = 'RHF_Verification_Random_Images.csv';
resultsFolderName_Random = 'RHF_Verification_Random_Hydrides_Results';

folderName_Connected1 = 'RHF_Verification_Connected1_Hydrides_Microstructure';
folderNameResults_Connected1 = 'RHF_Verification_Connected1_Hydrides_Expected_Results';
fileNameResults_Connected1 = 'RHF_Verification_Connected1_Images.csv';
resultsFolderName_Connected1 = 'RHF_Verification_Connected1_Hydrides_Results';

folderName_Connected2 = 'RHF_Verification_Connected2_Hydrides_Microstructure';
folderNameResults_Connected2 = 'RHF_Verification_Connected2_Hydrides_Expected_Results';
fileNameResults_Connected2 = 'RHF_Verification_Connected2_Images.csv';
resultsFolderName_Connected2 = 'RHF_Verification_Connected2_Hydrides_Results';

folderName_Connected3 = 'RHF_Verification_Connected3_Hydrides_Microstructure';
folderNameResults_Connected3 = 'RHF_Verification_Connected3_Hydrides_Expected_Results';
fileNameResults_Connected3 = 'RHF_Verification_Connected3_Images.csv';
resultsFolderName_Connected3 = 'RHF_Verification_Connected3_Hydrides_Results';

% folderName_Connected4 = 'RHF_Verification_Connected4_Hydrides_Microstructure';
% folderNameResults_Connected4 = 'RHF_Verification_Connected4_Hydrides_Expected_Results';
% fileNameResults_Connected4 = 'RHF_Verification_Connected4_Images.csv';
% resultsFolderName_Connected4 = 'RHF_Verification_Connected4_Hydrides_Results';
% 
% folderName_Connected5 = 'RHF_Verification_Connected5_Hydrides_Microstructure';
% folderNameResults_Connected5 = 'RHF_Verification_Connected5_Hydrides_Expected_Results';
% fileNameResults_Connected5 = 'RHF_Verification_Connected5_Images.csv';
% resultsFolderName_Connected5 = 'RHF_Verification_Connected5_Hydrides_Results';
% 
% folderName_Connected6 = 'RHF_Verification_Connected6_Hydrides_Microstructure';
% folderNameResults_Connected6 = 'RHF_Verification_Connected6_Hydrides_Expected_Results';
% fileNameResults_Connected6 = 'RHF_Verification_Connected6_Images.csv';
% resultsFolderName_Connected6 = 'RHF_Verification_Connected6_Hydrides_Results';



%% Perform general verification
RHF_Verification( CodeFolder,folderName_Single,folderNameResults_Single,fileNameResults_Single,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution, lengthCut,resultsFolderName_Single)
RHF_Verification( CodeFolder,folderName_Parallel,folderNameResults_Parallel,fileNameResults_Parallel,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution, lengthCut,resultsFolderName_Parallel)
RHF_Verification( CodeFolder,folderName_Oriented,folderNameResults_Oriented,fileNameResults_Oriented,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution, lengthCut,resultsFolderName_Oriented)
RHF_Verification( CodeFolder,folderName_Random,folderNameResults_Random,fileNameResults_Random,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution, lengthCut,resultsFolderName_Random)



 %% Perform verification for lengthCut

%% Single hydrides %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:length(lengthCut_ratio_vect)
    RHF_Verification( CodeFolder,folderName_Single,folderNameResults_Single,fileNameResults_Single,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution, lengthCut_ratio_vect(i),[resultsFolderName_Single '_' num2str(i)])
    cd ../
    mkdir([resultsFolderName_Single '_' num2str(i+1)])
    copyfile([resultsFolderName_Single '_' num2str(i) '/' '1.tif_BinaryParam.csv'],[resultsFolderName_Single '_' num2str(i+1) '/' '1.tif_BinaryParam.csv'])
    cd(CodeFolder)
end
close
% Create figure
fig = figure;
hold on
sz = 100;
RHF_Measured = zeros(length(lengthCut_ratio_vect),10);
% RHF_Measured = [0,0.110380000000000,0.219650000000000,0.332760000000000,0.441810000000000,0.553220000000000,0.664990000000000,0.776060000000000,0.889180000000000,1;0,0.110910000000000,0.222000000000000,0.332400000000000,0.442440000000000,0.554290000000000,0.666000000000000,0.777330000000000,0.887750000000000,1;0,0.111470000000000,0.221440000000000,0.332460000000000,0.442900000000000,0.553710000000000,0.665710000000000,0.777020000000000,0.887410000000000,1;0,0.111270000000000,0.221640000000000,0.332530000000000,0.442920000000000,0.553890000000000,0.665510000000000,0.777110000000000,0.887680000000000,1;0,0.111090000000000,0.222140000000000,0.332590000000000,0.442960000000000,0.553850000000000,0.666140000000000,0.776030000000000,0.887710000000000,1;0,0.111070000000000,0.221690000000000,0.332480000000000,0.443010000000000,0.553880000000000,0.665650000000000,0.776930000000000,0.887620000000000,1;0,0.111130000000000,0.222050000000000,0.332480000000000,0.443230000000000,0.554180000000000,0.665600000000000,0.776070000000000,0.887450000000000,1;0,0.111040000000000,0.221620000000000,0.332450000000000,0.442990000000000,0.553830000000000,0.665610000000000,0.776940000000000,0.887550000000000,1;0,0.111080000000000,0.222050000000000,0.332460000000000,0.442990000000000,0.553870000000000,0.665630000000000,0.776170000000000,0.887650000000000,1;0,0.111080000000000,0.222010000000000,0.332500000000000,0.442970000000000,0.553830000000000,0.665660000000000,0.776170000000000,0.887650000000000,1;0,0.111040000000000,0.222040000000000,0.332460000000000,0.443020000000000,0.553900000000000,0.665590000000000,0.776070000000000,0.887540000000000,1;0,0.111050000000000,0.221650000000000,0.332450000000000,0.443010000000000,0.553890000000000,0.665580000000000,0.776940000000000,0.887580000000000,1;0,0.111140000000000,0.222020000000000,0.332470000000000,0.443210000000000,0.554200000000000,0.665620000000000,0.776080000000000,0.887450000000000,1;0,0.111050000000000,0.222050000000000,0.332470000000000,0.443040000000000,0.553880000000000,0.665600000000000,0.776080000000000,0.887610000000000,1;0,0.111090000000000,0.222050000000000,0.332510000000000,0.442970000000000,0.553840000000000,0.665650000000000,0.776180000000000,0.887630000000000,1;0,0.111040000000000,0.221670000000000,0.332460000000000,0.443010000000000,0.553860000000000,0.665590000000000,0.776980000000000,0.887530000000000,1;0,0.111050000000000,0.222040000000000,0.332460000000000,0.443000000000000,0.553860000000000,0.665560000000000,0.776140000000000,0.887550000000000,1;0,0.111080000000000,0.222050000000000,0.332510000000000,0.442970000000000,0.553850000000000,0.665650000000000,0.776180000000000,0.887620000000000,1;0,0.111020000000000,0.222210000000000,0.332650000000000,0.443030000000000,0.553860000000000,0.666090000000000,0.776080000000000,0.887540000000000,1;0,0.111050000000000,0.222040000000000,0.332450000000000,0.443000000000000,0.553860000000000,0.665580000000000,0.776150000000000,0.887520000000000,1;0,0.111050000000000,0.222040000000000,0.332460000000000,0.443010000000000,0.553850000000000,0.665590000000000,0.776150000000000,0.887530000000000,1;0,0.111030000000000,0.222040000000000,0.332460000000000,0.443020000000000,0.553860000000000,0.665590000000000,0.776110000000000,0.887560000000000,1;0,0.111060000000000,0.222040000000000,0.332470000000000,0.443010000000000,0.553850000000000,0.665590000000000,0.776150000000000,0.887530000000000,1;0,0.111030000000000,0.222030000000000,0.332460000000000,0.443020000000000,0.553860000000000,0.665580000000000,0.776130000000000,0.887550000000000,1;0,0.111030000000000,0.222030000000000,0.332460000000000,0.443020000000000,0.553860000000000,0.665580000000000,0.776130000000000,0.887550000000000,1;0,0.111030000000000,0.222030000000000,0.332460000000000,0.443020000000000,0.553860000000000,0.665580000000000,0.776130000000000,0.887550000000000,1;0,0.111030000000000,0.222030000000000,0.332460000000000,0.443020000000000,0.553860000000000,0.665580000000000,0.776130000000000,0.887550000000000,1;0,0.111030000000000,0.222030000000000,0.332460000000000,0.443020000000000,0.553860000000000,0.665580000000000,0.776130000000000,0.887550000000000,1;0,0.111030000000000,0.222030000000000,0.332460000000000,0.443020000000000,0.553860000000000,0.665580000000000,0.776130000000000,0.887550000000000,1];
cd ../
cd(folderNameResults_Single)
RHF_Expected = csvread(fileNameResults_Single,1, 1);
cd ../
cd(CodeFolder)
% plot(lengthCut_vect,RHF_Expected(1)*ones(length(lengthCut_vect),1),'k:','LineWidth',1)

for i=1:length(lengthCut_ratio_vect)
    cd ../
    cd([resultsFolderName_Single '_' num2str(i)])
    RHF_Measured(i,:) = csvread([folderName_Single '_results.csv'],1, 1);
    cd ../
    cd(CodeFolder)
    scatter(lengthCut_ratio_vect(i),abs(RHF_Measured(i,1)-RHF_Expected(1)),sz,'LineWidth',1,'MarkerEdgeColor',color_grad_1,'MarkerFaceColor',color_grad_1)
    scatter(lengthCut_ratio_vect(i),abs(RHF_Measured(i,2)-RHF_Expected(2)),sz,'LineWidth',1,'MarkerEdgeColor',color_grad_1,'MarkerFaceColor',color_grad_2)
    scatter(lengthCut_ratio_vect(i),abs(RHF_Measured(i,3)-RHF_Expected(3)),sz,'LineWidth',1,'MarkerEdgeColor',color_grad_2,'MarkerFaceColor',color_grad_3)
    scatter(lengthCut_ratio_vect(i),abs(RHF_Measured(i,4)-RHF_Expected(4)),sz,'LineWidth',1,'MarkerEdgeColor',color_grad_3,'MarkerFaceColor',color_grad_4)
    scatter(lengthCut_ratio_vect(i),abs(RHF_Measured(i,5)-RHF_Expected(5)),sz,'LineWidth',1,'MarkerEdgeColor',color_grad_4,'MarkerFaceColor',color_grad_5)
    scatter(lengthCut_ratio_vect(i),abs(RHF_Measured(i,6)-RHF_Expected(6)),sz,'LineWidth',1,'MarkerEdgeColor',color_grad_7,'MarkerFaceColor',color_grad_6)
    scatter(lengthCut_ratio_vect(i),abs(RHF_Measured(i,7)-RHF_Expected(7)),sz,'LineWidth',1,'MarkerEdgeColor',color_grad_8,'MarkerFaceColor',color_grad_7)
    scatter(lengthCut_ratio_vect(i),abs(RHF_Measured(i,8)-RHF_Expected(8)),sz,'LineWidth',1,'MarkerEdgeColor',color_grad_9,'MarkerFaceColor',color_grad_8)
    scatter(lengthCut_ratio_vect(i),abs(RHF_Measured(i,9)-RHF_Expected(9)),sz,'LineWidth',1,'MarkerEdgeColor',color_grad_10,'MarkerFaceColor',color_grad_9)
    scatter(lengthCut_ratio_vect(i),abs(RHF_Measured(i,10)-RHF_Expected(10)),sz,'LineWidth',1,'MarkerEdgeColor',color_grad_10,'MarkerFaceColor',color_grad_10)
    alpha(.4)
end

xlab=xlabel('$l_c$ / $l_H$','Interpreter','latex');
ylab=ylabel('RHF absolute error');
set([xlab,ylab],'fontsize',18)
legend('$\theta = 0$','$\theta = \frac{\pi}{18}$','$\theta = \frac{\pi}{9}$','$\theta = \frac{\pi}{6}$','$\theta = \frac{2\pi}{9}$','$\theta = \frac{5\pi}{18}$','$\theta = \frac{\pi}{3}$','$\theta = \frac{7\pi}{18}$','$\theta = \frac{4\pi}{9}$','$\theta = \frac{\pi}{2}$');
set([legend],'fontsize',16,'location', 'Northeast','Interpreter','latex','NumColumns',2)
% axis([0 1 0 2.7e-3])
opts.width      = 12;
opts.height     = 11;
opts.fontType   = 'Latex';
% scaling
fig.Units               = 'centimeters';
fig.Position(3)         = opts.width;
fig.Position(4)         = opts.height;
% remove unnecessary white space
set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
box on
% Export to PDF
set(gca,'units','centimeters')
set(gcf,'PaperUnits','centimeters');
set(gcf,'PaperSize',[opts.width opts.height]);
set(gcf,'PaperPositionMode','manual');
set(gcf,'PaperPosition',[0 0 opts.width opts.height]);
cd ../
cd([resultsFolderName_Single '_' num2str(i)])
saveas(gcf,[resultsFolderName_Single '_' num2str(i) '_cenvergence_lengthCut.pdf'])
cd ../
cd(CodeFolder)

%% Connected hydrides %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RHF_Measured = zeros(length(lengthCut_ratio_vect),3);
RHF_Expected = zeros(1,3);

%% Connected hydride 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% analysis
for i=1:length(lengthCut_ratio_vect)
    RHF_Verification( CodeFolder,folderName_Connected1,folderNameResults_Connected1,fileNameResults_Connected1,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution, lengthCut_ratio_vect(i),[resultsFolderName_Connected1 '_' num2str(i)])
    cd ../
    mkdir([resultsFolderName_Connected1 '_' num2str(i+1)])
    copyfile([resultsFolderName_Connected1 '_' num2str(i) '/' '1.tiff_BinaryParam.csv'],[resultsFolderName_Connected1 '_' num2str(i+1) '/' '1.tiff_BinaryParam.csv'])
    cd(CodeFolder)
end

% Upload expected results
cd ../
cd(folderNameResults_Connected1)
RHF_expected_both = csvread(fileNameResults_Connected1,1, 1);
RHF_Expected(1,1) = RHF_expected_both(1,1);
cd ../
cd(CodeFolder)

% read measurements
for i=1:length(lengthCut_ratio_vect)
    cd ../
    cd([resultsFolderName_Connected1 '_' num2str(i)])
    RHF_Measured(i,1) = csvread([folderName_Connected1 '_results.csv'],1, 1);
    cd ../
    cd(CodeFolder)
end

% % Create figure
% fig = figure;
% hold on
% sz = 60;
% 
% % plot on figure
% for i=1:length(lengthCut_ratio_vect)
%     scatter(lengthCut_ratio_vect(i),abs(RHF_Measured(i,1)-RHF_Expected(1,1)),sz,'LineWidth',1,'MarkerEdgeColor',color1,'MarkerFaceColor',color1Fill)
% end
% 
% % figure options and save
% xlab=xlabel('lengthCut');
% ylab=ylabel('RHF');
% set([xlab,ylab],'fontsize',18)
% % legend('$\theta = 0$','$\theta = \frac{\pi}{18}$','$\theta = \frac{\pi}{9}$','$\theta = \frac{\pi}{6}$','$\theta = \frac{2\pi}{9}$','$\theta = \frac{5\pi}{18}$','$\theta = \frac{\pi}{3}$','$\theta = \frac{7\pi}{18}$','$\theta = \frac{4\pi}{9}$','$\theta = \frac{\pi}{2}$');
% % set([legend],'fontsize',16,'location', 'Northeast','Interpreter','latex','NumColumns',2)
% % axis([0 1 0 2.7e-3])
% opts.width      = 20;
% opts.height     = 14;
% opts.fontType   = 'Latex';
% % scaling
% fig.Units               = 'centimeters';
% fig.Position(3)         = opts.width;
% fig.Position(4)         = opts.height;
% % remove unnecessary white space
% set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
% box on
% % Export to PDF
% set(gca,'units','centimeters')
% set(gcf,'PaperUnits','centimeters');
% set(gcf,'PaperSize',[opts.width opts.height]);
% set(gcf,'PaperPositionMode','manual');
% set(gcf,'PaperPosition',[0 0 opts.width opts.height]);
% cd ../
% cd([resultsFolderName_Connected1 '_' num2str(i)])
% saveas(gcf,[resultsFolderName_Connected1 '_' num2str(i) '_cenvergence_lengthCut.pdf'])
% cd ../
% cd(CodeFolder)



%% Connected hydride 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% analysis
for i=1:length(lengthCut_ratio_vect)
    RHF_Verification( CodeFolder,folderName_Connected2,folderNameResults_Connected2,fileNameResults_Connected2,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution, lengthCut_ratio_vect(i),[resultsFolderName_Connected2 '_' num2str(i)])
    cd ../
    mkdir([resultsFolderName_Connected2 '_' num2str(i+1)])
    copyfile([resultsFolderName_Connected2 '_' num2str(i) '/' '1.tiff_BinaryParam.csv'],[resultsFolderName_Connected2 '_' num2str(i+1) '/' '1.tiff_BinaryParam.csv'])
    cd(CodeFolder)
end

% Upload expected results
cd ../
cd(folderNameResults_Connected2)
RHF_expected_both = csvread(fileNameResults_Connected2,1, 1);
RHF_Expected(1,2) = RHF_expected_both(1,1);
cd ../
cd(CodeFolder)

% read measurements
for i=1:length(lengthCut_ratio_vect)
    cd ../
    cd([resultsFolderName_Connected2 '_' num2str(i)])
    RHF_Measured(i,2) = csvread([folderName_Connected2 '_results.csv'],1, 1);
    cd ../
    cd(CodeFolder)
end

% % Create figure
% fig = figure;
% hold on
% sz = 60;
% 
% % plot on figure
% for i=1:length(lengthCut_ratio_vect)
%     scatter(lengthCut_ratio_vect(i),abs(RHF_Measured(i,2)-RHF_Expected(1,2)),sz,'LineWidth',1,'MarkerEdgeColor',color1,'MarkerFaceColor',color1Fill)
% end
% 
% % figure options and save
% xlab=xlabel('lengthCut');
% ylab=ylabel('RHF');
% set([xlab,ylab],'fontsize',18)
% % legend('$\theta = 0$','$\theta = \frac{\pi}{18}$','$\theta = \frac{\pi}{9}$','$\theta = \frac{\pi}{6}$','$\theta = \frac{2\pi}{9}$','$\theta = \frac{5\pi}{18}$','$\theta = \frac{\pi}{3}$','$\theta = \frac{7\pi}{18}$','$\theta = \frac{4\pi}{9}$','$\theta = \frac{\pi}{2}$');
% % set([legend],'fontsize',16,'location', 'Northeast','Interpreter','latex','NumColumns',2)
% % axis([0 1 0 2.7e-3])
% opts.width      = 20;
% opts.height     = 14;
% opts.fontType   = 'Latex';
% % scaling
% fig.Units               = 'centimeters';
% fig.Position(3)         = opts.width;
% fig.Position(4)         = opts.height;
% % remove unnecessary white space
% set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
% box on
% % Export to PDF
% set(gca,'units','centimeters')
% set(gcf,'PaperUnits','centimeters');
% set(gcf,'PaperSize',[opts.width opts.height]);
% set(gcf,'PaperPositionMode','manual');
% set(gcf,'PaperPosition',[0 0 opts.width opts.height]);
% cd ../
% cd([resultsFolderName_Connected2 '_' num2str(i)])
% saveas(gcf,[resultsFolderName_Connected2 '_' num2str(i) '_cenvergence_lengthCut.pdf'])
% cd ../
% cd(CodeFolder)




%% Connected hydride 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% analysis
for i=1:length(lengthCut_ratio_vect)
    RHF_Verification( CodeFolder,folderName_Connected3,folderNameResults_Connected3,fileNameResults_Connected3,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution, lengthCut_ratio_vect(i),[resultsFolderName_Connected3 '_' num2str(i)])
    cd ../
    mkdir([resultsFolderName_Connected3 '_' num2str(i+1)])
    copyfile([resultsFolderName_Connected3 '_' num2str(i) '/' '1.tiff_BinaryParam.csv'],[resultsFolderName_Connected3 '_' num2str(i+1) '/' '1.tiff_BinaryParam.csv'])
    cd(CodeFolder)
end

% Upload expected results
cd ../
cd(folderNameResults_Connected3)
RHF_expected_both = csvread(fileNameResults_Connected3,1, 1);
RHF_Expected(1,3) = RHF_expected_both(1,1);
cd ../
cd(CodeFolder)

% read measurements
for i=1:length(lengthCut_ratio_vect)
    cd ../
    cd([resultsFolderName_Connected3 '_' num2str(i)])
    RHF_Measured(i,3) = csvread([folderName_Connected3 '_results.csv'],1, 1);
    cd ../
    cd(CodeFolder)
end

% % Create figure
% fig = figure;
% hold on
% sz = 60;
% 
% % plot on figure
% for i=1:length(lengthCut_ratio_vect)
%     scatter(lengthCut_ratio_vect(i),abs(RHF_Measured(i,3)-RHF_Expected(1,3)),sz,'LineWidth',1,'MarkerEdgeColor',color1,'MarkerFaceColor',color1Fill)
% end
% 
% % figure options and save
% xlab=xlabel('lengthCut');
% ylab=ylabel('RHF');
% set([xlab,ylab],'fontsize',18)
% % legend('$\theta = 0$','$\theta = \frac{\pi}{18}$','$\theta = \frac{\pi}{9}$','$\theta = \frac{\pi}{6}$','$\theta = \frac{2\pi}{9}$','$\theta = \frac{5\pi}{18}$','$\theta = \frac{\pi}{3}$','$\theta = \frac{7\pi}{18}$','$\theta = \frac{4\pi}{9}$','$\theta = \frac{\pi}{2}$');
% % set([legend],'fontsize',16,'location', 'Northeast','Interpreter','latex','NumColumns',2)
% % axis([0 1 0 2.7e-3])
% opts.width      = 20;
% opts.height     = 14;
% opts.fontType   = 'Latex';
% % scaling
% fig.Units               = 'centimeters';
% fig.Position(3)         = opts.width;
% fig.Position(4)         = opts.height;
% % remove unnecessary white space
% set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
% box on
% % Export to PDF
% set(gca,'units','centimeters')
% set(gcf,'PaperUnits','centimeters');
% set(gcf,'PaperSize',[opts.width opts.height]);
% set(gcf,'PaperPositionMode','manual');
% set(gcf,'PaperPosition',[0 0 opts.width opts.height]);
% cd ../
% cd([resultsFolderName_Connected3 '_' num2str(i)])
% saveas(gcf,[resultsFolderName_Connected3 '_' num2str(i) '_cenvergence_lengthCut.pdf'])
% cd ../
% cd(CodeFolder)


% %% Connected hydride 4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % analysis
% for i=1:length(lengthCut_ratio_vect)
%     RHF_Verification( CodeFolder,folderName_Connected4,folderNameResults_Connected4,fileNameResults_Connected4,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution, lengthCut_ratio_vect(i),[resultsFolderName_Connected4 '_' num2str(i)])
%     cd ../
%     mkdir([resultsFolderName_Connected4 '_' num2str(i+1)])
%     copyfile([resultsFolderName_Connected4 '_' num2str(i) '/' '1.tiff_BinaryParam.csv'],[resultsFolderName_Connected4 '_' num2str(i+1) '/' '1.tiff_BinaryParam.csv'])
%     cd(CodeFolder)
% end
% 
% % Upload expected results
% cd ../
% cd(folderNameResults_Connected4)
% RHF_expected_both = csvread(fileNameResults_Connected4,1, 1);
% RHF_Expected(1,4) = RHF_expected_both(1,1);
% cd ../
% cd(CodeFolder)
% 
% % read measurements
% for i=1:length(lengthCut_ratio_vect)
%     cd ../
%     cd([resultsFolderName_Connected4 '_' num2str(i)])
%     RHF_Measured(i,4) = csvread([folderName_Connected4 '_results.csv'],1, 1);
%     cd ../
%     cd(CodeFolder)
% end
% 
% % % Create figure
% % fig = figure;
% % hold on
% % sz = 60;
% % 
% % % plot on figure
% % for i=1:length(lengthCut_ratio_vect)
% %     scatter(lengthCut_ratio_vect(i),abs(RHF_Measured(i,4)-RHF_Expected(1,4)),sz,'LineWidth',1,'MarkerEdgeColor',color1,'MarkerFaceColor',color1Fill)
% % end
% % 
% % % figure options and save
% % xlab=xlabel('lengthCut');
% % ylab=ylabel('RHF');
% % set([xlab,ylab],'fontsize',18)
% % % legend('$\theta = 0$','$\theta = \frac{\pi}{18}$','$\theta = \frac{\pi}{9}$','$\theta = \frac{\pi}{6}$','$\theta = \frac{2\pi}{9}$','$\theta = \frac{5\pi}{18}$','$\theta = \frac{\pi}{3}$','$\theta = \frac{7\pi}{18}$','$\theta = \frac{4\pi}{9}$','$\theta = \frac{\pi}{2}$');
% % % set([legend],'fontsize',16,'location', 'Northeast','Interpreter','latex','NumColumns',2)
% % % axis([0 1 0 2.7e-3])
% % opts.width      = 20;
% % opts.height     = 14;
% % opts.fontType   = 'Latex';
% % % scaling
% % fig.Units               = 'centimeters';
% % fig.Position(3)         = opts.width;
% % fig.Position(4)         = opts.height;
% % % remove unnecessary white space
% % set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
% % box on
% % % Export to PDF
% % set(gca,'units','centimeters')
% % set(gcf,'PaperUnits','centimeters');
% % set(gcf,'PaperSize',[opts.width opts.height]);
% % set(gcf,'PaperPositionMode','manual');
% % set(gcf,'PaperPosition',[0 0 opts.width opts.height]);
% % cd ../
% % cd([resultsFolderName_Connected4 '_' num2str(i)])
% % saveas(gcf,[resultsFolderName_Connected4 '_' num2str(i) '_cenvergence_lengthCut.pdf'])
% % cd ../
% % cd(CodeFolder)
% 
% %% Connected hydride 5 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % analysis
% for i=1:length(lengthCut_ratio_vect)
%     RHF_Verification( CodeFolder,folderName_Connected5,folderNameResults_Connected5,fileNameResults_Connected5,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution, lengthCut_ratio_vect(i),[resultsFolderName_Connected5 '_' num2str(i)])
%     cd ../
%     mkdir([resultsFolderName_Connected5 '_' num2str(i+1)])
%     copyfile([resultsFolderName_Connected5 '_' num2str(i) '/' '1.tiff_BinaryParam.csv'],[resultsFolderName_Connected5 '_' num2str(i+1) '/' '1.tiff_BinaryParam.csv'])
%     cd(CodeFolder)
% end
% 
% % Upload expected results
% cd ../
% cd(folderNameResults_Connected5)
% RHF_expected_both = csvread(fileNameResults_Connected5,1, 1);
% RHF_Expected(1,5) = RHF_expected_both(1,1);
% cd ../
% cd(CodeFolder)
% 
% % read measurements
% for i=1:length(lengthCut_ratio_vect)
%     cd ../
%     cd([resultsFolderName_Connected5 '_' num2str(i)])
%     RHF_Measured(i,5) = csvread([folderName_Connected5 '_results.csv'],1, 1);
%     cd ../
%     cd(CodeFolder)
% end
% 
% % % Create figure
% % fig = figure;
% % hold on
% % sz = 60;
% % 
% % % plot on figure
% % for i=1:length(lengthCut_ratio_vect)
% %     scatter(lengthCut_ratio_vect(i),abs(RHF_Measured(i,5)-RHF_Expected(1,5)),sz,'LineWidth',1,'MarkerEdgeColor',color1,'MarkerFaceColor',color1Fill)
% % end
% % 
% % % figure options and save
% % xlab=xlabel('lengthCut');
% % ylab=ylabel('RHF');
% % set([xlab,ylab],'fontsize',18)
% % % legend('$\theta = 0$','$\theta = \frac{\pi}{18}$','$\theta = \frac{\pi}{9}$','$\theta = \frac{\pi}{6}$','$\theta = \frac{2\pi}{9}$','$\theta = \frac{5\pi}{18}$','$\theta = \frac{\pi}{3}$','$\theta = \frac{7\pi}{18}$','$\theta = \frac{4\pi}{9}$','$\theta = \frac{\pi}{2}$');
% % % set([legend],'fontsize',16,'location', 'Northeast','Interpreter','latex','NumColumns',2)
% % % axis([0 1 0 2.7e-3])
% % opts.width      = 20;
% % opts.height     = 14;
% % opts.fontType   = 'Latex';
% % % scaling
% % fig.Units               = 'centimeters';
% % fig.Position(3)         = opts.width;
% % fig.Position(4)         = opts.height;
% % % remove unnecessary white space
% % set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
% % box on
% % % Export to PDF
% % set(gca,'units','centimeters')
% % set(gcf,'PaperUnits','centimeters');
% % set(gcf,'PaperSize',[opts.width opts.height]);
% % set(gcf,'PaperPositionMode','manual');
% % set(gcf,'PaperPosition',[0 0 opts.width opts.height]);
% % cd ../
% % cd([resultsFolderName_Connected5 '_' num2str(i)])
% % saveas(gcf,[resultsFolderName_Connected5 '_' num2str(i) '_cenvergence_lengthCut.pdf'])
% % cd ../
% % cd(CodeFolder)
% 
% 
% %% Connected hydride 6 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % analysis
% for i=1:length(lengthCut_ratio_vect)
%     RHF_Verification( CodeFolder,folderName_Connected6,folderNameResults_Connected6,fileNameResults_Connected6,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution, lengthCut_ratio_vect(i),[resultsFolderName_Connected6 '_' num2str(i)])
%     cd ../
%     mkdir([resultsFolderName_Connected6 '_' num2str(i+1)])
%     copyfile([resultsFolderName_Connected6 '_' num2str(i) '/' '1.tiff_BinaryParam.csv'],[resultsFolderName_Connected6 '_' num2str(i+1) '/' '1.tiff_BinaryParam.csv'])
%     cd(CodeFolder)
% end
% 
% % Upload expected results
% cd ../
% cd(folderNameResults_Connected6)
% RHF_expected_both = csvread(fileNameResults_Connected6,1, 1);
% RHF_Expected(1,6) = RHF_expected_both(1,1);
% cd ../
% cd(CodeFolder)
% 
% % read measurements
% for i=1:length(lengthCut_ratio_vect)
%     cd ../
%     cd([resultsFolderName_Connected6 '_' num2str(i)])
%     RHF_Measured(i,6) = csvread([folderName_Connected6 '_results.csv'],1, 1);
%     cd ../
%     cd(CodeFolder)
% end
% 
% % % Create figure
% % fig = figure;
% % hold on
% % sz = 60;
% % 
% % % plot on figure
% % for i=1:length(lengthCut_ratio_vect)
% %     scatter(lengthCut_ratio_vect(i),abs(RHF_Measured(i,6)-RHF_Expected(1,6)),sz,'LineWidth',1,'MarkerEdgeColor',color1,'MarkerFaceColor',color1Fill)
% % end
% % 
% % % figure options and save
% % xlab=xlabel('lengthCut');
% % ylab=ylabel('RHF');
% % set([xlab,ylab],'fontsize',18)
% % % legend('$\theta = 0$','$\theta = \frac{\pi}{18}$','$\theta = \frac{\pi}{9}$','$\theta = \frac{\pi}{6}$','$\theta = \frac{2\pi}{9}$','$\theta = \frac{5\pi}{18}$','$\theta = \frac{\pi}{3}$','$\theta = \frac{7\pi}{18}$','$\theta = \frac{4\pi}{9}$','$\theta = \frac{\pi}{2}$');
% % % set([legend],'fontsize',16,'location', 'Northeast','Interpreter','latex','NumColumns',2)
% % % axis([0 1 0 2.7e-3])
% % opts.width      = 20;
% % opts.height     = 14;
% % opts.fontType   = 'Latex';
% % % scaling
% % fig.Units               = 'centimeters';
% % fig.Position(3)         = opts.width;
% % fig.Position(4)         = opts.height;
% % % remove unnecessary white space
% % set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
% % box on
% % % Export to PDF
% % set(gca,'units','centimeters')
% % set(gcf,'PaperUnits','centimeters');
% % set(gcf,'PaperSize',[opts.width opts.height]);
% % set(gcf,'PaperPositionMode','manual');
% % set(gcf,'PaperPosition',[0 0 opts.width opts.height]);
% % cd ../
% % cd([resultsFolderName_Connected6 '_' num2str(i)])
% % saveas(gcf,[resultsFolderName_Connected6 '_' num2str(i) '_cenvergence_lengthCut.pdf'])
% % cd ../
% % cd(CodeFolder)


%% Connected hydrides %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create figure
fig = figure;
hold on
sz = 100;

% plot on figure
for j=1:3 % go through all connected hydrides
%     for i=1:length(lengthCut_ratio_vect)
    scatter(lengthCut_ratio_vect(:),abs(RHF_Measured(:,j)-RHF_Expected(1,j)),sz,'LineWidth',1,'MarkerEdgeColor',color_vect(end-j,:),'MarkerFaceColor',colorFill_vect(end-j,:),'DisplayName',['Microstructure 4.' num2str(j)])
%     end
end

% figure options and save
xlab=xlabel('$l_c$ / $l_H$','Interpreter','latex');
ylab=ylabel('RHF absolute error');
set([xlab,ylab],'fontsize',18)
% legend('1','2','3','4','5','6');
legend
set([legend],'fontsize',16,'location', 'NorthWest','Interpreter','latex') %,'NumColumns',2)
% axis([0 1 0 2.7e-3])
opts.width      = 12;
opts.height     = 11;
opts.fontType   = 'Latex';
% scaling
fig.Units               = 'centimeters';
fig.Position(3)         = opts.width;
fig.Position(4)         = opts.height;
% remove unnecessary white space
set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
box on
% Export to PDF
set(gca,'units','centimeters')
set(gcf,'PaperUnits','centimeters');
set(gcf,'PaperSize',[opts.width opts.height]);
set(gcf,'PaperPositionMode','manual');
set(gcf,'PaperPosition',[0 0 opts.width opts.height]);
cd ../
% cd([resultsFolderName_Connected1 '_' num2str(i)])
saveas(gcf,['RHF_Verification_Connected_Hydrides_Results' '_cenvergence_lengthCut.pdf'])
cd(CodeFolder)