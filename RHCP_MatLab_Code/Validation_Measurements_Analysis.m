%-------------------------------------------------------------------------%
%                                                                         %
%       Script developed by Pierre-Clement A Simon                        %
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
% For RHCP Validation. Analyzes the MATLAB and ImageJ measurements and 
% produces statistical figures.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clear workspace
close all
clear

% Initialization
codeFolderName = 'RHCP_MatLab_Code';
resultsFileName =  'RHCP_Validation_Results_All';
timeFileName =  'RHCP_Validation_time.xlsx';
numberResultsFolder = 12;
numberImages = 18;
sheetNames={'1','2','3','4','5','6','7','8','9','10','11','12'};%#############################################

%%%%%%%%%%%%%%%%%%%%%%%%% Load and organize data %%%%%%%%%%%%%%%%%%%%%%%%%%

% Open excel files for results
cd ../
Data = zeros(numberResultsFolder,numberImages*3-1);
for i=1:numberResultsFolder
    Table = xlsread([resultsFileName '.xlsx'],sheetNames{i});
    for j=1:numberImages
        Data(i,3*(j-1)+2)=Table(j,2); % Matlab
        Data(i,3*(j-1)+1)=Table(j,4); %User defined
        if j<numberImages
            Data(i,3*(j-1)+3)=nan; 
        end
    end
end

% Open excel files for time
Data_time = zeros(numberResultsFolder,2);
for i=1:numberResultsFolder
    Table = xlsread(timeFileName,sheetNames{i});
    Data_time(i,1)=Table(1,1); % Binarization
    Data_time(i,2)=Table(2,1); % ImageJ
    Data_time(i,3)=Table(3,1); % Matlab
end

%%%%%%%%%%%%%%%%%%%%%%%%% Statistical analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Derive the standard deviations, difference between the 25th and 75th 
% percentiles, the mean, and the median for all microstructures and methods
Data_std = zeros(1,size(Data,2));
Data_mean = zeros(1,size(Data,2));
for i=1:size(Data,2)
    Data_std(i) = std(Data(:,i));
    Data_diffquart(i) = prctile(Data(:,i),75)-prctile(Data(:,i),25);
    Data_mean(i) = mean(Data(:,i));
    Data_median(i) = median(Data(:,i));
end

% Derive the mean standard deviation for the ImageJ analysis
mean_std_ImageJ = mean(Data_std(1:3:size(Data,2)))

% Derive the mean standard deviation for the MATLAB code
mean_std_Matlab = mean(Data_std(2:3:size(Data,2)))

% Derive the mean 25-75 percentile difference for the ImageJ analysis
mean_diffquart_ImageJ = mean(Data_diffquart(1:3:size(Data,2)))

% Derive the mean 25-75 percentile difference for the MATLAB code
mean_diffquart_Matlab = mean(Data_diffquart(2:3:size(Data,2)))

% Derive the mean difference between the MATLAB and the ImageJ analysis
% means
Data_mean_ImageJ = Data_mean(1:3:size(Data,2));
Data_mean_Matlab = Data_mean(2:3:size(Data,2));
mean_diff_vect = Data_mean_Matlab-Data_mean_ImageJ
mean_diff = mean(abs((mean_diff_vect)))

% Derive the mean difference between the MATLAB and the ImageJ analysis
% medians
Data_median_ImageJ = Data_median(1:3:size(Data,2));
Data_median_Matlab = Data_median(2:3:size(Data,2));
mean_median_diff_vect = Data_median_Matlab-Data_median_ImageJ
mean_median_diff = mean(abs((mean_median_diff_vect)))
max_median_diff = max(abs((mean_median_diff_vect)))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Plot the data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fig = figure;

% colors
color1 = [1 133 113]/255;
color1Fill = [128 205 193]/255;
color2 = [166 97 26]/255;
color2Fill = [223 194 125]/255;
c = [color1;color2];
C = [c];
for i=1:numberImages-1
    C = [C; ones(1,3); c];  % this is the trick for coloring the boxes
end

% x axis
x_axis_labels = {'','1','','','2','','','3','','','4','','','5','','','6','','','7','','','8','','','9','','','10','','','11','','','12','','','13','','','14','','','15','','','16','','','17','','','18'};

% boxwidth = 0.5;
% positions = [1:0.25:2.75]; 
% h = boxplot(A, 'colors', C,'plotstyle', 'compact', 'widths', boxwidth, 'position', positions, ...     
%     'labels', {'','ASIA','','','USA','','','EUROPE'});

% Plot boxes
b = boxplot(Data, 'colors', C, 'plotstyle', 'compact','widths',1, ...
    'labels', x_axis_labels);
hold on;

% trick for the legend
for j = 1:2
    plot(NaN,1,'color', c(j,:), 'LineWidth', 4);
end

% grey areas
grey = [200,200,200]/255;
yValue = [0:numberImages]*3;

boxy=[0 1 1 0];
for i = 1:length(yValue)-1
    if mod(i+1,2)==0
        patch([yValue(i) yValue(i) yValue(i+1) yValue(i+1)],boxy,[0 1 0],'FaceColor',[1 1 1],'FaceAlpha',0.2,'EdgeColor','none');
    else
        patch([yValue(i) yValue(i) yValue(i+1) yValue(i+1)],boxy,[0 1 0],'FaceColor',grey,'FaceAlpha',0.2,'EdgeColor','none');
    end
end

xlab=xlabel('Image number','Interpreter','latex','fontsize',24);
ylab=ylabel('RHCP','Interpreter','latex','fontsize',24);
legend({'RHCP ImageJ','RHCP MATLAB'},'Interpreter','latex')
set([legend],'fontsize',18,'location', 'NorthEast')
axis([0 18*3 0 1])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Save the plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% options
opts.width      = 18;
opts.height     = 12;
opts.fontType   = 'Latex';
% scaling
fig.Units               = 'centimeters';
fig.Position(3)         = opts.width;
fig.Position(4)         = opts.height;
% remove unnecessary white space
% set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
box on
% Export to PDF
set(gca,'units','centimeters')
set(gcf,'PaperUnits','centimeters');
set(gcf,'PaperSize',[opts.width opts.height]);
set(gcf,'PaperPositionMode','manual');
set(gcf,'PaperPosition',[0 0 opts.width opts.height]);
saveas(gcf,[resultsFileName '.pdf'])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Time analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mean_time_Binarization = mean(Data_time(:,1))
mean_time_ImageJ = mean(Data_time(:,2))
mean_time_Matlab = mean(Data_time(:,3))




cd(codeFolderName)

