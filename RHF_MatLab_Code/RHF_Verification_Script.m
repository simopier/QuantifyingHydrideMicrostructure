%-------------------------------------------------------------------------%
%                                                                         %
%       Script developed by Pierre-Clement A Simon and Cailon Frank       %
%       From Penn State University                                        %
%                                                                         %
%       Published in                                                      %
%           Quantifying zirconium embrittlement due to hydride            %
%           microstructure using image analysis                           %
%           https:// ...                                                  %
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

% Initialization
CodeFolder = 'RHF_MatLab_Code';

startingLowThreshold = 250;
startingHighThreshold = 500;
SpotSize = 0;
HoleSize = 0;
resolution = 1;
lengthCut = Inf;
lengthCut_vect = [5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100 200 300 400 500 600 700 800 900 1000];

color1 = [1 133 113]/255;
color1Fill = [128 205 193]/255;
color2 = [166 97 26]/255;
color2Fill = [223 194 125]/255;

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

folderName_Connected4 = 'RHF_Verification_Connected4_Hydrides_Microstructure';
folderNameResults_Connected4 = 'RHF_Verification_Connected4_Hydrides_Expected_Results';
fileNameResults_Connected4 = 'RHF_Verification_Connected4_Images.csv';
resultsFolderName_Connected4 = 'RHF_Verification_Connected4_Hydrides_Results';

folderName_Connected5 = 'RHF_Verification_Connected5_Hydrides_Microstructure';
folderNameResults_Connected5 = 'RHF_Verification_Connected5_Hydrides_Expected_Results';
fileNameResults_Connected5 = 'RHF_Verification_Connected5_Images.csv';
resultsFolderName_Connected5 = 'RHF_Verification_Connected5_Hydrides_Results';

folderName_Connected6 = 'RHF_Verification_Connected6_Hydrides_Microstructure';
folderNameResults_Connected6 = 'RHF_Verification_Connected6_Hydrides_Expected_Results';
fileNameResults_Connected6 = 'RHF_Verification_Connected6_Images.csv';
resultsFolderName_Connected6 = 'RHF_Verification_Connected6_Hydrides_Results';



%% Perform general verification
RHF_Verification( CodeFolder,folderName_Single,folderNameResults_Single,fileNameResults_Single,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution, lengthCut,resultsFolderName_Single)
RHF_Verification( CodeFolder,folderName_Parallel,folderNameResults_Parallel,fileNameResults_Parallel,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution, lengthCut,resultsFolderName_Parallel)
RHF_Verification( CodeFolder,folderName_Oriented,folderNameResults_Oriented,fileNameResults_Oriented,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution, lengthCut,resultsFolderName_Oriented)
RHF_Verification( CodeFolder,folderName_Random,folderNameResults_Random,fileNameResults_Random,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution, lengthCut,resultsFolderName_Random)



 %% Perform verification for lengthCut

%% Single hydrides %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:length(lengthCut_vect)
    RHF_Verification( CodeFolder,folderName_Single,folderNameResults_Single,fileNameResults_Single,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution, lengthCut_vect(i),[resultsFolderName_Single '_' num2str(i)])
    cd ../
    mkdir([resultsFolderName_Single '_' num2str(i+1)])
    copyfile([resultsFolderName_Single '_' num2str(i) '/' '1.tif_BinaryParam.csv'],[resultsFolderName_Single '_' num2str(i+1) '/' '1.tif_BinaryParam.csv'])
    cd(CodeFolder)
end
close
% Create figure
fig = figure;
hold on
sz = 60;
RHF_Measured = zeros(length(lengthCut_vect),10);
cd ../
cd(folderNameResults_Single)
RHF_Expected = csvread(fileNameResults_Single,1, 1);
cd ../
cd(CodeFolder)
plot(lengthCut_vect,RHF_Expected(1)*ones(length(lengthCut_vect),1),'k:','LineWidth',1)

for i=1:length(lengthCut_vect)
    cd ../
    cd([resultsFolderName_Single '_' num2str(i)])
    RHF_Measured(i,:) = csvread([folderName_Single '_results.csv'],1, 1);
    cd ../
    cd(CodeFolder)
    scatter(lengthCut_vect(i),abs(RHF_Measured(i,1)-RHF_Expected(1)),sz,'LineWidth',1,'MarkerEdgeColor',color1,'MarkerFaceColor',color1Fill)
    scatter(lengthCut_vect(i),abs(RHF_Measured(i,2)-RHF_Expected(2)),sz,'LineWidth',1,'MarkerEdgeColor',color1,'MarkerFaceColor',color1Fill)
    scatter(lengthCut_vect(i),abs(RHF_Measured(i,3)-RHF_Expected(3)),sz,'LineWidth',1,'MarkerEdgeColor',color1,'MarkerFaceColor',color1Fill)
    scatter(lengthCut_vect(i),abs(RHF_Measured(i,4)-RHF_Expected(4)),sz,'LineWidth',1,'MarkerEdgeColor',color1,'MarkerFaceColor',color1Fill)
    scatter(lengthCut_vect(i),abs(RHF_Measured(i,5)-RHF_Expected(5)),sz,'LineWidth',1,'MarkerEdgeColor',color1,'MarkerFaceColor',color1Fill)
    scatter(lengthCut_vect(i),abs(RHF_Measured(i,6)-RHF_Expected(6)),sz,'LineWidth',1,'MarkerEdgeColor',color1,'MarkerFaceColor',color1Fill)
    scatter(lengthCut_vect(i),abs(RHF_Measured(i,7)-RHF_Expected(7)),sz,'LineWidth',1,'MarkerEdgeColor',color1,'MarkerFaceColor',color1Fill)
    scatter(lengthCut_vect(i),abs(RHF_Measured(i,8)-RHF_Expected(8)),sz,'LineWidth',1,'MarkerEdgeColor',color1,'MarkerFaceColor',color1Fill)
    scatter(lengthCut_vect(i),abs(RHF_Measured(i,9)-RHF_Expected(9)),sz,'LineWidth',1,'MarkerEdgeColor',color1,'MarkerFaceColor',color1Fill)
    scatter(lengthCut_vect(i),abs(RHF_Measured(i,10)-RHF_Expected(10)),sz,'LineWidth',1,'MarkerEdgeColor',color1,'MarkerFaceColor',color1Fill)
end

xlab=xlabel('lengthCut');
ylab=ylabel('RHF');
set([xlab,ylab],'fontsize',18)
%legend({num2str(lengthCut_vect(:))})
%set([legend],'fontsize',18,'location', 'NorthWest')
opts.width      = 20;
opts.height     = 14;
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

%% Connected hydride 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% analysis
for i=1:length(lengthCut_vect)
    RHF_Verification( CodeFolder,folderName_Connected1,folderNameResults_Connected1,fileNameResults_Connected1,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution, lengthCut_vect(i),[resultsFolderName_Connected1 '_' num2str(i)])
    cd ../
    mkdir([resultsFolderName_Connected1 '_' num2str(i+1)])
    copyfile([resultsFolderName_Connected1 '_' num2str(i) '/' '1.tif_BinaryParam.csv'],[resultsFolderName_Connected1 '_' num2str(i+1) '/' '1.tif_BinaryParam.csv'])
    cd(CodeFolder)
end
close
% Create figure
fig = figure;
hold on
sz = 60;
RHF_Measured = zeros(length(lengthCut_vect),1);
cd ../
cd(folderNameResults_Connected1)
RHF_Expected = csvread(fileNameResults_Connected1,1, 1);
cd ../
cd(CodeFolder)
plot(lengthCut_vect,RHF_Expected(1)*ones(length(lengthCut_vect),1),'k:','LineWidth',1)

for i=1:length(lengthCut_vect)
    cd ../
    cd([resultsFolderName_Connected1 '_' num2str(i)])
    RHF_Measured(i) = csvread([folderName_Connected1 '_results.csv'],1, 1);
    cd ../
    cd(CodeFolder)
    scatter(lengthCut_vect(i),abs(RHF_Measured(i)-RHF_Expected(1)),sz,'LineWidth',1,'MarkerEdgeColor',color1,'MarkerFaceColor',color1Fill)
end

xlab=xlabel('lengthCut');
ylab=ylabel('RHF');
set([xlab,ylab],'fontsize',18)
%legend({num2str(lengthCut_vect(:))})
%set([legend],'fontsize',18,'location', 'NorthWest')
opts.width      = 20;
opts.height     = 14;
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
cd([resultsFolderName_Connected1 '_' num2str(i)])
saveas(gcf,[resultsFolderName_Connected1 '_' num2str(i) '_cenvergence_lengthCut.pdf'])
cd ../
cd(CodeFolder)

%% Connected hydride 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% analysis
for i=1:length(lengthCut_vect)
    RHF_Verification( CodeFolder,folderName_Connected2,folderNameResults_Connected2,fileNameResults_Connected2,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution, lengthCut_vect(i),[resultsFolderName_Connected2 '_' num2str(i)])
    cd ../
    mkdir([resultsFolderName_Connected2 '_' num2str(i+1)])
    copyfile([resultsFolderName_Connected2 '_' num2str(i) '/' '1.tif_BinaryParam.csv'],[resultsFolderName_Connected2 '_' num2str(i+1) '/' '1.tif_BinaryParam.csv'])
    cd(CodeFolder)
end
close
% Create figure
fig = figure;
hold on
sz = 60;
RHF_Measured = zeros(length(lengthCut_vect),1);
cd ../
cd(folderNameResults_Connected2)
RHF_Expected = csvread(fileNameResults_Connected2,1, 1);
cd ../
cd(CodeFolder)
plot(lengthCut_vect,RHF_Expected(1)*ones(length(lengthCut_vect),1),'k:','LineWidth',1)

for i=1:length(lengthCut_vect)
    cd ../
    cd([resultsFolderName_Connected2 '_' num2str(i)])
    RHF_Measured(i) = csvread([folderName_Connected2 '_results.csv'],1, 1);
    cd ../
    cd(CodeFolder)
    scatter(lengthCut_vect(i),abs(RHF_Measured(i)-RHF_Expected(1)),sz,'LineWidth',1,'MarkerEdgeColor',color1,'MarkerFaceColor',color1Fill)
end

xlab=xlabel('lengthCut');
ylab=ylabel('RHF');
set([xlab,ylab],'fontsize',18)
%legend({num2str(lengthCut_vect(:))})
%set([legend],'fontsize',18,'location', 'NorthWest')
opts.width      = 20;
opts.height     = 14;
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
cd([resultsFolderName_Connected2 '_' num2str(i)])
saveas(gcf,[resultsFolderName_Connected2 '_' num2str(i) '_cenvergence_lengthCut.pdf'])
cd ../
cd(CodeFolder)




%% Connected hydride 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% analysis
for i=1:length(lengthCut_vect)
    RHF_Verification( CodeFolder,folderName_Connected3,folderNameResults_Connected3,fileNameResults_Connected3,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution, lengthCut_vect(i),[resultsFolderName_Connected3 '_' num2str(i)])
    cd ../
    mkdir([resultsFolderName_Connected3 '_' num2str(i+1)])
    copyfile([resultsFolderName_Connected3 '_' num2str(i) '/' '1.tif_BinaryParam.csv'],[resultsFolderName_Connected3 '_' num2str(i+1) '/' '1.tif_BinaryParam.csv'])
    cd(CodeFolder)
end
close
% Create figure
fig = figure;
hold on
sz = 60;
RHF_Measured = zeros(length(lengthCut_vect),1);
cd ../
cd(folderNameResults_Connected3)
RHF_Expected = csvread(fileNameResults_Connected3,1, 1);
cd ../
cd(CodeFolder)
plot(lengthCut_vect,RHF_Expected(1)*ones(length(lengthCut_vect),1),'k:','LineWidth',1)

for i=1:length(lengthCut_vect)
    cd ../
    cd([resultsFolderName_Connected3 '_' num2str(i)])
    RHF_Measured(i) = csvread([folderName_Connected3 '_results.csv'],1, 1);
    cd ../
    cd(CodeFolder)
    scatter(lengthCut_vect(i),abs(RHF_Measured(i)-RHF_Expected(1)),sz,'LineWidth',1,'MarkerEdgeColor',color1,'MarkerFaceColor',color1Fill)
end

xlab=xlabel('lengthCut');
ylab=ylabel('RHF');
set([xlab,ylab],'fontsize',18)
%legend({num2str(lengthCut_vect(:))})
%set([legend],'fontsize',18,'location', 'NorthWest')
opts.width      = 20;
opts.height     = 14;
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
cd([resultsFolderName_Connected3 '_' num2str(i)])
saveas(gcf,[resultsFolderName_Connected3 '_' num2str(i) '_cenvergence_lengthCut.pdf'])
cd ../
cd(CodeFolder)


%% Connected hydride 4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% analysis
for i=1:length(lengthCut_vect)
    RHF_Verification( CodeFolder,folderName_Connected4,folderNameResults_Connected4,fileNameResults_Connected4,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution, lengthCut_vect(i),[resultsFolderName_Connected4 '_' num2str(i)])
    cd ../
    mkdir([resultsFolderName_Connected4 '_' num2str(i+1)])
    copyfile([resultsFolderName_Connected4 '_' num2str(i) '/' '1.tif_BinaryParam.csv'],[resultsFolderName_Connected4 '_' num2str(i+1) '/' '1.tif_BinaryParam.csv'])
    cd(CodeFolder)
end
close
% Create figure
fig = figure;
hold on
sz = 60;
RHF_Measured = zeros(length(lengthCut_vect),1);
cd ../
cd(folderNameResults_Connected4)
RHF_Expected = csvread(fileNameResults_Connected4,1, 1);
cd ../
cd(CodeFolder)
plot(lengthCut_vect,RHF_Expected(1)*ones(length(lengthCut_vect),1),'k:','LineWidth',1)

for i=1:length(lengthCut_vect)
    cd ../
    cd([resultsFolderName_Connected4 '_' num2str(i)])
    RHF_Measured(i) = csvread([folderName_Connected4 '_results.csv'],1, 1);
    cd ../
    cd(CodeFolder)
    scatter(lengthCut_vect(i),abs(RHF_Measured(i)-RHF_Expected(1)),sz,'LineWidth',1,'MarkerEdgeColor',color1,'MarkerFaceColor',color1Fill)
end

xlab=xlabel('lengthCut');
ylab=ylabel('RHF');
set([xlab,ylab],'fontsize',18)
%legend({num2str(lengthCut_vect(:))})
%set([legend],'fontsize',18,'location', 'NorthWest')
opts.width      = 20;
opts.height     = 14;
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
cd([resultsFolderName_Connected4 '_' num2str(i)])
saveas(gcf,[resultsFolderName_Connected4 '_' num2str(i) '_cenvergence_lengthCut.pdf'])
cd ../
cd(CodeFolder)


%% Connected hydride 5 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% analysis
for i=1:length(lengthCut_vect)
    RHF_Verification( CodeFolder,folderName_Connected5,folderNameResults_Connected5,fileNameResults_Connected5,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution, lengthCut_vect(i),[resultsFolderName_Connected5 '_' num2str(i)])
    cd ../
    mkdir([resultsFolderName_Connected5 '_' num2str(i+1)])
    copyfile([resultsFolderName_Connected5 '_' num2str(i) '/' '1.tif_BinaryParam.csv'],[resultsFolderName_Connected5 '_' num2str(i+1) '/' '1.tif_BinaryParam.csv'])
    cd(CodeFolder)
end
close
% Create figure
fig = figure;
hold on
sz = 60;
RHF_Measured = zeros(length(lengthCut_vect),1);
cd ../
cd(folderNameResults_Connected5)
RHF_Expected = csvread(fileNameResults_Connected5,1, 1);
cd ../
cd(CodeFolder)
plot(lengthCut_vect,RHF_Expected(1)*ones(length(lengthCut_vect),1),'k:','LineWidth',1)

for i=1:length(lengthCut_vect)
    cd ../
    cd([resultsFolderName_Connected5 '_' num2str(i)])
    RHF_Measured(i) = csvread([folderName_Connected5 '_results.csv'],1, 1);
    cd ../
    cd(CodeFolder)
    scatter(lengthCut_vect(i),abs(RHF_Measured(i)-RHF_Expected(1)),sz,'LineWidth',1,'MarkerEdgeColor',color1,'MarkerFaceColor',color1Fill)
end

xlab=xlabel('lengthCut');
ylab=ylabel('RHF');
set([xlab,ylab],'fontsize',18)
%legend({num2str(lengthCut_vect(:))})
%set([legend],'fontsize',18,'location', 'NorthWest')
opts.width      = 20;
opts.height     = 14;
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
cd([resultsFolderName_Connected5 '_' num2str(i)])
saveas(gcf,[resultsFolderName_Connected5 '_' num2str(i) '_cenvergence_lengthCut.pdf'])
cd ../
cd(CodeFolder)


%% Connected hydride 6 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% analysis
for i=1:length(lengthCut_vect)
    RHF_Verification( CodeFolder,folderName_Connected6,folderNameResults_Connected6,fileNameResults_Connected6,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution, lengthCut_vect(i),[resultsFolderName_Connected6 '_' num2str(i)])
    cd ../
    mkdir([resultsFolderName_Connected6 '_' num2str(i+1)])
    copyfile([resultsFolderName_Connected6 '_' num2str(i) '/' '1.tif_BinaryParam.csv'],[resultsFolderName_Connected6 '_' num2str(i+1) '/' '1.tif_BinaryParam.csv'])
    cd(CodeFolder)
end
close
% Create figure
fig = figure;
hold on
sz = 60;
RHF_Measured = zeros(length(lengthCut_vect),1);
cd ../
cd(folderNameResults_Connected6)
RHF_Expected = csvread(fileNameResults_Connected6,1, 1);
cd ../
cd(CodeFolder)
plot(lengthCut_vect,RHF_Expected(1)*ones(length(lengthCut_vect),1),'k:','LineWidth',1)

for i=1:length(lengthCut_vect)
    cd ../
    cd([resultsFolderName_Connected6 '_' num2str(i)])
    RHF_Measured(i) = csvread([folderName_Connected6 '_results.csv'],1, 1);
    cd ../
    cd(CodeFolder)
    scatter(lengthCut_vect(i),abs(RHF_Measured(i)-RHF_Expected(1)),sz,'LineWidth',1,'MarkerEdgeColor',color1,'MarkerFaceColor',color1Fill)
end

xlab=xlabel('lengthCut');
ylab=ylabel('RHF');
set([xlab,ylab],'fontsize',18)
%legend({num2str(lengthCut_vect(:))})
%set([legend],'fontsize',18,'location', 'NorthWest')
opts.width      = 20;
opts.height     = 14;
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
cd([resultsFolderName_Connected6 '_' num2str(i)])
saveas(gcf,[resultsFolderName_Connected6 '_' num2str(i) '_cenvergence_lengthCut.pdf'])
cd ../
cd(CodeFolder)
