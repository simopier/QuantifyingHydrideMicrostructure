function [ ] = HCC_main(codeFolderName,imageFolderName,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution,resultsFolderName, Min_Segment_Length)
%-------------------------------------------------------------------------%
%                                                                         %
%       Script developed by Pierre-Clement A Simon and Cailon Frank       %
%       From Penn State University                                        %
%                                                                         %
%       Definition originally proposed in                                 %
%           Bell L, Duncan R. 1975. Hydride orientation in Zr-2.5%Nb;     %
%           How it is affected by stress, temperature and heat treatment. %
%           Report AECL-5110                                              %
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
% Warning: this code does not take into account the limit size of the
% rectangle section being studied as described in the original paper.

% Inputs:
% - codeFolderName: The name of the folder in which the RHF code is stored.
% - imageFolderName: The name of the folder in which images are stored.
% - startingLowThreshold: The initial value for low threshold value ≥0 for the binarization process. To be adjusted in GUI. We recommend starting with 0.
% - startingHighThreshold: The initial value for high threshold value >(startingLowThreshold) for the binarization process. To be adjusted in GUI. We recommend starting with 255.
% - SpotSize: The binarization parameter to remove particles smaller than SpotSize in pixels. To be adjusted in GUI. We recommend starting with 0.
% - HoleSize: The binarization parameter to fill out holes smaller than HoleSize in pixels. To be adjusted in GUI. We recommend starting with 0.
% - resolution: The image resolution in dpi. Enter 0 if you want to use the resolution in the metadata of the images.
% - resultsFolderName: The name of the folder in which the results will be stored. The folder is created if it does not already exist.
% - Min_Segment_Length: Minimum length of the hydride projection that will be counted in HCC

% Outputs:
% None, but at the end, the solfware will have created the result folder
% with the binarized images, the saved binarization parameters, as well as
% the measured Hydride Continuity Coefficient values.

% Example for a call:
% HCC_main('HCC_MatLab_Code','HCC_Validation_Microstructures',100,255,60,10,0,'HCC_Validation_Results', 5)

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

%%%%%%%%%%%%%%%%%%% Analyse the binary images, *start of connectivity code* %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

HCC_folder(codeFolderName, imageFolderName, resultsFolderName, resolution, Min_Segment_Length);


end

