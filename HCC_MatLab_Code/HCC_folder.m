function [ ] = HCC_folder(codeFolderName, imageFolderName, resultsFolderName, resolution, Min_Segment_Length)
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
% This function is called by HCC_main and calls HCC_file for each 
% microstructure to measure its HCC.
% Once the analysis is over, it saves in the result folder a .csv file 
% containing the name and HCC values of all microstructures.

% Inputs:
% - codeFolderName: The name of the folder in which the RHF code is stored.
% - imageFolderName: The name of the folder in which images are stored.
% - resultsFolderName: The name of the folder in which the results will be stored. The folder is created if it does not already exist.
% - resolution: The image resolution in dpi. Enter 0 if you want to use the resolution in the metadata of the images.
% - Min_Segment_Length: Minimum length of the hydride projection that will be counted in HCC

% Outputs:
% None, but it saves in the result folder a .csv file containing the name 
% and HCC values of all microstructures.


%%%%%%%%%%%%%%%%%%%%%%% List all the images %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Takes the names of the images in the folder named imageFolderName and 
% create a list of their names stored in string and in double.
% Warning: images names need to contain numbers only

MyFolderInfo = dir2(['../' imageFolderName ]);
cd ../
cd(codeFolderName)
names_vect=strings(size(MyFolderInfo,1),1);
number_vect=zeros(size(MyFolderInfo,1),1);

size(MyFolderInfo,1)
for i=1:size(MyFolderInfo,1)
    names_vect(i)=MyFolderInfo(i).name;
    text = names_vect(i);
    text = extractBefore(text,'.tif');
    number_vect(i)=str2num(char(text));
end

%%%%%%%%%%%%%%%%%%%%% Analysis for each image %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create the vectors that will contain the results of the analysis
results_mat=zeros(length(number_vect),2);
for i=1:length(number_vect)
    if strlength(names_vect)>0
        % Perform the analysis of the microstructure 
        [HCC] = HCC_file(codeFolderName,imageFolderName,char(names_vect(i)), resultsFolderName, resolution, Min_Segment_Length);
        % Save the results for the final csv file
        results_mat(i,:)=[number_vect(i),HCC]; 
    end
end

%%%%%% Sort results_mat so that the list of image numbers is sorted %%%%%%%
results_mat=sortrows(results_mat,1);

%%%%%%%%% Save the results in a .csv file in resultsFolderName %%%%%%%%%%%%

cd ../
cd(resultsFolderName)
folderName_results=[imageFolderName '_results' '.csv'];
% add a header
cHeader = {'Image number' 'HCC'}; %header
textHeader = strjoin(cHeader, ',');
% write header to file
fid = fopen(folderName_results,'w'); 
fprintf(fid,'%s\n',textHeader);
fclose(fid);
% write data in file
dlmwrite(folderName_results,results_mat,'-append');
cd ../
cd(codeFolderName)

end
