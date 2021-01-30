function [] = RHF_validation(codeFolderName,csvfilenames_Expected,list_csvfilenames_ImageJ,resultsFolderName)
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
% This function is used for the validation of the RHF method. It reads the
% results derived from MATLAB and compared them with the values measured
% using ImageJ

% Inputs:
% - codeFolderName: The name of the folder in which the RHF code is stored.
% - csvfilename_Expected: Name of the .csv file in resultFolderName containing the list of the microstructures names and expected RHF values determined by MATLAB.
% - list_csvfilenames_ImageJ: list of the names of the .csv files containing the ImageJ measurements
% - resultsFolderName: The name of the folder in which the results will be stored. The folder is created if it does already exist.

% Outputs:
% This function saves in the result folder a .csv file comparing the matlab
% and measured values on ImageJ for the validation of the RHF method.

% Call example:
% RHF_validation('RHF_MatLab_code','RHF_Validation_Microstructures_results.csv',[6 7 8 9 10 11 12 13 14 15 54 55 56 60 61],'RHF_Validation_Results')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Initialize %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
RHF_ideal_vect = zeros(length(list_csvfilenames_ImageJ),1);
RHF_previous_vect = zeros(length(list_csvfilenames_ImageJ),1);
image_number_vect = zeros(length(list_csvfilenames_ImageJ),1);
%%%%%%%%%%%%%%%%%%% Open and load MATLAb measurements %%%%%%%%%%%%%%%%%%%%%
cd ../
cd(resultsFolderName)
RHF_Experimental = csvread(csvfilenames_Expected,1, 0);
RHF_Experimental = sortrows(RHF_Experimental,1);
RHF_MATLAB_vect = RHF_Experimental(:,2);
cd ../
cd(codeFolderName)

%%%%%%%%% Go through all .csv ImageJ files to measure RHF value %%%%%%%%%%%
for i=1: length(list_csvfilenames_ImageJ)
    %%%%%%%%%%%%%%%%% Open and load ImageJ measurements %%%%%%%%%%%%%%%%%%%
    cd ../
    cd(resultsFolderName)
    list_hydrides = csvread([num2str(list_csvfilenames_ImageJ(i)) '.csv'],1,0);
    lengths = list_hydrides(:,7); % length of the hydride
    angles = list_hydrides(:,6); % angle in degrees
    angle_weight = zeros(length(angles),1);
    angles = abs(angles);
    angles(angles>90)= 90-mod(angles(angles>90),90);
    RHF_MATLAB_vect = RHF_Experimental(:,2);
    image_number_vect(i) = list_csvfilenames_ImageJ(i);
    cd ../
    cd(codeFolderName)
    
    %%%%%%%%%%%%%%%%%%%% Derive the ideal RHF value %%%%%%%%%%%%%%%%%%%%%%%
    RHF_weight_ideal_vect = 2/pi*abs(angles*pi/180);
    RHF_ideal_vect(i) = sum(lengths.*RHF_weight_ideal_vect)/sum(lengths);
    
    %%%%%%%%%%%%%%%%% Derive the 'previous' RHF value %%%%%%%%%%%%%%%%%%%%%
    angle_weight(angles<40)=0;
    angle_weight((angles>=40)&(angles<=65))=0.5;
    angle_weight(angles>65)=1;
    RHF_previous_vect(i) = sum(lengths.*angle_weight)/sum(lengths);
    
end

%%%%% Sort the results to make sure they correspond to the same image %%%%%
results_vect = [image_number_vect RHF_ideal_vect RHF_previous_vect];
results_vect = sortrows(results_vect,1);
image_number_vect = results_vect(:,1);
RHF_ideal_vect = results_vect(:,2);
RHF_previous_vect = results_vect(:,3);

%%%%%%%%%%%%%%%%%%%%%%%%%%% Determine the error %%%%%%%%%%%%%%%%%%%%%%%%%%%
RHF_MATLAB_error_vect = abs(RHF_MATLAB_vect-RHF_ideal_vect);
RHF_previous_error_vect = abs(RHF_previous_vect-RHF_ideal_vect);
RHF_MATLAB_error_per_vect = abs(RHF_MATLAB_vect-RHF_ideal_vect)./RHF_ideal_vect.*100;
RHF_previous_error_per_vect = abs(RHF_previous_vect-RHF_ideal_vect)./RHF_ideal_vect.*100;

%%%%%%%%%%%% Save results in .csv file in the result folder %%%%%%%%%%%%%%%
cd ../
cd(resultsFolderName)
results_mat=[image_number_vect RHF_ideal_vect RHF_MATLAB_vect RHF_MATLAB_error_vect RHF_MATLAB_error_per_vect RHF_previous_vect RHF_previous_error_vect RHF_previous_error_per_vect];
resultsRHFName=['RHF_Validation_results' '.csv'];
% add a header
cHeader = {'Image number' 'Radial Hydride Fraction ideal IMAGEJ' 'Radial Hydride Fraction MATLAB' 'Radial Hydride Fraction MATLAB error' 'Radial Hydride Fraction MATLAB error %' 'Radial Hydride Fraction previous IMAGEJ' 'Radial Hydride Fraction previous IMAGEJ error' 'Radial Hydride Fraction previous IMAGEJ error %'}; %header
textHeader = strjoin(cHeader, ',');
% write header to file
fid = fopen(resultsRHFName,'w'); 
fprintf(fid,'%s\n',textHeader);
fclose(fid);
% write data in file
dlmwrite(resultsRHFName,results_mat,'-append');
cd ../
cd(codeFolderName)


end

