function [ ] = Verification_Continuity( codeFolderNameRHCF,codeFolderNameHCC,codeFolderNameRHCP,imageFolderName,imageFolderNameExpectedContinuity,csvfilename_Expected,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution,resultsFolderNameRHCF,resultsFolderNameHCC,resultsFolderNameRHCP, Min_Segment_Length, PerCut, tolConvergence, numPaths, Mutation, primary_nodes_dist, disp_num, disp_size, annealingTime, numRun, CPMax, num_smoothing,fracParamZr,fracParamZrH,valueZrH, num_bands, bridge_criteria_ratio, plotFrequency,desiredAngle,W,y_step)
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
% Verification_Continuity performs the verification of the HCC, RHCF, RHCP
% codes on the microstructures in imagesFolderName with the expected
% results in imageFolderNameExpectedContinuity and stores the results in 
% resultsFolderName
% The results consist of the analysis of each microstructure, and a file
% containing the error of the predictions of the HCC, RHCF, and RHCP
% analysis.

% Inputs:
% - codeFolderNameRHCF: The name of the folder in which the RHCF code is stored.
% - codeFolderNameHCC: The name of the folder in which the HCC code is stored.
% - codeFolderNameRHCP: The name of the folder in which the RHCP code is stored.
% - imageFolderName: The name of the folder in which images are stored.
% - imageFolderNameExpectedContinuity: The name of the folder containing the expected results.
% - csvfilename_Expected: The name of the .csv file in the folder containing the expected results.
% - startingLowThreshold: The initial value for low threshold value ≥0 for the binarization process. To be adjusted in GUI. We recommend starting with 0.
% - startingHighThreshold: The initial value for high threshold value >(startingLowThreshold) for the binarization process. To be adjusted in GUI. We recommend starting with 255.
% - SpotSize: The binarization parameter to remove particles smaller than SpotSize in pixels. To be adjusted in GUI. We recommend starting with 0.
% - HoleSize: The binarization parameter to fill out holes smaller than HoleSize in pixels. To be adjusted in GUI. We recommend starting with 0.
% - resolution: The image resolution in dpi. Enter 0 if you want to use the resolution in the metadata of the images.
% - resultsFolderNameRHCF: The name of the folder in which the RHCF results will be stored. The folder is created if it does not already exist.
% - resultsFolderNameHCC: The name of the folder in which the HCC results will be stored. The folder is created if it does not already exist.
% - resultsFolderNameRHCP: The name of the folder in which the RHCP results will be stored. The folder is created if it does not already exist.
% - Min_Segment_Length: Minimum length of the hydride projection that will be counted in HCC.
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
% None, but at the end, the solfware will have created the result folders
% with the binarized images, the saved binarization parameters, as well as
% the measured HCC, RHCF, and RHCP values as well as the errors in 
% predictions.

% Example for a call:
% see Verification_Continuity_script.m

%%%%%%%%%%%%%%%%%% Perform analysis for each definition %%%%%%%%%%%%%%%%%%%
cd ../
cd(codeFolderNameRHCF)
RHCF_main(codeFolderNameRHCF,imageFolderName,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution,resultsFolderNameRHCF)
cd ../
cd(codeFolderNameHCC)
HCC_main(codeFolderNameHCC,imageFolderName,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution,resultsFolderNameHCC, Min_Segment_Length)
cd ../
cd(codeFolderNameRHCP)
RHCP_main(codeFolderNameRHCP,imageFolderName,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution,resultsFolderNameRHCP, PerCut, tolConvergence, numPaths, Mutation, primary_nodes_dist, disp_num, disp_size, annealingTime, numRun, CPMax, num_smoothing,fracParamZr,fracParamZrH,valueZrH, num_bands, bridge_criteria_ratio, plotFrequency,desiredAngle,W,y_step)

%%%%%%%%%%%%%%%%%%%%%%%% Upload expected results %%%%%%%%%%%%%%%%%%%%%%%%%%
% Find the .csv file containing the expected results for microstructures in
% the folder imagesFolderName, and load the values in a vector
cd ../
cd(imageFolderNameExpectedContinuity)
Expected_values = csvread(csvfilename_Expected,1, 0);
sortrows(Expected_values,1);
RHCF_Expected = Expected_values(:,2);
HCC_Expected = Expected_values(:,3);
if isnan(desiredAngle)
    ind = 4;
else
    ind = 5;
end
RHCP_Expected = Expected_values(:,ind);

%%%%%%%%%%%%%%%%%%%%%%%%% Upload Measurements %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find the .csv file containing the measured results for microstructures in
% the folder resultsFolderName, and load the values in a vector
cd ../
cd(resultsFolderNameRHCF)
RHCF_Experimental = csvread([imageFolderName '_results.csv'],1, 0);
RHCF_Experimental = sortrows(RHCF_Experimental,1);
cd ../
cd(resultsFolderNameHCC)
HCC_Experimental = csvread([imageFolderName '_results.csv'],1, 0);
HCC_Experimental = sortrows(HCC_Experimental,1);
cd ../
cd(resultsFolderNameRHCP)
RHCP_Experimental = csvread([imageFolderName '_results.csv'],1, 0);
RHCP_Experimental = sortrows(RHCP_Experimental,1);
cd ../
cd(resultsFolderNameRHCP)

%%%%%%%%%%%%%%%%%%%%%%%%%%% Calculate error %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate the error percentage for each microstructure
 % vector containing the error of the measured RHF
for i=1:length(RHCF_Expected)
errorRHCF_vect(i) =abs(RHCF_Expected(i)-RHCF_Experimental(i,2))/RHCF_Expected(i)*100;% Calculate the error percentage for each microstructure
 % vector containing the error of the measured RHF
end
for i=1:length(HCC_Expected)
errorHCC_vect(i) =abs(HCC_Expected(i)-HCC_Experimental(i,2))/HCC_Expected(i)*100;% Calculate the error percentage for each microstructure
 % vector containing the error of the measured RHF
end
for i=1:length(RHCP_Expected)
errorRHCP_vect(i) =abs(RHCP_Expected(i)-RHCP_Experimental(i,2))/RHCP_Expected(i)*100;% Calculate the error percentage for each microstructure
 % vector containing the error of the measured RHF
end


%%%%%%%%%%% Save the errors in a csv file in the results folder %%%%%%%%%%%
results_mat=[[1: length(errorRHCP_vect)]' RHCF_Experimental(:,2) RHCF_Expected  errorRHCF_vect' HCC_Experimental(:,2) HCC_Expected errorHCC_vect' RHCP_Experimental(:,2) RHCP_Expected errorRHCP_vect'];
resultsContinuityErrorName=[imageFolderName '_Verification_results' '.csv'];
% add a header
cHeader = {'Image number' 'RHCF measured' 'RHCF expected' 'RHCF error' 'HCC measured' 'HCC expected' 'HCC error' 'RHCP measured' 'RHCP expected' 'RHCP error'}; %header
textHeader = strjoin(cHeader, ',');
% write header to file
fid = fopen(resultsContinuityErrorName,'w'); 
fprintf(fid,'%s\n',textHeader);
fclose(fid);
% write data in file
dlmwrite(resultsContinuityErrorName,results_mat,'-append');
cd ../
cd(codeFolderNameRHCP)


%%%%%%%%%%%%%%%%%%%%%%%% Plot the results %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Plot the micrographs with the best path found
cd ../
cd(resultsFolderNameRHCP)
% Go through the figures
for i=1:length(RHCP_Experimental)
    % Open the figure
    figure
    imshow([num2str(i) '.tif_binary.tiff'])
    hold on
    % Plot the path on top of it
    path = csvread([num2str(i) '.tif_best_path_results' '.csv'],1,0); %first column is y, second column is x
    plot(path(:,2),path(:,1),'r:','LineWidth',3)
    plot([1 size(path(:,2),1)+90],[1 1],'k-','LineWidth',1)
    plot([1 size(path(:,2),1)-1+90],[size(path(:,2),1) size(path(:,2),1)],'k-','LineWidth',1)
    plot([1 1],[1 size(path(:,2),1)],'k-','LineWidth',1)
    plot([size(path(:,2),1)-1+88 size(path(:,2),1)-1+88],[1 size(path(:,2),1)],'k-','LineWidth',1)
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
    saveas(gcf,[num2str(RHCP_Experimental(i)) '_Micrograph_Path.pdf'])
end

cd ../
cd(codeFolderNameRHCP)

end

