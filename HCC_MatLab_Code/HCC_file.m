function [HCC] =  HCC_file(codeFolderName,imageFolderName, filename, resultsFolderName, resolution, Min_Segment_Length)
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
% This function is called by HCC_folder and measure the HCC of the
% microstructure given as input. It opens the given microstructure and
% performs the analysis.

% Inputs:
% - codeFolderName: The name of the folder in which the RHF code is stored.
% - imageFolderName: The name of the folder in which images are stored.
% - filename: Name of the microstructure file.
% - resultsFolderName: The name of the folder in which the results will be stored. The folder is created if it does not already exist.
% - resolution: The image resolution in dpi. Enter 0 if you want to use the resolution in the metadata of the images.
% - Min_Segment_Length: Minimum length of the hydride projection that will be counted in HCC

% Outputs:
% This function returns the HCC value for the input microstructure.

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
hydride_segments_length = HydrideSegments(binaryImage,Min_Segment_Length);
sum_Segments = sum(hydride_segments_length);

% Derive HCC
HCC = sum_Segments/size(binaryImage,1); 


end