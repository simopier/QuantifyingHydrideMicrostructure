function [HCC] =  HCC_file(codeFolderName,imageFolderName, filename, resultsFolderName, resolution, Min_Segment_Length, band_width)
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
% - Min_Segment_Length: Minimum length of the hydride projection that will be counted in HCC.
% - band_width: is the width of the band used to derive HCC. The unit depends on the unit of the variable 'resolution'. d = 0.11 mm. . Use Inf to use the entire image.

% Outputs:
% This function returns the HCC value for the input microstructure.

%%%%%%%%%%%%%%%%%%%%% Find and open the images %%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd ../
cd(resultsFolderName)
binaryImage = imcomplement(imread([filename '_binary' '.tiff']));
cd ../
cd(codeFolderName)

%%%%%%%%%%%%%%%%%% Determine the image resolution %%%%%%%%%%%%%%%%%%%%%%%%%

if resolution==0
    cd ../
    cd(imageFolderName)
    info = imfinfo(filename);
    resolution=info.XResolution;
    cd ../
    cd(codeFolderName)
end

%%%%%%%%%%%%%%% Selects the center band of the image %%%%%%%%%%%%%%%%%%%%%%

% Only select the center band if the desired band width is smaller than
% image size
if band_width*resolution < size(binaryImage,2)
    % select the center band
    band_start = round(size(binaryImage,2)/2-band_width*resolution/2);
    band_end = round(size(binaryImage,2)/2+band_width*resolution/2);
    % Warning message if band_width is too small for the image to possess
    % more than 10 pixels
    if band_end-band_start < 10
        disp('Warning: The band_width is probably too small')
        pause(10)
    end
    binaryImage = binaryImage(:,band_start:band_end);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get the length of the projected hydrides
hydride_segments_length = HydrideSegments(binaryImage,Min_Segment_Length);
sum_Segments = sum(hydride_segments_length);

% Derive HCC
HCC = sum_Segments/size(binaryImage,1); 


end