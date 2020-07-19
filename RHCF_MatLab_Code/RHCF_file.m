function [RHCF] = RHCF_file(codeFolderName,imageFolderName, filename, resultsFolderName, resolution)
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
%           Quantifying zirconium embrittlement due to hydride            %
%           microstructure using image analysis                           %
%           https:// ...                                                  %
%                                                                         %
%       Full MATLAB Code available at:                                    %
%           https://github.com/simopier/QuantifyingHydrideMicrostructure  %
%                                                                         %
%-------------------------------------------------------------------------%

% Description:
% This function is called by RHCF_folder and measure the RHCF of the
% microstructure given as input. It opens the given microstructure and
% performs the analysis.

% Inputs:
% - codeFolderName: The name of the folder in which the RHF code is stored.
% - imageFolderName: The name of the folder in which images are stored.
% - filename: Name of the microstructure file.
% - resultsFolderName: The name of the folder in which the results will be stored. The folder is created if it does not already exist.
% - resolution: The image resolution in dpi. Enter 0 if you want to use the resolution in the metadata of the images.

% Outputs:
% This function returns the RHCF value for the input microstructure.


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

% Get the length of the projected hydrides
hydride_segments_lengths =HydrideSegments(binaryImage);

% Get longest continuous radial segment of hydrides
Max_Segment = max(hydride_segments_lengths);

% Derive RHCF
RHCF = Max_Segment/size(binaryImage,1);


end