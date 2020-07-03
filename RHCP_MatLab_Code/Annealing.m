function [bestPath_annealing,bestEval_annealing]= Annealing(bestPath,bestEval,annealingTime,disp_num,disp_size,binaryImage,fracParamZr,fracParamZrH,valueZrH,num_smoothing, desiredAngle, W, y_step)
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
% This function is an annealing algorithm to refine best path.

% Inputs:
% - bestPath: The positions of the points of the best path.
% - bestEval: The evaluation of the best path. 
% - annealingTime: For the genetic algorithm. Number of annealing steps. We recommend using 1000.
% - disp_num: For the genetic algorithm. Number of displacements imposed on the path during annealing. We recommend using 20.
% - disp_size: For the genetic algorithm. Maximum magnitude of the displacements imposed on the path during annealing. We recommend using 20.
% - binaryImage: The binary image.
% - fracParamZr: For the genetic algorithm. Fracture toughness of the zirconium phase. We recommend using 50.
% - fracParamZrH: For the genetic algorithm. Fracture toughness of the hydride phase. We recommend using 1.
% - valueZrH: For the genetic algorithm. Binary value representing the hydride phase, as opposed to the zirconium phase in the image. With the microstructures given here, you should use 1.
% - num_smoothing: For the genetic algorithm. Number of times the path is smoothed. We recommend using 1, doing it more than that does not really increase the path quality..
% - desiredAngle: For the genetic algorithm. To use the regular definition of the RHCP, use nan. If you want to add a penalty to favor a given angle orientation in the zirconium phase, enter this angle in rad. We recommend using nan or pi/4.
% - W: For the genetic algorithm. Magnitude of the penalty to favor a given angle. This is not used if desiredAngle = nan. We recommend using 13 otherwise.
% - y_step: For the genetic algorithm. Length of the paths section used to determine its orientation. This is not used if desiredAngle = nan. Otherwise, it is used to accurately determine the paths orientation and apply the angle penalty. We recommend using 10.

% Outputs:
% - bestPath_annealing: Path after annealing.
% - bestEval_annealing: Path Evaluation after annealing.

%%%%%%%%%%%%%%%%%%%%%%%%%% Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
bestPath_annealing = bestPath;
bestEval_annealing(1,:) = bestEval;

%%%%%%%%%%%%%%%% Go until annealing time is reached %%%%%%%%%%%%%%%%%%%%%%%
for T = 1:annealingTime
    % Shift points slightly along best path to make Child path
    sigma = 0.05*(disp_size); %determines displacement distribution
    child(:,1) = bestPath_annealing(:,1);
    for i = 1:disp_num
        point = randi([1,size(binaryImage,1)-1]); %Randomly pick a point from the line by its y coordinate
        newPoint = round(normrnd(bestPath(point,1),sigma)); %Displace that point
        if newPoint < 1 %Keep point within the image
            newPoint = 1;
        elseif newPoint > size(binaryImage,2)-1
            newPoint = size(binaryImage,2)-1;
        end
        child(point,1) = newPoint; % Make change to pathway
    end

    % Smooth Child between phase boundaries
    child = ImprovePaths(child,binaryImage,fracParamZr,fracParamZrH,valueZrH,num_smoothing,desiredAngle,W,y_step);

    % Evaluate Child
    cEval = EvalPaths(child,binaryImage,fracParamZr,fracParamZrH,valueZrH,desiredAngle,W,y_step);

    %If child has a higher continuousness keep it
    if cEval(1,1) > bestEval_annealing(1,1)
        bestPath_annealing(:,1) = child(:,1);
        bestEval_annealing(1,:) = cEval(1,:);
    end
end

end
