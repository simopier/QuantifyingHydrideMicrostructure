function [ binaryImage,lowThreshold, highThreshold, SpotSize, HoleSize, removeBorders ] = imageBinary(codeFolderName, ImageFolderName,filename, startingLowThreshold, startingHighThreshold, SpotSize, HoleSize, resultsFolderName )

%-------------------------------------------------------------------------%
%                                                                         %
%       Script developed by Cailon Frank and Pierre-Clement Simon         %
%       Penn State University                                             %
%                                                                         %
%-------------------------------------------------------------------------%


%imageBinary takes in argument the filename and the name of the folder
% containing this file, the starting low threshold, the starting high
% threshold for the binarization of the image, and the size (in pixels) of
% the spots that should be removed.
% It also gives the option to show the initial and final images. It lets
% the user define the low and high threshold values as well as the spot
% size.

%% OPEN, BINARIZE, AND CLEAN IMAGE
% Binarizing the image is the first and one of the most important steps
% of the algorithm. The aim is to keep only the hydrides in the image. The
% user can be asked to validate the binary image after making sure that all
% hydrides, and only hydrides, are present. The user can validate the
% image, or change the parameters of the binarization process.

% The first argument of the imageBinary function is the name of the file
% the user want to analyse. The second is the threshold value for the
% binarization. The higher the threshold, the more pixels will be kept.

% The second argument of the imageBinary function is the size of the
% smallest group of pixels that will be kept. Any group of pixels with a
% lower number of pixels that this value will be deleted in the picture.
% This is useful to remove the noise or some impurities in the image.
% The parameters defined during this step will be used for the rest of the
% images

% Check that user has the Image Processing Toolbox installed.
hasIPT = license('test', 'image_toolbox');
if ~hasIPT
	% User does not have the toolbox installed.
	message = sprintf('Sorry, but you do not seem to have the Image Processing Toolbox.\nDo you want to try to continue anyway?');
	reply = questdlg(message, 'Toolbox missing', 'Yes', 'No', 'Yes');
	if strcmpi(reply, 'No')
		% User said No, so exit.
		return;
	end
end

% Open the image
cd ../
cd(ImageFolderName)
I = imread(filename);
cd ../
cd(codeFolderName)

% Copy this image in current folder to use it in threshold. It will be
% deleted later
copyfile(['../' ImageFolderName '/' filename], ['../' codeFolderName ],'f')

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
    % Use threshold to define the parameters of the binarization process
		removeBorders = 0;
		background_bool = 0;
		background_value = 1;
    [lowThreshold, highThreshold, SpotSize, HoleSize, removeBorders, background_bool, background_value ] = threshold(startingLowThreshold, startingHighThreshold, SpotSize, HoleSize, removeBorders, background_bool, background_value, filename);
end
% SAVE THE RESULTS IN A FILE IN THE FOLDER RESULTS
cd ../
cd(resultsFolderName)
param_mat=[lowThreshold highThreshold SpotSize HoleSize removeBorders  background_bool background_value];
% add a header
cHeader = {'low_Threshold' 'high_Threshold' 'Spot_size' 'Hole_size' 'Remove_Borders'  'Non_uniform_background' 'Non_uniform_background_value'}; %header
textHeader = strjoin(cHeader, ',');
% write header to file
fid = fopen(filename_param,'w');
fprintf(fid,'%s\n',textHeader);
fclose(fid);

% write data in file
dlmwrite(filename_param,param_mat,'-append');
cd ../
cd (codeFolderName)


%binarize the image, and take the complement of it (white pixels represents
%the hydride in binaryImage, which allows to store less information) with a threshold
%at limitB. When we plot the figure, we plot the complement of binaryImage, because we
%want black pixels (zeros) to represent the hydride on the figure.


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


binaryImage = imcomplement((lowThreshold <= I3) & (I3 <= highThreshold));
% Remove the black pixels at the borders of the image
if removeBorders
    % Fill in the body
    mask = imfill(imcomplement(binaryImage), 'holes'); % Mask is whole solid body.
    % XOR the two images
    binaryImage=xor(mask,imcomplement(binaryImage));
end
% Erase the cluster of less than SpotSize pixels (clean the image from isolated
%groups of pixels)
binaryImage = bwareaopen(binaryImage, SpotSize);
% fill the small holes in the hydrides
binaryImage = imcomplement(bwareaopen(imcomplement(binaryImage), HoleSize));

% the hydride is reduced to a curve with a thickness of one pixel. This
% provides better results for the curvature measurements, and fastens the
% algorithm because less information is being treated.
binaryImage = bwmorph(binaryImage,'thin',Inf);
% Erase the cluster of less than Nsize pixels (clean the image from isolated
%groups of pixels)
Nsize2=2;
binaryImage = bwareaopen(binaryImage, Nsize2);
% thicken the hydrides to make them easier to find for the genetic
% algorithm
% binaryImage = bwmorph(binaryImage,'thicken',0);
se1 = strel('line',2,90);
se2 = strel('line',2,0);
binaryImage = imdilate(binaryImage,[se1,se2],'full');

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
