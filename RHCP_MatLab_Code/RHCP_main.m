function [ ] = RHCP_main(codeFolderName,imageFolderName,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution,resultsFolderName, PerCut, tolConvergence, numPaths, Mutation, primary_nodes_dist, disp_num, disp_size, annealingTime, numRun, CPMax, num_smoothing, fracParamZr, fracParamZrH, valueZrH, num_bands, bridge_criteria_ratio, plotFrequency, desiredAngle, W, y_step)
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
% Main function of the software. It initializes the workspace, determines
% the images resolution, launches image binarization, and launches the
% analysis.

% Inputs:
% - codeFolderName: The name of the folder in which the RHCP code is stored.
% - imageFolderName: The name of the folder in which images are stored.
% - startingLowThreshold: The initial value for low threshold value ≥0 for the binarization process. To be adjusted in GUI. We recommend starting with 0.
% - startingHighThreshold: The initial value for high threshold value >(startingLowThreshold) for the binarization process. To be adjusted in GUI. We recommend starting with 255.
% - SpotSize: The binarization parameter to remove particles smaller than SpotSize in pixels. To be adjusted in GUI. We recommend starting with 0.
% - HoleSize: The binarization parameter to fill out holes smaller than HoleSize in pixels. To be adjusted in GUI. We recommend starting with 0.
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
% None, but at the end, the solfware will have created the result folder
% with the binarized images, the saved binarization parameters, as well as
% the measured Radial Hydride Continuous Path values.

% Example for a call:
% RHCP_main('RHCP_MatLab_Code','RHCP_Validation_Microstructures',100,255,60,10,0,'RHCP_Validation_Results', 0.01, 1e-4, 50, 0.05, 1, 20, 20, 1000, 1, 50001, 1, 50, 1, 1, 5, 0.6, 1000, nan, 13, 10)

%%%%%%%%%%%%%%%%%%%%%%%%% Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CLEAN UP THE WORKSPACE
cleanWorkSpace()

% Create a new folder for the results 
cd ../
mkdir(resultsFolderName)
cd(codeFolderName)

%%%%%%%%%%%%%%%%%%%% Get the image resolution %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

resolution = imageResolution( codeFolderName, imageFolderName, resolution );

%%%%%%%%%%%%%%%%%%%%%% Binarize the images %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

imageBinary_folder( codeFolderName, imageFolderName, startingLowThreshold, startingHighThreshold, SpotSize, HoleSize, resultsFolderName );

%%%%%%%%%%%%%%%%%%% Analyse the binary images %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

RHCP_folder(codeFolderName, imageFolderName, resultsFolderName, resolution, PerCut, tolConvergence, numPaths, Mutation, primary_nodes_dist, disp_num, disp_size, annealingTime, numRun, CPMax, num_smoothing, fracParamZr, fracParamZrH, valueZrH, num_bands, bridge_criteria_ratio, plotFrequency, desiredAngle, W, y_step);

end