%% Plot the different verification runs with different options

% Clean workspace
close all
clear

% Define names for files and figures
num_figures = 19;
codeFolderName = 'Connectivity_Code_RHCP';
resultsFolderName = {'Connectivity_Code_RHCP_Verification_results_3','Connectivity_Code_RHCP_Verification_results_3_45_13'};
file_name_suffix = '_binary.tiff';
best_path_suffix = '.tif_best_path_results.csv';
legend_vect = {'$RHCP$','$RHCP^{\frac{\pi}{4}}_{13}$'};
figure_folder_name = 'Continuous_Verification_Best_Paths_Figures';
figures_name_suffix = '_Micrograph_Path.pdf';

% Initialization
% color = []


% Plot figures

for im = 1:num_figures

    % Open the figure
    cd ../
    cd(resultsFolderName{1})
    fig = figure(im);
    filename = [num2str(im) '.tif' file_name_suffix];
    imshow(filename)
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
    end
    
    % Plot the frame of the image
    plot([1 size(path(:,2),1)+90],[1 1],'k-','LineWidth',1)
    plot([1 size(path(:,2),1)-1+90],[size(path(:,2),1) size(path(:,2),1)],'k-','LineWidth',1)
    plot([1 1],[1 size(path(:,2),1)],'k-','LineWidth',1)
    plot([size(path(:,2),1)-1+88 size(path(:,2),1)-1+88],[1 size(path(:,2),1)],'k-','LineWidth',1)
    
    legend(legend_vect,'fontsize',25,'Interpreter','latex')
    
    % Save figure
    opts.width      = 21;
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

    
    