function [ ] = RHF_main(codeFolderName,imageFolderName,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution, lengthCut,resultsFolderName)
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
% - codeFolderName: The name of the folder in which the RHF code is stored.
% - imageFolderName: The name of the folder in which images are stored.
% - startingLowThreshold: The initial value for low threshold value ≥0 for the binarization process. To be adjusted in GUI. We recommend starting with 0.
% - startingHighThreshold: The initial value for high threshold value >(startingLowThreshold) for the binarization process. To be adjusted in GUI. We recommend starting with 255.
% - SpotSize: The binarization parameter to remove particles smaller than SpotSize in pixels. To be adjusted in GUI. We recommend starting with 0.
% - HoleSize: The binarization parameter to fill out holes smaller than HoleSize in pixels. To be adjusted in GUI. We recommend starting with 0.
% - resolution: The image resolution in dpi. Enter 0 if you want to use the resolution in the metadata of the images.
% - lengthCut: The length used to cut the hydrides to approximate them a straight lines. Use InF to select the whole hydrides.
% - resultsFolderName: The name of the folder in which the results will be stored. The folder is created if it does not already exist.

% Outputs:
% None, but at the end, the solfware will have created the result folder
% with the binarized images, the saved binarization parameters, as well as
% the measured Radial Hydride Fraction values.

% Example for a call:
% RHF_main('RHF_MatLab_Code','RHF_Validation_Microstructures',240,255,90,10,0,Inf,'RHF_Validation_Results')



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

RHF_folder( codeFolderName, imageFolderName, resultsFolderName, resolution, lengthCut);


end

