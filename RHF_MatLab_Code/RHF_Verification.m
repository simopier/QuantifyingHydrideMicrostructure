function [ error_vect ] = RHF_Verification( codeFolderName,imageFolderName,imageFolderNameExpectedRHF,csvfilename_Expected,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution, lengthCut,resultsFolderName)
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
% This function is used for the verification of the RHF definition and
% implementation. It is called by RHF_Verification_Script.m to perform the
% analysis. It calls RHF_main to measure the RHF of verification
% microstructures.

% Inputs:
% - codeFolderName: The name of the folder in which the RHF code is stored.
% - imageFolderName: The name of the folder in which images are stored.
% - imageFolderNameExpectedRHF: Name of the folder containing the expected values for RHF.
% - csvfilename_Expected: Name of the .csv file in imageFolderNameExpectedRHF containing the list of the microstructures names and expected RHF values.
% - startingLowThreshold: The initial value for low threshold value ≥0 for the binarization process. To be adjusted in GUI. We recommend starting with 0.
% - startingHighThreshold: The initial value for high threshold value >(startingLowThreshold) for the binarization process. To be adjusted in GUI. We recommend starting with 255.
% - SpotSize: The binarization parameter to remove particles smaller than SpotSize in pixels. To be adjusted in GUI. We recommend starting with 0.
% - HoleSize: The binarization parameter to fill out holes smaller than HoleSize in pixels. To be adjusted in GUI. We recommend starting with 0.
% - resolution: The image resolution in dpi. Enter 0 if you want to use the resolution in the metadata of the images.
% - lengthCut: The length used to cut the hydrides to approximate them a straight lines. Use InF to select the whole hydrides.
% - resultsFolderName: The name of the folder in which the results will be stored. The folder is created if it does already exist.

% Outputs:
% This function returns a vector with the error in RHF measurements, and 
% saves a file containing the error of the RHF predictions.


%%%%%% Perform the analysis and measure the Radial Hydride Fraction %%%%%%%
% Perform the analysis and measure the Radial Hydride Fraction of the
% microstructures in imagesFolderName
RHF_main(codeFolderName,imageFolderName,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution, lengthCut,resultsFolderName)

%%%%%%%%%%%%%% Find and open the file with expected results %%%%%%%%%%%%%%%
% Find the .csv file containing the expected results for microstructures in
% the folder imagesFolderNameExpectedRHF, and load the values in a vector
cd ../
cd(imageFolderNameExpectedRHF)
RHF_Expected = csvread(csvfilename_Expected,1, 1);

%%%%%%%%%%%%%% Find and open the file with measured results %%%%%%%%%%%%%%%
% Find the .csv file containing the measured results for microstructures in
% the folder resultsFolderName, and load the values in a vector
cd ../
cd(resultsFolderName)
RHF_Experimental = csvread([imageFolderName '_results.csv'],1, 1);

%%%%%%%%%%%%%%%%%% Calculate the error in measurements %%%%%%%%%%%%%%%%%%%%
% Calculate the error percentage for each microstructure
% vector containing the error of the measured RHF
size(RHF_Expected)
for i=1:size(RHF_Expected,1)
error_previous_vect(i) =abs(RHF_Expected(i,1)-RHF_Expected(i,2));
error_vect(i) =abs(RHF_Expected(i,1)-RHF_Experimental(i));% Calculate the error percentage for each microstructure
 % vector containing the error of the measured RHF
end


%%%%%%%%%%% Save the errors in a csv file in the results folder %%%%%%%%%%%
results_mat=[[1: length(error_vect)]' error_vect' error_previous_vect'];
resultsRHFerrorName=[imageFolderName '_errorRHF' '.csv'];
% add a header
cHeader = {'Image number' 'Radial Hydride Fraction error' 'Radial Hydride Fraction previous error'}; %header
textHeader = strjoin(cHeader, ',');
% write header to file
fid = fopen(resultsRHFerrorName,'w'); 
fprintf(fid,'%s\n',textHeader);
fclose(fid);
% write data in file
dlmwrite(resultsRHFerrorName,results_mat,'-append');
cd ../
cd(codeFolderName)

%%%%%%%%%%%%%%%%%%% Plot the Radial Hydride Fractions %%%%%%%%%%%%%%%%%%%%%
plotVerification( codeFolderName, resultsFolderName,[imageFolderName '_results.csv'], imageFolderNameExpectedRHF, csvfilename_Expected )


end

