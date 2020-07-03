function [ ] = imageBinary_folder( codeFolderName, ImageFolderName, startingLowThreshold, startingHighThreshold, SpotSize, HoleSize, resultsFolderName  )
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
% This function is called by RHF_main.m and call imageBinary.m to binarize
% the microstructures in ImageFolderName. Binarizing the image is the first
% and one of the most important steps of the algorithm. The aim is to keep 
% only the hydrides in the image. The GUI helps the user define the 
% binarization parameters.
% If the binary parameters were already determined and saved in the result 
% folder, then it will use these to binarize the figures again.


% Inputs:
% - codeFolderName: The name of the folder in which the RHF code is stored.
% - imageFolderName: The name of the folder in which images are stored.
% - startingLowThreshold: The initial value for low threshold value ≥0 for the binarization process. To be adjusted in GUI. We recommend starting with 0.
% - startingHighThreshold: The initial value for high threshold value >(startingLowThreshold) for the binarization process. To be adjusted in GUI. We recommend starting with 255.
% - SpotSize: The binarization parameter to remove particles smaller than SpotSize in pixels. To be adjusted in GUI. We recommend starting with 0.
% - HoleSize: The binarization parameter to fill out holes smaller than HoleSize in pixels. To be adjusted in GUI. We recommend starting with 0.
% - resultsFolderName: The name of the folder in which the results will be stored. The folder is created if it does already exist.

% Outputs:
% None, but this function will end up saving the binary parameters in the
% result folder, as well as the binarized images.


%%%%%%%%%%%%%%%%%%%%%%%%% List all the images %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Takes the names of the images in the folder named ImageFolderName and 
% create a list of their names stored in string and in double.
% Warning: images names need to contain numbers only

cd ../
MyFolderInfo = dir2(ImageFolderName);
cd(codeFolderName)
names_vect=strings(size(MyFolderInfo,1),1);
number_vect=zeros(size(MyFolderInfo,1),1);
for i=1:size(MyFolderInfo,1)
    names_vect(i)=MyFolderInfo(i).name;
    text = names_vect(i);
    text = extractBefore(text,'.tif');
    number_vect(i)=str2num(char(text));
end

%%%%% Define the initial binarization parameters with the first image %%%%%

% Binarizing the image is the first and one of the most important steps
% of the algorithm. The aim is to keep only the hydrides in the image. The
% GUI helps the user define the binarization parameters.
filename=char(names_vect(1));
[ binaryImage,lowThreshold,highThreshold,SpotSize,HoleSize] = imageBinary(codeFolderName,ImageFolderName,filename,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resultsFolderName);
close

%%%%%%%%%%% Define the binarization parameters for all images %%%%%%%%%%%%%
for i=1:length(names_vect)
    if strlength(names_vect)>0
        % Binarize the image
        [ binaryImage,lowThreshold,highThreshold,SpotSize,HoleSize ] = imageBinary(codeFolderName,ImageFolderName,char(names_vect(i)),lowThreshold,Inf,SpotSize,HoleSize,resultsFolderName);
    end
end


end

