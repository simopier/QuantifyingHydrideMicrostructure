function [ nodes ] = ImprovePaths(nodes,binaryImage,fracParamZr,fracParamZrH,valueZrH,num_smoothing,desiredAngle,W,y_step)
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
% ImprovePaths smoothes the paths and eliminates zigzag num_smoothing times
% over to improve the existing paths.


% Inputs:
% - nodes: The horitontal positions of the numPaths paths.
% - binaryImage: The binary image.
% - num_smoothing: For the genetic algorithm. Number of times the path is smoothed. We recommend using 1, doing it more than that does not really increase the path quality..
% - fracParamZr: For the genetic algorithm. Fracture toughness of the zirconium phase. We recommend using 50.
% - fracParamZrH: For the genetic algorithm. Fracture toughness of the hydride phase. We recommend using 1.
% - valueZrH: For the genetic algorithm. Binary value representing the hydride phase, as opposed to the zirconium phase in the image. With the microstructures given here, you should use 1.
% - desiredAngle: For the genetic algorithm. To use the regular definition of the RHCP, use nan. If you want to add a penalty to favor a given angle orientation in the zirconium phase, enter this angle in rad. We recommend using nan or pi/4.
% - W: For the genetic algorithm. Magnitude of the penalty to favor a given angle. This is not used if desiredAngle = nan. We recommend using 13 otherwise.
% - y_step: For the genetic algorithm. Length of the paths section used to determine its orientation. This is not used if desiredAngle = nan. Otherwise, it is used to accurately determine the paths orientation and apply the angle penalty. We recommend using 10.


% Outputs:
% - nodes: The horitontal positions of the numPaths paths.


%%%%%%%%%%%%%%%%%%%%%%%%%%% Improve paths %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:num_smoothing
    % Smooth path within phases
    nodes = SmoothPaths(nodes,binaryImage,desiredAngle);
    
    % Eliminate zig-zag patterns in and out of boundaries
    nodes = ZigZag(nodes,binaryImage,fracParamZr,fracParamZrH,valueZrH,desiredAngle,W,y_step);
    
    % Smooth path within phases
    nodes = SmoothPaths(nodes,binaryImage,desiredAngle);
    
end

end

