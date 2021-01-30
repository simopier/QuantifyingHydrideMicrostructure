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
% For Validation. Analyzes the path found with fracParamZr = 50 and
% fracParamZrH = 1 and determines their values with different values

%%%%%%%%%%%%%%%%%%%%%%%%% Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clear workspace
close all
clear

% Initialization
codeFolderName = 'RHCP_MatLab_Code';
resultsFolderName =  'RHCP_Validation_Experiment_Microstructures_Kim2015_format_Results';
resultFileNamesSuffix = '.tif_best_path_results.csv';
list_names = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31];
fracParamZr_vect = [5 25 50 100 500];
fracParamZrH_vect = [0.1 0.5 1 2 10];

fracParam_vect = zeros(2,length(fracParamZr_vect)*length(fracParamZrH_vect));
path_eval_mat = zeros(length(list_names),length(fracParamZr_vect)*length(fracParamZrH_vect));

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Go through all validation image
for i=1:length(list_names)
    % Open the file with the path position
    cd ../
    cd(resultsFolderName)
    nodes = csvread([num2str(list_names(i)) resultFileNamesSuffix],1,1);
    cd ../
    cd(codeFolderName)

    % load binary image
    cd ../
    cd(resultsFolderName)
    binaryImage = imcomplement(imread([num2str(list_names(i)) '.tif' '_binary' '.tiff']));
    cd ../
    cd(codeFolderName)
    
%     % Go through every selected point and build the path
%     nodes = zeros(size(binaryImage,1),1);
%     pos_current = 1;
%     for j=1:size(positions_vect,1)
%         % end the path vertically
%         if j==size(positions_vect,1)
%             nodes(positions_vect(j,2):end) = positions_vect(j,1);
%         else
%             % start the path vertically
%             if j==1
%                 nodes(pos_current:positions_vect(j,2)) = positions_vect(j,1);
%             end
%             % build a straight line between two consecutive points
%             current_x = positions_vect(j,1);
%             current_y = positions_vect(j,2);
%             next_x = positions_vect(j+1,1);
%             next_y = positions_vect(j+1,2);
%             
%             delta_y = next_y - current_y;
%             delta_x = next_x - current_x;
%             for k = current_y : next_y
%                 nodes(k) = round((delta_x)/(delta_y)*(k-current_y)+current_x);
%             end
%         end
%     end
    
    % Evaluate the path for each combinason of fracture toughness values
    valueZrH = 1;
    desiredAngle = nan;
    W = 13;
    y_step = 10;
    
    for ftZr = 1:length(fracParamZr_vect)
        for ftZrH = 1:length(fracParamZrH_vect)
            eval = EvalPaths(nodes,binaryImage,fracParamZr_vect(ftZr),fracParamZrH_vect(ftZrH),valueZrH,desiredAngle,W,y_step);
            fracParam_vect(1,ftZr + (ftZrH-1)*length(fracParamZr_vect)) = fracParamZr_vect(ftZr);
            fracParam_vect(2,ftZr + (ftZrH-1)*length(fracParamZr_vect)) = fracParamZrH_vect(ftZrH);
            path_eval_mat(i,ftZr + (ftZrH-1)*length(fracParamZr_vect)) = eval(1,1);
        end
    end
    
end

%%%%%%%%%% Save the results in a .csv file in resultsFolderName %%%%%%%%%%%
cd ../
cd(resultsFolderName)
% Save the best path
filename_results=[resultsFolderName '_sensitivity_analysis_Fracture_Toughness.csv'];
results_mat=[fracParam_vect; path_eval_mat]; % add fracParam value to the result matrix
results_mat=[[0 0 list_names]' results_mat]; % add the image names value to the result matrix
% add a header
cHeader = {'name_microstructure' 'RHCP values as a function of the fracture toughnesses'}; %header
textHeader = strjoin(cHeader, ',');
% write header to file
fid = fopen(filename_results,'w');
fprintf(fid,'%s\n',textHeader);
fclose(fid);
% write data in file
dlmwrite(filename_results,results_mat,'-append');
cd ../
cd(codeFolderName)

