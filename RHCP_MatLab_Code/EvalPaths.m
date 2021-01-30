function [eval] = EvalPaths(nodes,binaryImage,fracParamZr,fracParamZrH,valueZrH,desiredAngle,W,y_step)
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
% EvalPaths takes all paths described in nodes, the binary image, as well
% as the parameters for fracture for both phases and the indicator of ZrH,
% and returns the radial hydride continuous path value for each path, as
% well as the normalized path lengths.


% Inputs:
% - nodes: The horitontal positions of the numPaths paths.
% - binaryImage: The binary image.
% - fracParamZr: For the genetic algorithm. Fracture toughness of the zirconium phase. We recommend using 50.
% - fracParamZrH: For the genetic algorithm. Fracture toughness of the hydride phase. We recommend using 1.
% - valueZrH: For the genetic algorithm. Binary value representing the hydride phase, as opposed to the zirconium phase in the image. With the microstructures given here, you should use 1.
% - desiredAngle: For the genetic algorithm. To use the regular definition of the RHCP, use nan. If you want to add a penalty to favor a given angle orientation in the zirconium phase, enter this angle in rad. We recommend using nan or pi/4.
% - W: For the genetic algorithm. Magnitude of the penalty to favor a given angle. This is not used if desiredAngle = nan. We recommend using 13 otherwise.
% - y_step: For the genetic algorithm. Length of the paths section used to determine its orientation. This is not used if desiredAngle = nan. Otherwise, it is used to accurately determine the paths orientation and apply the angle penalty. We recommend using 10.


% Outputs:
% - nodes: The horitontal positions of the numPaths paths.


%%%%%%%%%%%%%%%%%%%%%% Derive the number of paths %%%%%%%%%%%%%%%%%%%%%%%%%
numPaths = size(nodes,2);

%%%%%%%%%%%%%%%%%%%% Derive the length of the image %%%%%%%%%%%%%%%%%%%%%%%
length_Image = size(binaryImage,1);

%%%%%%%%%%%%%%%%%% Determine if desiredAngle is used %%%%%%%%%%%%%%%%%%%%%%
if isnan(desiredAngle)
    %%%%%%%%%%%%%%%%%%%%%%% Go through each path %%%%%%%%%%%%%%%%%%%%%%%%%%
    for m = 1:numPaths
        %%%%%%%%%%%%%%%%%%%%%%%%%% Initialize %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        path_length_Zr = 0; % path length in Zr Phase
        path_length_ZrH = 0; % path length in ZrH Phase
        path_length_total = 0; % total path length
        
        %%%%%%%%%%%%%%%%%%%%% Go through the path %%%%%%%%%%%%%%%%%%%%%%%%%
        for n = 1:length_Image-1
            dl = sqrt(1^2+(nodes(n+1,m)-nodes(n,m))^2); % Length of path segment between nodes
            fracZrH = 0;
            fracZr = 0;
            pos_x_min = min(nodes(n,m),nodes(n+1,m));
            pos_x_max = max(nodes(n,m),nodes(n+1,m));
            
            %%%%% Go through each pixel between two successive points %%%%%
            for pos_x=pos_x_min:pos_x_max
                % Determine the position along y
                if nodes(n,m)==nodes(n+1,m)
                    pos_y = n;
                else
                    pos_y = round(n+abs(pos_x-nodes(n,m))/abs(nodes(n+1,m)-nodes(n,m)));
                end
                % Determine the phase of the current pixel  and add it to the
                % corresponding fraction
                if binaryImage(pos_y,pos_x) == valueZrH
                    fracZrH = fracZrH + 1;
                else
                    fracZr = fracZr + 1;
                end
            end
            %%%%%%%%% Determine the fraction of Zr and ZrH pixels %%%%%%%%%
            total_pixels = fracZrH + fracZr;
            fracZrH = fracZrH/total_pixels;
            fracZr = fracZr/total_pixels;
            path_length_Zr = path_length_Zr + fracZr*dl;
            path_length_ZrH = path_length_ZrH + fracZrH*dl;
            path_length_total = path_length_total + dl;
        end
        %%%%%%%%%%%%%%%%%%%%%% Derive RHCP value %%%%%%%%%%%%%%%%%%%%%%%%%%
        eval(m,1) = ((length_Image-path_length_Zr)*fracParamZr-path_length_ZrH*fracParamZrH)/(length_Image*(fracParamZr-fracParamZrH)); %Radial Hydride Continuous Path value for path m
        eval(m,2) = path_length_total/length_Image;  % Normalized pathway length
    end
else
    %%%%%%%%%%%%%%%%%%%%%%% Go through each path %%%%%%%%%%%%%%%%%%%%%%%%%%
    for m = 1:numPaths
        %%%%%%%%%%%%%%%%%%%%%%%%%% Initialize %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        path_length_Zr = []; % path length in Zr Phase
        path_angle_Zr = []; % path angle in Zr Phase
        path_length_ZrH = 0; % path length in ZrH Phase
        path_length_total = 0; % total path length
        
        y = 1;
        while y < length_Image
            % Find the next nodes forming a straight line
            y_end = y+1;
            % test if the next y_step points are roughly aligned
            y_step_i = y+1;
            dx = nodes(y_step_i,m)-nodes(y,m);
            dx_tol = 2;
            while (y_step_i < y + y_step) && (y_step_i < length_Image) && (abs(dx - (nodes(y_step_i+1,m)-nodes(y_step_i,m)))<dx_tol)
                y_step_i = y_step_i + 1;
            end
            
            if y_step_i < y + y_step
                % if the y_step points where not all aligned, or the end of the
                % image was reached, one selects the last point reached
                y_end = y_step_i;
            else
                % if the 10 points were aligned, then one keeps looking for the
                % straight line in this direction
                dx_step = nodes(y_step_i,m)-nodes(y,m);
                while (y_end < y_step_i)
                    y_step_i_2 = y_step_i + 1;
                    while (y_step_i_2 < y_step_i + y_step) && (y_step_i_2 < length_Image) && (abs(dx - (nodes(y_step_i_2+1,m)-nodes(y_step_i_2,m)))<dx_tol)
                        y_step_i_2 = y_step_i_2 + 1;
                    end
                    
                    if (y_step_i_2 == y_step_i + y_step) && (dx_step == (nodes(y_step_i_2,m)-nodes(y_step_i,m)))
                        % if the next y_step points were aligned, and if these
                        % y_step points are well aligned with the previous
                        % y_step ones, then one continues on this straight line
                        y_step_i = y_step_i + y_step;
                    else
                        % if not, then one stops and defines y_step_i as the last
                        % point
                        y_end = y_step_i;
                    end
                end
            end
            
            % Measure length and angle of the straight line
            dx = nodes(y_end,m)-nodes(y,m); % length of the straight line along x
            dy = y_end-y; % length of the straight line along y
            dl = sqrt(dx^2+dy^2); % length of the path
            theta = atan2(dx,dy); % angle of the straight line
            
            % Measure the length fraction in each phase
            fracZrH = 0;
            fracZr = 0;
            num_points = round(sqrt(2)*dl);
            for i=1:num_points
                pos_y = y + i * (y_end-y)/num_points;
                %for pos_y=y:y_end
                
                % Determine pos_x along the straight line
                pos_x = round(nodes(y,m) + (pos_y-y)*(nodes(y_end,m)-nodes(y,m))/(y_end-y));
                pos_y = round(pos_y);
                % Determine the phase of the current pixel  and add it to the
                % corresponding fraction
                if binaryImage(pos_y,pos_x) == valueZrH
                    fracZrH = fracZrH + 1;
                else
                    fracZr = fracZr + 1;
                end
            end
            
            %%%%%%%%% Determine the fraction of Zr and ZrH pixels %%%%%%%%%
            total_pixels = fracZrH + fracZr;
            fracZrH = fracZrH/total_pixels;
            fracZr = fracZr/total_pixels;
            path_length_Zr = [path_length_Zr fracZr*dl];
            path_angle_Zr = [path_angle_Zr theta];
            path_length_ZrH = path_length_ZrH + fracZrH*dl;
            path_length_total = path_length_total + dl;
            % Update y
            y = y_end; % continue along the path, starting from the last point of the straight line
        end
        
        %%%%%%%%%%%%%%%%%%%%%% Derive RHCP value %%%%%%%%%%%%%%%%%%%%%%%%%%
        path_coefficient_Zr = path_length_Zr.*(1+W*(desiredAngle-path_angle_Zr).^2.*(desiredAngle+path_angle_Zr).^2);
        sum_Zr = sum(path_coefficient_Zr);
        eval(m,1) = ((length_Image/cos(desiredAngle)-sum_Zr)*fracParamZr-path_length_ZrH*fracParamZrH)/(length_Image*(fracParamZr/cos(desiredAngle)-fracParamZrH)); %Radial Hydride Continuous Path value for path m
        eval(m,2) = path_length_total/length_Image;  % Normalized pathway length
        
    end
    
    
end
end
