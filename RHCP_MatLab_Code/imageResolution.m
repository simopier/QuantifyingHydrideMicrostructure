function [resolution] = imageResolution( codeFolderName, imageFolderName, resolution )
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
% imageResolution defines the resolution of the images. This function is
% called by RHF_main to determine the image resolution.

% Inputs:
% - codeFolderName: The name of the folder in which the RHF code is stored.
% - imageFolderName: The name of the folder in which images are stored.
% - resolution: The image resolution in dpi. Enter 0 if you want to use the resolution in the metadata of the images.

% Outputs:
% The output depends on the value of resolution gien  as input:
%   - if reolution is equal to 0, it checks the value stored in the image
%   matadata. If there is none, it asks the user to provide one
%   - if resolution is equal to a positive value, it uses this value as the
%   resolution
%   - if the resolution is negative, it asks the user to provide another
%   value
% The function outputs the resolution (still equal to 0 if the resolution 
% of the images is to be used)


%%%%%%%%%%%%%%%%%% Determine the image resolution %%%%%%%%%%%%%%%%%%%%%%%%%

if resolution ==0
    % Finds the resolution of one of the images
    MyFolderInfo = dir2(['../' imageFolderName ]);
    cd ../
    filename=MyFolderInfo(1).name;
    cd(imageFolderName)
    info = imfinfo(filename);
    cd ../
    cd(codeFolderName)
    resolution = info.XResolution;
    % if no resolution is stored in the metadata, ask the user to define
    % the resolution
    if length(resolution)<1
        fprintf(['The image named ' filename ' did not have any information about its resolution in dpi. \n'])
        prompt ='Which resolution do you want to use in dpi ? \n ';
        resolution=input(prompt);
    else
        resolution = 0;
    end

else
    % if the input was negative, it asks to redefine it
    if resolution<0
        fprintf('The provided value for the resolution was negative. \n')
        prompt ='Which resolution do you want to use in dpi ? \n(Enter 0 to use the resolution saved in the image metadata) \n ';
        resolution=input(prompt);
    end
end


end