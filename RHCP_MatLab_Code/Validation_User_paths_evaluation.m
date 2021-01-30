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
% For Validation. Analyzes the ImageJ measurements made by users to derive
% the paths positions, as well as its RHCP value.

%%%%%%%%%%%%%%%%%%%%%%%%% Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clear workspace
close all
clear

% Initialization
codeFolderName = 'RHCP_MatLab_Code';
resultsFolderName =  'RHCP_Validation_Results_12';
list_names = [6	7 8	9	10	11	12	13	14	15	54	55	56	60	61	82	83	84];
user_path_eval = zeros(length(list_names),1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Go through all paths created by the user
for i=1:length(list_names)
    % Open the file
    cd ../
    cd(resultsFolderName)
    positions_vect = csvread([num2str(list_names(i)) '.csv'],1,0);
    cd ../
    cd(codeFolderName)
    % clean up positions to have only intergers
    % round(x) is acceptable, but every y value has to be unique
    positions_vect(:,1) = round(positions_vect(:,1));
    for j=1:size(positions_vect,1)
        if j == 1
            positions_vect(j,2) = max(1,floor(positions_vect(j,2)));
        else
            positions_vect(j,2) = max(1,floor(positions_vect(j,2)));
            if size(find(positions_vect(1:j-1,2) == positions_vect(j,2)),1) > 0
                positions_vect(j,2) = positions_vect(j-1,2)+1;
            end
        end
    end

    % load binary image
    cd ../
    cd(resultsFolderName)
    binaryImage = imcomplement(imread([num2str(list_names(i)) '.tiff' '_binary' '.tiff']));
    cd ../
    cd(codeFolderName)
    
    % Go through every selected point and build the path
    nodes = zeros(size(binaryImage,1),1);
    pos_current = 1;
    for j=1:size(positions_vect,1)
        % end the path vertically
        if j==size(positions_vect,1)
            nodes(positions_vect(j,2):end) = positions_vect(j,1);
        else
            % start the path vertically
            if j==1
                nodes(pos_current:positions_vect(j,2)) = positions_vect(j,1);
            end
            % build a straight line between two consecutive points
            current_x = positions_vect(j,1);
            current_y = positions_vect(j,2);
            next_x = positions_vect(j+1,1);
            next_y = positions_vect(j+1,2);
            
            delta_y = next_y - current_y;
            delta_x = next_x - current_x;
            for k = current_y : next_y
                nodes(k) = round((delta_x)/(delta_y)*(k-current_y)+current_x);
            end
        end
    end
    
    % Evaluate the path
    fracParamZr = 50;
    fracParamZrH = 1;
    valueZrH = 1;
    desiredAngle = nan;
    W = 13;
    y_step = 10;
    eval = EvalPaths(nodes,binaryImage,fracParamZr,fracParamZrH,valueZrH,desiredAngle,W,y_step);
    user_path_eval(i) = eval(1,1);
    
    % Plot and save the user path
    % Open the figure being studied
    cd ../
    cd(resultsFolderName)
    figure
    imshow([num2str(list_names(i)) '.tiff' '_binary' '.tiff'])
    hold on
    
    % Plot the path on top of it
    path = [nodes(:,1) [1:size(nodes,1)]'];
    plot(path(:,1),path(:,2),'-','LineWidth',3);
    
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
    saveas(gcf,[num2str(list_names(i)) '_User_Defined_Micrograph_Paths.pdf'])
    close % close the figure
    cd ../
    cd(codeFolderName)
end

%%%%%%%%%% Save the results in a .csv file in resultsFolderName %%%%%%%%%%%
cd ../
cd(resultsFolderName)
% Save the best path
filename_results=[resultsFolderName '_user_paths_evaluation.csv'];
results_mat=[list_names' user_path_eval];
% add a header
cHeader = {'name_microstructure' 'User path RHCP'}; %header
textHeader = strjoin(cHeader, ',');
% write header to file
fid = fopen(filename_results,'w');
fprintf(fid,'%s\n',textHeader);
fclose(fid);
% write data in file
dlmwrite(filename_results,results_mat,'-append');
cd ../
cd(codeFolderName)


