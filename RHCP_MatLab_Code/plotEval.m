function [] = plotEval(codeFolderName, filename, resultsFolderName, plotFrequency, max_eval, min_eval, median_eval, mean_eval, CPTotal, numRun, bands_global_iteration, bands_iteration)
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
% This function plots the evolution of the paths evaluations (min, max, 
% median, mean) and saves the figure in the result folder.

% Inputs:
% - codeFolderName: The name of the folder in which the RHF code is stored.
% - filename: Name of the microstructure file.
% - resultsFolderName: The name of the folder in which the results will be stored. The folder is created if it does not already exist.
% - plotFrequency: For the genetic algorithm. Number of generation between plots of the paths. Having a small number here slows down the algorithm as it wastes time plotting figures. We recommend using 1000.
% - max_eval: maximum RHCP value of the generation.
% - min_eval: minimum RHCP value of the generation.
% - median_eval: median RHCP value of the generation.
% - mean_eval: mean RHCP value of the generation.
% - CPTotal: The number of the iteration in  the genetic algorithm.
% - numRun: For the genetic algorithm. Number of times the genetic algorithm is run on each microstructure. To save time, we recommend using 1.
% - bands_global_iteration: The number of the iteration for the global for-loop in RHCP_file.
% - bands_iteration: The number of the band being analyzed. 

% Outputs:
% None, but this fonction plots the current paths evaluations (min, max, 
% median, mean) and saves the figure.

%%%%%%%%%%%%% Plot and save the RHCP values of the paths %%%%%%%%%%%%%%%%%%
if (mod(CPTotal,plotFrequency)==1) % only plots every plotFrequency steps
    % Go to the results folder
    cd ../
    cd(resultsFolderName)
    
    % Open figure and set up options
    fig = figure;
    hold on
    
    color1 = [1 133 113]/255;
    color1Fill = [128 205 193]/255;
    color2 = [166 97 26]/255;
    color2Fill = [223 194 125]/255;
    opts.width      = 20;
    opts.height     = 14;
    opts.fontType   = 'Latex';
    
    % Plot evaluations
    step_vect = [0:CPTotal];
    plot(step_vect,max_eval,'-','Color',color2,'LineWidth',1.5)
    plot(step_vect,median_eval,':','Color',color1,'LineWidth',1.5)
    plot(step_vect,mean_eval,'-','Color',color1,'LineWidth',1.5)
    plot(step_vect,min_eval,'-.','Color',color2,'LineWidth',1.5)
    plot(step_vect,0*step_vect,'k:','LineWidth',0.5)
    fill([step_vect fliplr(step_vect)],[max_eval fliplr(min_eval)],color2Fill,'LineStyle','none')
    alpha(0.25)
    
    xlab=xlabel('Number of iterations','Interpreter','latex','fontsize',24);
    ylab=ylabel('$RHCP$','Interpreter','latex','fontsize',24);
    legend({'$RHCP_{max}$','$RHCP_{median}$','$RHCP_{mean}$','$RHCP_{min}$'},'Interpreter','latex')
    set([legend],'fontsize',18,'location', 'SouthEast')
    axis([0 CPTotal min(0,max(min(min_eval),-4)) 1.1])
    
    % Save figure
    opts.width      = 20;
    opts.height     = 12;
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
    saveas(gcf,[filename '_' num2str(numRun) '_' num2str(bands_global_iteration) '_' num2str(bands_iteration) '_RHCP_evaluation.pdf'])
    saveas(gcf,[filename '_' num2str(numRun) '_' num2str(bands_global_iteration) '_' num2str(bands_iteration) '_RHCP_evaluation.fig'])
    close % close the figure
    
    % Go back to the code folder
    cd ../
    cd(codeFolderName)
end



end

