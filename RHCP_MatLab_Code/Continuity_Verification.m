function [ ] = Continuity_Verification( codeFolderNameRHCF,codeFolderNameHCC,codeFolderNameRHCP,imageFolderName,imageFolderNameExpectedContinuity,csvfilename_Expected,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution,resultsFolderNameRHCF,resultsFolderNameHCC,resultsFolderNameRHCP, Min_Segment_Length, PerCut, tolConvergence, numPaths, Mutation, primary_nodes_dist, disp_num, disp_size, annealingTime, numRun, CPMax, num_smoothing,fracParamZr,fracParamZrH,valueZrH, num_bands, bridge_criteria_ratio, plotFrequency,desiredAngle,W,y_step)
%-------------------------------------------------------------------------%
%                                                                         %
%       Script developed by Cailon Frank and Pierre-Clement Simon         %
%       Penn State University                                             %
%                                                                         %
%-------------------------------------------------------------------------%

% Continuity_Verification performs the verification of the RHF
% Intersection code on the microstructures and expected results in
% imagesFolderName and stores the results in resultsFolderName
% The results consist of the analysis of each microstructure, and a file
% containing the error of the predictions of the RHFIntersection_folder
% analysis.

% Example:
% RHF_Intersection_Verification( 'MatLab_Code_Intersection2','Rand_Hydrides','Rand_Hydrides_Expected_results','_RandHydrideImages.csv',0,500,0,0,25.4,'Rand_Hydrides_results')
% RHF_Intersection_Verification( 'RHF_Code_Folder','Single_Hydride','Single_Hydride_Expected_results','_Single_Hydride_Images.csv',0,500,0,0,25.4,'Single_Hydride_Comparison_Results1')
%RHF_Intersection_Verification( 'RHF_Code_Folder','VertHor_Hydrides','VertHor_Hydrides_Expected_results','_VertHorImages.csv',0,500,0,0,25.4,'VertHor_comparison1')
% Initialization

% Perform the analysis and measure the Radial Hydride Fraction of the
% microstructures in imagesFolderName
cd ../
cd(codeFolderNameRHCF)
Connectivity_RHCF_main(codeFolderNameRHCF,imageFolderName,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution,resultsFolderNameRHCF)
cd ../
cd(codeFolderNameHCC)
Connectivity_HCC_main(codeFolderNameHCC,imageFolderName,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution,resultsFolderNameHCC, Min_Segment_Length)
cd ../
cd(codeFolderNameRHCP)
RHCP_main(codeFolderNameRHCP,imageFolderName,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution,resultsFolderNameRHCP, PerCut, tolConvergence, numPaths, Mutation, primary_nodes_dist, disp_num, disp_size, annealingTime, numRun, CPMax, num_smoothing,fracParamZr,fracParamZrH,valueZrH, num_bands, bridge_criteria_ratio, plotFrequency,desiredAngle,W,y_step)


% Find the .csv file containing the expected results for microstructures in
% the folder imagesFolderName, and load the values in a vector
cd ../
cd(imageFolderNameExpectedContinuity)
Expected_values = csvread(csvfilename_Expected,1, 0);
sortrows(Expected_values,1);
RHCF_Expected = Expected_values(:,2);
HCC_Expected = Expected_values(:,3);
if isnan(desiredAngle)
    ind = 4;
else
    ind = 5;
end
RHCP_Expected = Expected_values(:,ind);

% Find the .csv file containing the measured results for microstructures in
% the folder resultsFolderName, and load the values in a vector
cd ../
cd(resultsFolderNameRHCF)
RHCF_Experimental = csvread([imageFolderName '_results.csv'],1, 0);
RHCF_Experimental = sortrows(RHCF_Experimental,1);
cd ../
cd(resultsFolderNameHCC)
HCC_Experimental = csvread([imageFolderName '_results.csv'],1, 0);
HCC_Experimental = sortrows(HCC_Experimental,1);
cd ../
cd(resultsFolderNameRHCP)
RHCP_Experimental = csvread([imageFolderName '_results.csv'],1, 0);
RHCP_Experimental = sortrows(RHCP_Experimental,1);
cd ../
cd(resultsFolderNameRHCP)
% Calculate the error percentage for each microstructure
 % vector containing the error of the measured RHF
for i=1:length(RHCF_Expected)
errorRHCF_vect(i) =abs(RHCF_Expected(i)-RHCF_Experimental(i,2))/RHCF_Expected(i)*100;% Calculate the error percentage for each microstructure
 % vector containing the error of the measured RHF
end
for i=1:length(HCC_Expected)
errorHCC_vect(i) =abs(HCC_Expected(i)-HCC_Experimental(i,2))/HCC_Expected(i)*100;% Calculate the error percentage for each microstructure
 % vector containing the error of the measured RHF
end
for i=1:length(RHCP_Expected)
errorRHCP_vect(i) =abs(RHCP_Expected(i)-RHCP_Experimental(i,2))/RHCP_Expected(i)*100;% Calculate the error percentage for each microstructure
 % vector containing the error of the measured RHF
end
% Save the errors in a csv file in the results folder
results_mat=[[1: length(errorRHCP_vect)]' RHCF_Experimental(:,2) RHCF_Expected  errorRHCF_vect' HCC_Experimental(:,2) HCC_Expected errorHCC_vect' RHCP_Experimental(:,2) RHCP_Expected errorRHCP_vect'];
resultsContinuityErrorName=[imageFolderName '_Verification_results' '.csv'];
% add a header
cHeader = {'Image number' 'RHCF measured' 'RHCF expected' 'RHCF error' 'HCC measured' 'HCC expected' 'HCC error' 'RHCP measured' 'RHCP expected' 'RHCP error'}; %header
textHeader = strjoin(cHeader, ',');
% write header to file
fid = fopen(resultsContinuityErrorName,'w'); 
fprintf(fid,'%s\n',textHeader);
fclose(fid);

% write data in file
dlmwrite(resultsContinuityErrorName,results_mat,'-append');
cd ../
cd(codeFolderNameRHCP)


% Plot the results %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function isn't done, and maybe not useful
%PlotVerification( codeFolderNameRHCP, resultsFolderName,resultsContinuityErrorName )

% Plot the micrographs with the results as titles, as well as the best path
% found
cd ../
cd(resultsFolderNameRHCP)
% Go through the figures
for i=1:length(RHCP_Experimental)
    % Open the figure
    figure
    imshow([num2str(i) '.tif_binary.tiff'])
    hold on
    % Plot the path on top of it
    path = csvread([num2str(i) '.tif_best_path_results' '.csv'],1,0); %first column is y, second column is x
    plot(path(:,2),path(:,1),'r:','LineWidth',3)
    plot([1 size(path(:,2),1)+90],[1 1],'k-','LineWidth',1)
    plot([1 size(path(:,2),1)-1+90],[size(path(:,2),1) size(path(:,2),1)],'k-','LineWidth',1)
    plot([1 1],[1 size(path(:,2),1)],'k-','LineWidth',1)
    plot([size(path(:,2),1)-1+88 size(path(:,2),1)-1+88],[1 size(path(:,2),1)],'k-','LineWidth',1)
    % Save figure
    opts.width      = 20;
    opts.height     = 20;
    opts.fontType   = 'Latex';
    % scaling
    fig.Units               = 'centimeters';
    fig.Position(3)         = opts.width;
    fig.Position(4)         = opts.height;
    % remove unnecessary white space
    set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
    box on
    % Export to PDF
    set(gca,'units','centimeters')
    set(gcf,'PaperUnits','centimeters');
    set(gcf,'PaperSize',[opts.width opts.height]);
    set(gcf,'PaperPositionMode','manual');
    set(gcf,'PaperPosition',[0 0 opts.width opts.height]);
    saveas(gcf,[num2str(RHCP_Experimental(i)) '_Micrograph_Path.pdf'])
end

cd ../
cd(codeFolderNameRHCP)

end

