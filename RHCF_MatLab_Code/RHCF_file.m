function [RHCF] = RHCF_file(codeFolderName,imageFolderName, filename, resultsFolderName, resolution, band_width)
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
% This function is called by RHCF_folder and measure the RHCF of the
% microstructure given as input. It opens the given microstructure and
% performs the analysis.

% Inputs:
% - codeFolderName: The name of the folder in which the RHF code is stored.
% - imageFolderName: The name of the folder in which images are stored.
% - filename: Name of the microstructure file.
% - resultsFolderName: The name of the folder in which the results will be stored. The folder is created if it does not already exist.
% - resolution: The image resolution in dpi. Enter 0 if you want to use the resolution in the metadata of the images.
% - band_width: Width of the band used at the center of the image to derive the RHCP. To normalize the size of the band, it is miltiplied by the image resolution.

% Outputs:
% This function returns the RHCF value for the input microstructure.


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
hydride_segments_lengths = HydrideSegments(binaryImage);

% Get longest continuous radial segment of hydrides
Max_Segment = max(hydride_segments_lengths);

% Derive RHCF
RHCF = Max_Segment/size(binaryImage,1);


end
