function [ ] = plotPaths(nodes, plotFrequency, filename, codeFolderName, resultsFolderName, figureNumber, numRun, first_column, bands_global_iteration, bands_iteration)
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
% This function plots the current paths on the micrographs. 

% Inputs:
% - nodes: The horitontal positions of the numPaths paths.
% - plotFrequency: For the genetic algorithm. Number of generation between plots of the paths. Having a small number here slows down the algorithm as it wastes time plotting figures. We recommend using 1000.
% - filename: Name of the microstructure file.
% - codeFolderName: The name of the folder in which the RHF code is stored.
% - resultsFolderName: The name of the folder in which the results will be stored. The folder is created if it does not already exist.
% - figureNumber: The number of the iteration in  the genetic algorithm.
% - numRun: For the genetic algorithm. Number of times the genetic algorithm is run on each microstructure. To save time, we recommend using 1.
% - first_column: The position of the left end of the band being analyzed.
% - bands_global_iteration: The number of the iteration for the global for-loop in RHCP_file.
% - bands_iteration: The number of the band being analyzed. 

% Outputs:
% None, but this fonction plots the current paths on the micrographs and
% saves the figure.

%%%%%%%%%%%%% Plot and save the paths on the micrographs %%%%%%%%%%%%%%%%%%
if (mod(figureNumber,plotFrequency)==1) % only plots every plotFrequency steps
    % Open the figure being studied
    cd ../
    cd(resultsFolderName)
    BinaryImageName = [filename '_binary.tiff'];
    BinaryImage = imread(BinaryImageName);
    [num_rows, num_columns, numberOfColorChannels] = size(BinaryImage);
    figure(figureNumber)
    imshow(BinaryImageName)
    hold on
    
    % Plot the paths
    for i=1:size(nodes,2)
        % Plot the path on top of it
        path = [nodes(:,i)+first_column-1 [1:size(nodes,1)]'];
        plot(path(:,1),path(:,2),'-','LineWidth',3);
    end

    % Plot the frame
    plot([1 num_columns],[1 1],'k-','LineWidth',1) %top
    plot([1 num_columns],[num_rows num_rows],'k-','LineWidth',1) %bottom
    plot([1 1],[1 num_rows],'k-','LineWidth',1) %left
    plot([num_columns num_columns],[1 num_rows],'k-','LineWidth',1) %right
    % Save figure
    opts.width      = 20;
    opts.height     = 20;
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
    saveas(gcf,[filename '_' num2str(numRun) '_' num2str(bands_global_iteration) '_' num2str(bands_iteration) '_' num2str(figureNumber) '_Micrograph_Paths.pdf']) 
    close % close the figure
    cd ../
    cd(codeFolderName)
end


end

