function [RHCP] = RHCP_file(codeFolderName,imageFolderName, filename, resultsFolderName, resolution, PerCut, tolConvergence, numPaths, Mutation, primary_nodes_dist, disp_num, disp_size, annealingTime, numRun, CPMax, num_smoothing,fracParamZr,fracParamZrH, valueZrH, num_bands, bridge_criteria_ratio, plotFrequency, desiredAngle, W, y_step)
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
% This function is called by RHCP_folder and measure the RHCP of the
% microstructure given as input. It opens the given microstructure and
% performs the analysis using the genetic algorithm. It frequently plots
% and saves the current paths, the histogram of RHCP values, as well as the
% convergence of the values.
% Once the analysis is over, it saves in the result folder a .csv file and
% a figure with the best path on the microstructure.

% Inputs:
% - codeFolderName: The name of the folder in which the RHF code is stored.
% - imageFolderName: The name of the folder in which images are stored.
% - filename: Name of the microstructure file.
% - resolution: The image resolution in dpi. Enter 0 if you want to use the resolution in the metadata of the images.
% - resultsFolderName: The name of the folder in which the results will be stored. The folder is created if it does not already exist.
% - PerCut: For the genetic algorithm convergence. The acceptance rate for new generations under which the porgram should stop. We recommend using 0.01.
% - tolConvergence: For the genetic algorithm convergence. The tolerance for the difference between the RHCP value of the best and worst paths. The algorithm stops when the difference is smaller than this tolerance. We recommend using 1e-4.
% - numPaths: For the genetic algorithm. The number of paths in each generation. We recommend using between 50 and 100.
% - Mutation: For the genetic algorithm. The chance of random mutation when deriving a child path. We recommend using 0.05.
% - primary_nodes_dist: For the genetic algorithm. The distance between points of the path that constitute the genome. To ensure that the algorithm will pick up circumferential hydrides, we recommend using 1.
% - disp_num: For the genetic algorithm. Number of displacements imposed on the path during annealing. We recommend using 20.
% - disp_size: For the genetic algorithm. Maximum magnitude of the displacements imposed on the path during annealing. We recommend using 20.
% - annealingTime: For the genetic algorithm. Number of annealing steps. We recommend using 1000.
% - numRun: For the genetic algorithm. Number of times the genetic algorithm is run on each microstructure. To save time, we recommend using 1.
% - CPMax: For the genetic algorithm. Maximum number of generations. We recommend using 50001.
% - num_smoothing: For the genetic algorithm. Number of times the path is smoothed. We recommend using 1, doing it more than that does not really increase the path quality..
% - fracParamZr: For the genetic algorithm. Fracture toughness of the zirconium phase. We recommend using 50.
% - fracParamZrH: For the genetic algorithm. Fracture toughness of the hydride phase. We recommend using 1.
% - valueZrH: For the genetic algorithm. Binary value representing the hydride phase, as opposed to the zirconium phase in the image. With the microstructures given here, you should use 1.
% - num_bands: For the genetic algorithm. Number of bands used to divide the image. We recommend using 1 or 5.
% - bridge_criteria_ratio: For the genetic algorithm. Fraction of hydride that should be present between two path to justify building a bridge between two paths from two different bands. We recommend using 0.6.
% - plotFrequency: For the genetic algorithm. Number of generation between plots of the paths. Having a small number here slows down the algorithm as it wastes time plotting figures. We recommend using 1000.
% - desiredAngle: For the genetic algorithm. To use the regular definition of the RHCP, use nan. If you want to add a penalty to favor a given angle orientation in the zirconium phase, enter this angle in rad. We recommend using nan or pi/4.
% - W: For the genetic algorithm. Magnitude of the penalty to favor a given angle. This is not used if desiredAngle = nan. We recommend using 13 otherwise.
% - y_step: For the genetic algorithm. Length of the paths section used to determine its orientation. This is not used if desiredAngle = nan. Otherwise, it is used to accurately determine the paths orientation and apply the angle penalty. We recommend using 10.

% Outputs:
% This function returns the HCC value for the input microstructure. It
% also plots and save the best path and saves its positions in a .csv file.

%%%%%%%%%%%%%%%%%%%%% Find and open the images %%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd ../
cd(resultsFolderName)
binaryImage = imcomplement(imread([filename '_binary' '.tiff']));
cd ../
cd(codeFolderName)

%%%%%%%%%%%%%%%%%% Determine the image resolution %%%%%%%%%%%%%%%%%%%%%%%%%
% resolution is actually unused in this code, but kept for potential future changes
if resolution==0
    cd ../
    cd(imageFolderName)
    info = imfinfo(filename);
    resolution=info.XResolution; 
    cd ../
    cd(codeFolderName)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Initialization
length_binaryImage = size(binaryImage,1);
width_binaryImage = size(binaryImage,2);
best_paths = zeros(length_binaryImage,numRun);
best_paths_eval = zeros(numRun,2);

%Determine Primary Nodes
[num_primary_nodes,primary_nodes] = PrimaryNodes(length_binaryImage,primary_nodes_dist);


%The search routine to find a optimum pathway numRun times and keep best path for each segment
for R = 1:numRun %Loop for the full searching algorithm

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Parameters
    if mod(num_bands,2)==0 % numPaths_band needs to be odd
        num_bands = num_bands +1;
    end
    numPaths_band = ceil(numPaths/num_bands);
    if mod(numPaths_band,2)==1 % numPaths_band needs to be even
        numPaths_band = numPaths_band +1;
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Initialize the results vectors
    nodes_new = []; % to keep track of the nodes created during the current global iteration
    nodes_new_eval = []; % to keep track of the evaluation of the nodes created during the current global iteration
    nodes_new_best = []; % to keep track of the best nodes created during the current global iteration (one per band)
    nodes_new_best_eval = []; % to keep track of the evaluation of the best nodes created during the current global iteration (one per band)
    nodes_previous = []; % contains the nodes generated during the previous global iteration
    nodes_previous_eval = []; % contains the evaluation of the nodes generated during the previous global iteration
    nodes_previous_best = []; % contains the best nodes generated during the previous global iteration (one per band)
    nodes_previous_best_eval = []; % contains the evaluation of the best nodes generated during the previous global iteration (one per band)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Determine the bands positions
    number_bands_positions = num_bands + 1 + 1*(num_bands>1);
    width_band = floor(width_binaryImage/ceil(num_bands/2));
    bands_positions_1 = [1:width_band:width_binaryImage-3];
    bands_positions_2 = [floor(width_band/2):width_band:width_binaryImage-3];
    bands_positions = sort([bands_positions_1 bands_positions_2 width_binaryImage]);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Go through each global iteration with a decreasing amount of bands as
    % they fuse. They are as many global iteration as they are bands
    for bands_global_iteration = 1:num_bands


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Find best paths in each bands
        for bands_iteration = 1:(num_bands-bands_global_iteration+1) % The number of bands decreases as the bands fuse between global iterations

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Select the current band
            first_column = bands_positions(bands_iteration);
            last_column = bands_positions(bands_iteration + bands_global_iteration + 1);

            % Extract the b^th band from the main binary image
            binaryImage_band = binaryImage(:,first_column:last_column);

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Create or select corresponding nodes, and bridge paths to
            % fuse bands
            if bands_global_iteration == 1
                % If this is the first global iteration, no nodes exist, so
                % they need to be generated and improved.
                % Random generation of initial paths
                nodes_band = RandomPathsGenerator(binaryImage_band,numPaths_band,primary_nodes,primary_nodes_dist);
                % Improve the paths by smoothing them out
                nodes_band = ImprovePaths(nodes_band,binaryImage_band,fracParamZr,fracParamZrH,valueZrH,num_smoothing,desiredAngle,W,y_step);
            else
                % if this isn't the first global iteration, we select the
                % nodes that were created during the previous iteration,
                % and we see if they can be bridged
                
                nodes_band = nodes_previous(:,((bands_iteration-1)*numPaths_band/2+1):((bands_iteration+1)*numPaths_band/2));
                % translation of the position to correspond to the current
                % band
                nodes_band = nodes_band - first_column + 1;
                % if desiredAngle is defined, then the paths are smoothed
                % to remove zigzags where bands boundaries don't exist
                % anomore
                if not(isnan(desiredAngle))
                    nodes_band = ImprovePaths(nodes_band,binaryImage_band,fracParamZr,fracParamZrH,valueZrH,num_smoothing,desiredAngle,W,y_step);
                end
                
                % Create new paths to bridge the existing best paths
                nodes_first_band_best = nodes_previous_best(:,bands_iteration)- first_column + 1;
                nodes_second_band_best = nodes_previous_best(:,bands_iteration+1)- first_column + 1;
                [nodes_bridge_band] = bridgeBands(nodes_first_band_best,nodes_second_band_best,bridge_criteria_ratio,length_binaryImage,binaryImage_band,valueZrH);

                % Random generation of initial paths
                nodes_band_rand = RandomPathsGenerator(binaryImage_band,numPaths_band/2,primary_nodes,primary_nodes_dist);
                % Improve the paths by smoothing them out
                nodes_band_rand = ImprovePaths(nodes_band_rand,binaryImage_band,fracParamZr,fracParamZrH,valueZrH,num_smoothing,desiredAngle,W,y_step);

                % Add these nodes to the existing nodes
                nodes_band = [nodes_band nodes_bridge_band nodes_band_rand];

            end

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Use the genetic algorithm to find the best paths by improving
            % generations after generations
            [nodes_band, eval_band, bestPath_band, bestEval_band] = GeneticAlgorithm(primary_nodes,nodes_band, Mutation,CPMax, PerCut, tolConvergence,binaryImage_band,fracParamZr,fracParamZrH,valueZrH,num_smoothing, plotFrequency, filename, codeFolderName, resultsFolderName, R, desiredAngle, W, y_step, first_column, bands_global_iteration, bands_iteration);

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Select only the best half of the paths unless this is the last iteration
            if bands_global_iteration < num_bands
              eval_band_order = sortrows([ [1:size(eval_band,1)]' eval_band] , 2, 'descend');
              nodes_band = nodes_band(:,eval_band_order(1:numPaths_band/2,1));
              eval_band = eval_band_order(1:numPaths_band/2,2:end);
            end

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Translate the nodes to their position in the larger image
            nodes_band = nodes_band + first_column - 1;
            bestPath_band = bestPath_band + first_column - 1;

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Add the paths and evaluations on the current band to the list of new nodes
            nodes_new = [nodes_new nodes_band];
            nodes_new_best = [nodes_new_best bestPath_band];
            nodes_new_eval = [nodes_new_eval eval_band'];
            nodes_new_best_eval = [nodes_new_best_eval bestEval_band];

        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Plot the current paths, along with the current bands
        % Open the figure being studied
        cd ../
        cd(resultsFolderName)
        figure
        imshow([filename '_binary.tiff'])
        hold on

        % Plot the paths
        for i=1:size(nodes_new,2)
            % Plot the path on top of it
            path = [nodes_new(:,i) [1:size(nodes_new,1)]'];
            plot(path(:,1),path(:,2),'-','LineWidth',3);
        end

        % Plot the frame (verification)
%         plot([1 size(path(:,2),1)+90],[1 1],'k-','LineWidth',1)
%         plot([1 size(path(:,2),1)-1+90],[size(path(:,2),1) size(path(:,2),1)],'k-','LineWidth',1)
%         plot([1 1],[1 size(path(:,2),1)],'k-','LineWidth',1)
%         plot([size(path(:,2),1)-1+88 size(path(:,2),1)-1+88],[1 size(path(:,2),1)],'k-','LineWidth',1)
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
        saveas(gcf,[filename '_' num2str(R) '_iteration_' num2str(bands_global_iteration) '_Micrograph_Paths.pdf'])
        close % close the figure
        cd ../
        cd(codeFolderName)

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % create a share histogram
        cd ../
        cd(resultsFolderName)
        figure

        % Plot histogram
        steps_hist = 0.05;
        edges = [-steps_hist:steps_hist:1+steps_hist];
        histogram(nodes_new_eval(1,:),edges,'Normalization','probability')
        axis([0-steps_hist 1+steps_hist 0 1])

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
        saveas(gcf,[filename '_' num2str(R) '_iteration_' num2str(bands_global_iteration) '_histogram.pdf'])
        close % close the figure
        cd ../
        cd(codeFolderName)

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Save values in a CSV file
        cd ../
        cd(resultsFolderName)
        % Save the best path
        filename_results=[filename '_' num2str(R) '_iteration_' num2str(bands_global_iteration) '_RHCP_values.csv'];
        results_mat = nodes_new_eval';
        % add a header
        cHeader = {'RHCP' 'l_tot/L'}; %header
        textHeader = strjoin(cHeader, ',');
        % write header to file
        fid = fopen(filename_results,'w');
        fprintf(fid,'%s\n',textHeader);
        fclose(fid);
        % write data in file
        dlmwrite(filename_results,results_mat,'-append');
        cd ../
        cd(codeFolderName)


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Update previous nodes and clear current nodes
        nodes_previous = nodes_new;
        nodes_previous_best = nodes_new_best;
        nodes_previous_eval = nodes_new_eval;
        nodes_previous_best_eval = nodes_new_best_eval;
        nodes_new = [];
        nodes_new_best = [];
        nodes_new_eval = [];
        nodes_new_best_eval = [];

    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Annealing Algorithm to refine best pathways
    [final_path,final_Eval] =  Annealing(nodes_previous_best, bestEval_band,annealingTime,disp_num,disp_size,binaryImage,fracParamZr,fracParamZrH,valueZrH,num_smoothing,desiredAngle,W,y_step);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Improve path
    final_path_improved = ImprovePaths(final_path,binaryImage,fracParamZr,fracParamZrH,valueZrH,num_smoothing,desiredAngle,W,y_step);
    final_Eval_improved = EvalPaths(final_path_improved,binaryImage,fracParamZr,fracParamZrH,valueZrH,desiredAngle,W,y_step);
    if final_Eval_improved(1,1) >= final_Eval(1,1)
        final_path = final_path_improved;
        final_Eval(1,:) = final_Eval_improved(1,:);
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Store the final path and its evaluated quality
    best_paths(:,R) = final_path;
    best_paths_eval(R,:) = final_Eval;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Select the best path out of all the different runs
[best_path_eval, best_path_ind] = max(best_paths_eval(:,1));
best_path = best_paths(:,best_path_ind);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define the Radial Hydride Continuous Path as the quality of the best path
RHCP = max(best_path_eval,0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot the current paths, along with the current bands
% Open the figure being studied
cd ../
cd(resultsFolderName)
BinaryImageName = [filename '_binary.tiff'];
BinaryImage = imread(BinaryImageName);
[num_rows, num_columns, numberOfColorChannels] = size(BinaryImage);
figure
imshow(BinaryImageName)
hold on

% Plot the paths
for i=1:size(best_path,2)
    % Plot the path on top of it
    path = [best_path(:,i) [1:size(best_path,1)]'];
    plot(path(:,1),path(:,2),'r-','LineWidth',3);
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
saveas(gcf,[filename '_Micrograph_Final_Paths.pdf'])
close % close the figure
cd ../
cd(codeFolderName)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Save the results in a .csv file in resultsFolderName

cd ../
cd(resultsFolderName)
% Save the best path
filename_results=[filename '_best_path_results.csv'];
results_mat=[[1:length_binaryImage]' best_path];
% add a header
cHeader = {'y' 'x'}; %header
textHeader = strjoin(cHeader, ',');
% write header to file
fid = fopen(filename_results,'w');
fprintf(fid,'%s\n',textHeader);
fclose(fid);

% write data in file
dlmwrite(filename_results,results_mat,'-append');
cd ../
cd(codeFolderName)



cd ../
cd(resultsFolderName)
% Save the best evaluation - RHCP
filename_results=[filename '_best_evaluation_RHCP.csv'];
results_mat=[ best_path_eval];
% add a header
cHeader = {'RHCP'}; %header
textHeader = strjoin(cHeader, ',');
% write header to file
fid = fopen(filename_results,'w');
fprintf(fid,'%s\n',textHeader);
fclose(fid);

% write data in file
dlmwrite(filename_results,results_mat,'-append');
cd ../
cd(codeFolderName)

end
