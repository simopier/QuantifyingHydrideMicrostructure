function [ ] = RHCF_main(codeFolderName,imageFolderName,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution,resultsFolderName, band_width)
%-------------------------------------------------------------------------%
%                                                                         %
%       Script developed by Pierre-Clement A Simon and Cailon Frank       %
%       From Penn State University                                        %
%                                                                         %
%       Definition originally proposed in                                 %
%           Billone MC, Burtseva TA, Einziger RE. 2013. Ductile-to-brittle%
%           transition temperature for high-burnupcladding alloys exposed %
%           to simulated drying-storage conditions.                       %
%           Journal of Nuclear Materials 433:431–448                      %
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

% Outputs:
% None, but at the end, the solfware will have created the result folder
% with the binarized images, the saved binarization parameters, as well as
% the measured Radial Hydride Continuity Fraction values.

% Example for a call:
% RHCF_main('RHCF_MatLab_Code','RHCF_Validation_Microstructures',100,255,60,10,0,'RHCF_Validation_Results',100)

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

RHCF_folder( codeFolderName, imageFolderName, resultsFolderName, resolution, band_width);


end

