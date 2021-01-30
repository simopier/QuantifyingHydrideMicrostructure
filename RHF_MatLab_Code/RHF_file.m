function [RHF] = RHF_file(codeFolderName,imageFolderName, filename, resultsFolderName, resolution, lengthCut)
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
% This function is called by RHF_folder and measures the RHF of the
% microstructure given as input. It opens the given microstructure and
% performs the analysis.
% Once the analysis is over, it saves in the result folder a .csv file
% listing all the hydrides and their corresponding RHF.


% Inputs:
% - codeFolderName: The name of the folder in which the RHF code is stored.
% - imageFolderName: The name of the folder in which images are stored.
% - filename: Name of the microstructure file.
% - resolution: The image resolution in dpi. Enter 0 if you want to use the resolution in the metadata of the images.
% - lengthCut: The length used to cut the hydrides to approximate them a straight lines. Use InF to select the whole hydrides.
% - resultsFolderName: The name of the folder in which the results will be stored. The folder is created if it does already exist.

% Outputs:
% This function returns the RHF value for the input microstructure and
% saves a .csv file in the resultfolder with a list of all the hydrides and
% their corresponding RHF.


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

% disp('RHF lengthCut ratio')
% lengthCutRatio = lengthCut;

%%%%%% Isolate each hydride and determine its radial hydride fraction %%%%%
% Isolate the hydrides
CC=bwconncomp(binaryImage);
numberHydrides=CC.NumObjects;
% Initialize results vectors
Hydride_Length_vect=zeros(1,numberHydrides);
RHF_vect=zeros(1,numberHydrides);

% For each hydride, determine its Radial Hydride Fraction
for i=1:numberHydrides
    % Select the ith hydride
    binaryImage2=binaryImage;
    binaryImage2(:)=0;
    binaryImage2(CC.PixelIdxList{i})=1;

    % Set up length and RHF vectors for this hydrides
    Hydride_length_hydride_i_vect = [];
    RHF_hydride_i_vect = [];

    % Call on total length function to determine the length of the hydride
    Hydride_Length_vect(i)=Total_H_Length(binaryImage2,resolution);

%     disp('RHF_file hydride length')
%     Hydride_Length_vect(i)
%     if lengthCutRatio < Inf
%         lengthCut = Hydride_Length_vect(i)*lengthCutRatio;
%     else
%         lengthCut = Inf;
%     end

    % Determine the number of cuts
    numCuts = floor(Hydride_Length_vect(i)/lengthCut);

    % Find the two ends of the hydride
    endPoints = bwmorph(binaryImage2, 'endpoints');
    [endPoints_loc_x, endPoints_loc_y] = find(endPoints);
    % if the hydride has no end (forms a closed loop), then we remove one point from the hydride and find the new endpoints
    if size(endPoints_loc_x,1)==0
        list_points = find(binaryImage2);
        binaryImage2(list_points(1))=0;
        endPoints = bwmorph(binaryImage2, 'endpoints');
        [endPoints_loc_x, endPoints_loc_y] = find(endPoints);
    end
    endPoint_x_1 = endPoints_loc_x(1);
    endPoint_y_1 = endPoints_loc_y(1);
    endPoint_x_2 = endPoints_loc_x(2);
    endPoint_y_2 = endPoints_loc_y(2);
    pointx_past = endPoint_x_1;
    pointy_past = endPoint_y_1;

    % Determine the distance from the current point to every other
    % point of the hydride
    D = bwdistgeodesic(binaryImage2,endPoint_y_1,endPoint_x_1,'quasi-euclidean');
    D(D==Inf) = nan;
    D = D / resolution;
    tol = 2/resolution;

    while max(max(D))>0
        % find the point at the desired length of the current point
        [pointx, pointy] = find((D>(lengthCut-tol))&(D<(lengthCut+tol)));

        if size(pointx,1)==0
            % If no point is at the desired distance, then it means the end
            % of the hydride was reached. But a test is needed, just in
            % case
            % Create binary image with the cut
            D2 = zeros(size(D,1),size(D,2));
            D2(D>0) = 1;
            binaryImage2_cut = binaryImage2.*D2;
            lengthEnd = Total_H_Length(binaryImage2_cut,resolution); %max(max(D));
            % Derive projected lengths
            [pointsi_cut, pointsj_cut] = find(binaryImage2_cut);
            length_proj_c = abs(max(pointsj_cut)-min(pointsj_cut));
            length_proj_r = abs(max(pointsi_cut)-min(pointsi_cut));

            % Add length of this cut
            Hydride_length_hydride_i_vect = [Hydride_length_hydride_i_vect lengthEnd];
        else
            pointx = pointx(1); % in case the tolerance included several points
            pointy = pointy(1);
            % Create binary image with the cut
            D2 = zeros(size(D,1),size(D,2));
            D2((D>0)&(D<=D(pointx,pointy))) = 1;
            binaryImage2_cut = binaryImage2.*D2;

            % Derive the length of the cut
            lengthCut_measured = Total_H_Length(binaryImage2_cut,resolution);

            % Derive projected lengths
            [pointsi_cut, pointsj_cut] = find(binaryImage2_cut);
            length_proj_c = abs(max(pointsj_cut)-min(pointsj_cut));
            length_proj_r = abs(max(pointsi_cut)-min(pointsi_cut));

            % Add length of this cut
            Hydride_length_hydride_i_vect = [Hydride_length_hydride_i_vect lengthCut_measured];
        end

        % Determine the Radial Hydride Fraction RHF of the hydride
        RHF_hydride_i_vect = [RHF_hydride_i_vect RHFCalculation(length_proj_c,length_proj_r)];

        % Set up next step
        pointx_past = pointx;
        pointy_past = pointy;
        D = max(0,D-lengthCut);

    end

    % Determine the RHF of this hydride
    RHF_vect(i) = sum(Hydride_length_hydride_i_vect.* RHF_hydride_i_vect)/sum(Hydride_length_hydride_i_vect);

end

%%%%%%%%%%%%%%%%%%%%%%%% Filter out the NaN values %%%%%%%%%%%%%%%%%%%%%%%%
RHF_vect(isnan(RHF_vect))=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Derive global RHF %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Length average the Radial Hydride Fraction of every hydride to get the
% RHF of the microstructure
RHF=sum(Hydride_Length_vect.*RHF_vect)/sum(Hydride_Length_vect);

%%%%%%%%% Save the results in a .csv file in resultsFolderName %%%%%%%%%%%%

cd ../
cd(resultsFolderName)
filename_results=[filename '_results' '.csv'];
results_mat=[ [1:numberHydrides]' RHF_vect' Hydride_Length_vect'];
% add a header
cHeader = {'Hydride number' 'Radial Hydride Fraction' 'Hydride length'}; %header
textHeader = strjoin(cHeader, ',');
% write header to file
fid = fopen(filename_results,'w');
fprintf(fid,'%s\n',textHeader);
fclose(fid);
% write data in file
dlmwrite(filename_results,results_mat,'-append');
cd ../
cd(codeFolderName)

end
