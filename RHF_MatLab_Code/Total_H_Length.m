function [ Hydride_Length ] = Total_H_Length( binaryImage,resolution)
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
% This function is called by RHF_file and determines the length of a
% hydride


% Inputs:
% - binaryImage: The binary image (should contain only one hydride)
% - resolution: The image resolution in dpi. Enter 0 if you want to use the resolution in the metadata of the images.

% Outputs:
% This function returns the length of the hydride on the binary image.


%%%%%%%%%%%%%%%%%%%%%%%%%% Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Hydride_Length=0;

%%%%%%%%%%%%%%%%%%%%%%% Derive hydride length %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Derive the perimeter of the hydride and devide it by 2 to get the
% length
perim = regionprops(binaryImage,'Perimeter');
lengthHydride = perim.Perimeter/2/ resolution;

% Add the maximum length to the length of hydrides
Hydride_Length=Hydride_Length+lengthHydride;
    
end