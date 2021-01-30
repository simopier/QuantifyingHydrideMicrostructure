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
% Plot on the same figure the microstructure and the two best paths derived
% with two different definitions of RHCP.


%%%%%%%%%%%%%%%%%%%%%%%%% Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Clean workspace
close all
clear

% Define names for files and figures
num_figures = 19;
codeFolderName = 'RHCP_MatLab_Code';
resultsFolderName = {'RHCP_Verification_results_bands_1_nan','RHCP_Verification_results_bands_1_45_13'}; %{'RHCP_Band_Results_1','RHCP_Band_Results_45_1'};%{'RHCP_Verification_results_bands_1_nan','RHCP_Verification_results_bands_1_45_13'}; %{'RHCP_Validation_Experiment_Microstructures_Kim2015_format_Results','RHCP_Validation_Experiment_Microstructures_Kim2015_format_Results_45'};
file_name_suffix = '_binary.tiff';
best_path_suffix = '.tif_best_path_results.csv';
legend_vect = {'$RHCP$','$RHCP^{45}$'};
figure_folder_name = 'RHCP_Verification_Best_Paths_Figures'; %'RHCP_Band_Results_1_Best_Paths_Figures'; %'RHCP_Validation_Experiment_Microstructures_Kim2015_Best_Paths_Figures';
figures_name_suffix = '_Micrograph_Path.pdf';
fracParamZr = 50;
fracParamZrH = 1;
valueZrH = 1;
desiredAngle = [ nan pi/4 ];
W = 13;
y_step = 10;

%%%%%%%%%%%%%%%%%%%%%%%%%% Plot figures %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pathEval_vect = zeros(num_figures,length(resultsFolderName)+1);

for im = 1:num_figures

    % Open the figure
    cd ../
    cd(resultsFolderName{1})
    fig = figure(im);
    filename = [num2str(im) '.tif' file_name_suffix];
    binaryImage = imread(filename);
    
    binaryImage = imcomplement(binaryImage);
    binaryImage = bwmorph(binaryImage, 'thicken',3);
    binaryImage = imcomplement(binaryImage);
    
    imshow(binaryImage)
    hold on
    cd ../
    cd(codeFolderName)
    
    % Go in the result folders to get the best paths
    for f = 1:length(resultsFolderName)
        % Go to the results folder
        cd ../
        cd(resultsFolderName{f})
        % Upload the best Path
        path = csvread([num2str(im) best_path_suffix],1,0); %first column is y, second column is x
        % Plot the path
        plot(path(:,2),path(:,1),':','LineWidth',3) %,'Color',color(f)
        % Go back to code folder
        cd ../
        cd(codeFolderName)
        % Derive the RHCP value of the path
        pathEval_vect(im,1) = im;
        nodes = path(:,2);
        eval = EvalPaths(nodes,binaryImage,fracParamZr,fracParamZrH,valueZrH,desiredAngle(f),W,y_step);
        pathEval_vect(im,f+1) = eval(1);
    end
    
    % Plot the frame of the image
    [num_rows, num_columns, numberOfColorChannels] = size(binaryImage);
    plot([1 num_columns],[1 1],'k-','LineWidth',1) %top
    plot([1 num_columns],[num_rows num_rows],'k-','LineWidth',1) %bottom
    plot([1 1],[1 num_rows],'k-','LineWidth',1) %left
    plot([num_columns num_columns],[1 num_rows],'k-','LineWidth',1) %right
    
    legend(legend_vect,'fontsize',27,'Location','NorthEast','Interpreter','latex')
    
    % Save figure
    opts.width      = 20;
    opts.height     = 20;
    opts.fontType   = 'Latex';
    % caling
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
    mkdir(figure_folder_name)
    cd(figure_folder_name)
    saveas(gcf,[num2str(im) figures_name_suffix])
    close % close the figure
    cd ../
    cd(codeFolderName)
    
    
end

pathEval_vect
    