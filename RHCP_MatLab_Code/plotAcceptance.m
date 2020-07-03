function [] = plotAcceptance(codeFolderName, filename, resultsFolderName, CPTotal, perAcc_vect, perAcc_vect_abscissa, PerCut, numRun, bands_global_iteration, bands_iteration)
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
% This function plots and saves the evolution of the acceptance rate for
% new paths.

% Inputs:
% - codeFolderName: The name of the folder in which the RHF code is stored.
% - filename: Name of the microstructure file.
% - resultsFolderName: The name of the folder in which the results will be stored. The folder is created if it does not already exist.
% - CPTotal: The number of the iteration in  the genetic algorithm.
% - perAcc_vect: Current proportion of accepted new paths.
% - perAcc_vect_abscissa: Vector of the abscissa values for the plot.
% - PerCut: For the genetic algorithm convergence. The acceptance rate for new generations under which the porgram should stop. We recommend using 0.01.
% - numRun: For the genetic algorithm. Number of times the genetic algorithm is run on each microstructure. To save time, we recommend using 1.
% - bands_global_iteration: The number of the iteration for the global for-loop in RHCP_file.
% - bands_iteration: The number of the band being analyzed. 

% Outputs:
% None, but this fonction plots the evolution of the acceptance rate of new
% paths and saves the figure in the result folder.

%%%%%%%%%%%%%%%%%%%% Open figure and set up options %%%%%%%%%%%%%%%%%%%%%%%

cd ../
cd(resultsFolderName)
fig = figure;
hold on
opts.width      = 20;
opts.height     = 14;
opts.fontType   = 'Latex';

%%%%%%%%%% Plot and save the evolution of the acceptance rate %%%%%%%%%%%%%

plot(perAcc_vect_abscissa,perAcc_vect*100,'k-','LineWidth',1)
plot(perAcc_vect_abscissa,PerCut*100*ones(1,length(perAcc_vect_abscissa)),'k:','LineWidth',1)
fill([perAcc_vect_abscissa fliplr(perAcc_vect_abscissa)],[PerCut*100*ones(1,length(perAcc_vect_abscissa)) fliplr(perAcc_vect*100)],[0 0 0],'LineStyle','none')
alpha(0.25)
xlab=xlabel('Number of iterations','Interpreter','latex','fontsize',24);
ylab=ylabel('Percentage of accepted path','Interpreter','latex','fontsize',24);
legend({'Percentage Accepted','Percentage limit'},'Interpreter','latex')
set([legend],'fontsize',18,'location', 'NorthEast')
axis([0 CPTotal 0 100])


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
saveas(gcf,[filename '_' num2str(numRun) '_' num2str(bands_global_iteration) '_' num2str(bands_iteration) '_RHCP_percentage_acceptance.pdf'])
saveas(gcf,[filename '_' num2str(numRun) '_' num2str(bands_global_iteration) '_' num2str(bands_iteration) '_RHCP_percentage_acceptance.fig'])
close % close the figure

% Go back to the code folder
cd ../
cd(codeFolderName)


end

