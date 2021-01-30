function [ binaryImage,lowThreshold, highThreshold, SpotSize, HoleSize, removeBorders ] = imageBinary(codeFolderName, ImageFolderName,filename, startingLowThreshold, startingHighThreshold, SpotSize, HoleSize, resultsFolderName )
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
% This function is called by imageBinary_folder.m and calls thershold.m,
% the GUI function, to let the user select the appropriate binarization
% parameters. imageBinary.m then binarizes the image using these parameters
% and save the parameters and the binary image.
% If the binary parameters were already determined and saved in the result
% folder, then it will use these to binarize the figures again.


% Inputs:
% - codeFolderName: The name of the folder in which the RHF code is stored.
% - imageFolderName: The name of the folder in which images are stored.
% - filename: Name of the microstructure file.
% - startingLowThreshold: The initial value for low threshold value ≥0 for the binarization process. To be adjusted in GUI. We recommend starting with 0.
% - startingHighThreshold: The initial value for high threshold value >(startingLowThreshold) for the binarization process. To be adjusted in GUI. We recommend starting with 255.
% - SpotSize: The binarization parameter to remove particles smaller than SpotSize in pixels. To be adjusted in GUI. We recommend starting with 0.
% - HoleSize: The binarization parameter to fill out holes smaller than HoleSize in pixels. To be adjusted in GUI. We recommend starting with 0.
% - resultsFolderName: The name of the folder in which the results will be stored. The folder is created if it does already exist.

% Outputs:
% imageBinary.m returns the binary image as well as the binarization
% parameters selected by the user. It also saves them in the result folder.


%%%%%%% Check if that user has the Image Processing Toolbox installed %%%%%
hasIPT = license('test', 'image_toolbox');
if ~hasIPT
	% User does not have the toolbox installed.
	message = sprintf('Sorry, but you do not seem to have the Image Processing Toolbox.\nDo you want to try to continue anyway (Not recommended, as this will not work)? \n To install the toolbox, if you have a recent version, on the main MATLAB window, go to __Home>Adds-Ons>Get Adds-Ons__ and find the Image processing toolbox. Otherwise, visit: https://www.mathworks.com/matlabcentral/answers/101885-how-do-i-install-additional-toolboxes-into-an-existing-installation-of-matlab');
	reply = questdlg(message, 'Toolbox missing', 'Yes', 'No', 'Yes');
	if strcmpi(reply, 'No')
		% User said No, so exit.
		return;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Open the image %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd ../
cd(ImageFolderName)
I = imread(filename);
cd ../
cd(codeFolderName)

%%%%%%%%% Copy this image in current folder to use it in threshold %%%%%%%%
% It will be deleted later
copyfile(['../' ImageFolderName '/' filename], ['../' codeFolderName ],'f')

%%%%%%%%%%%%%%% Check if the image has already been binarized %%%%%%%%%%%%%
% if the image was already binarized, we use old values, otherwise we
% define new ones
cd ../
cd(resultsFolderName)
filename_param=[filename '_BinaryParam' '.csv'];
existfile= exist(filename_param,'file');

if (existfile == 2 )
    tab=csvread(filename_param,1,0);
    lowThreshold=tab(1);
    highThreshold=tab(2);
    SpotSize=tab(3);
    HoleSize=tab(4);
    removeBorders=tab(5);
    background_bool=tab(6);
    background_value=tab(7);
    cd ../
    cd (codeFolderName)
else
    cd ../
    cd (codeFolderName)
    % Use threshold to define the parameters of the binarization process %%
    removeBorders = 0;
    background_bool = 0;
    background_value = 1;
    [lowThreshold, highThreshold, SpotSize, HoleSize, removeBorders, background_bool, background_value  ] = threshold(startingLowThreshold, startingHighThreshold, SpotSize, HoleSize, removeBorders, background_bool, background_value, filename);
end

%%%%%%%%%%%%% Save the results in a .csv file in result folder %%%%%%%%%%%%
cd ../
cd(resultsFolderName)
param_mat=[lowThreshold highThreshold SpotSize HoleSize removeBorders background_bool background_value];
% add a header
cHeader = {'low_Threshold' 'high_Threshold' 'Spot_size' 'Hole_size' 'Remove_Borders' 'Non_uniform_background' 'Non_uniform_background_value'}; %header
textHeader = strjoin(cHeader, ',');
% write header to file
fid = fopen(filename_param,'w');
fprintf(fid,'%s\n',textHeader);
fclose(fid);
% write data in file
dlmwrite(filename_param,param_mat,'-append');
cd ../
cd (codeFolderName)


%%%%%%%%%%%%%%%%%%%%%%%%%%%% Binarize the image %%%%%%%%%%%%%%%%%%%%%%%%%%%

% Determine and remove the background
if background_bool
    se = strel('disk',background_value);
    I = imcomplement(I);
    background = imopen(I,se);
    % Remove the background from the image
    I2 = I - background;
    % adjust the intensity of the light
    I3 = imadjust(I2);
    I3 = imcomplement(I3);
else
    I3 = I;
end

% Binarize the image using the high and low thresholds
binaryImage = imcomplement((lowThreshold <= I3) & (I3 <= highThreshold));

% Remove the black pixels at the borders of the image if required
if removeBorders
    % Fill in the body
    mask = imfill(imcomplement(binaryImage), 'holes'); % Mask is whole solid body.
    % XOR the two images
    binaryImage=xor(mask,imcomplement(binaryImage));
end

% Erase the cluster of less than SpotSize pixels
binaryImage = bwareaopen(binaryImage, SpotSize);

% Fill the holes in smaller than HoleSize pixels
binaryImage = imcomplement(bwareaopen(imcomplement(binaryImage), HoleSize));

% Thin the hydride to a single pixel
% This provides better results and fastens the algorithm because less
% information is being treated.
binaryImage = bwmorph(binaryImage,'thin',Inf);

% Erase the cluster of less than Nsize pixels
Nsize2=2;
binaryImage = bwareaopen(binaryImage, Nsize2);

% Save the binary image in the results folder in the form of a .tiff image,
% to be used later by the program
fig = figure;
imshow(imcomplement(binaryImage),'InitialMagnification', 'fit')
cd ../
cd(resultsFolderName)
% Save the tiff file
filename_binary_tiff=[filename '_binary' '.tiff'];
imwrite(imcomplement(binaryImage),filename_binary_tiff,'tiff')
filename_binary_jpeg=[filename '_binary' '.jpeg'];
imwrite(imcomplement(binaryImage),filename_binary_jpeg,'jpeg')
cd ../
cd(codeFolderName)
% Delete the file that was created
delete(filename)

close


end
