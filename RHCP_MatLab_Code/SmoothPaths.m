function [nodes] = SmoothPaths(nodes,binaryImage,desiredAngle)
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
% SmoothPaths takes the nodes of all paths described by nodes and the
% binary image, and makes sure that the paths go straight within each
% phase.
% Left and right edges of the microstructure count as phase boundaries when
% desiredAngle is different than nan to allow the path to bounce off the
% sides of the bands.


% Inputs:
% - nodes: The horitontal positions of the numPaths paths.
% - binaryImage: The binary image.
% - desiredAngle: For the genetic algorithm. To use the regular definition of the RHCP, use nan. If you want to add a penalty to favor a given angle orientation in the zirconium phase, enter this angle in rad. We recommend using nan or pi/4.


% Outputs:
% - nodes: The horitontal positions of the numPaths paths.


%%%%%%%%%%%%%%%%%%%%%% Derive the number of paths %%%%%%%%%%%%%%%%%%%%%%%%%
numPaths = size(nodes,2);

%%%%%%%%%%%%%%%%%% Go through each path and smooth it %%%%%%%%%%%%%%%%%%%%%
for m=1:numPaths
    % Set first point as first phase boundary
    PhBnd = [1 nodes(1,m)];
    % Determine the phase of first point
    Phase = binaryImage(1,nodes(1,m));
    % generate random number 
    randnum = rand;
    % Loop through all y points of the paths
    for y = 2:size(binaryImage,1)
        
        if not(isnan(desiredAngle)) && ((nodes(y,m)==1) || (nodes(y,m)==size(binaryImage,2))) % if desiredAngle is defined and the path touches the edges of the microstructure, this point is added as a phase boundary
            Step = (nodes(y-1,m) - PhBnd(1,2))/(y-1 - PhBnd(1,1));
            for i = PhBnd(1,1)+1:y-1
                nodes(i,m) = round(nodes(PhBnd(1,1),m)+((i-PhBnd(1,1))*Step));
            end
            Phase = binaryImage(y,nodes(y,m));
            PhBnd = [y nodes(y,m)];
            
        else
            % There are two ways of smoothing the path, and both have pros and cons
            % so we randomly do one or the other
            if randnum >= 0.85
                if ((y <= size(binaryImage,1)-2) && (Phase ~= binaryImage(y,nodes(y,m))) && (Phase ~= binaryImage(y+1,nodes(y+1,m))) && (Phase ~= binaryImage(y+2,nodes(y+2,m))))
                    Step = (nodes(y,m) - PhBnd(1,2))/(y - PhBnd(1,1));
                    for i = PhBnd(1,1)+1:y-1
                        nodes(i,m) = round(nodes(PhBnd(1,1),m)+((i-PhBnd(1,1))*Step));
                    end
                    Phase = binaryImage(y,nodes(y,m));
                    PhBnd = [y nodes(y,m)];
                end
                if (y == size(binaryImage,1)) %When at the right border of image smooth to previous phase boundary
                    Step = (nodes(y,m) - PhBnd(1,2))/(y - PhBnd(1,1));
                    for i = PhBnd(1,1)+1:y
                        nodes(i,m) = round(nodes(PhBnd(1,1),m)+((i-PhBnd(1,1))*Step));
                    end
                    Phase = binaryImage(y,nodes(y,m));
                    PhBnd = [y nodes(y,m)];
                end
            else
                if ((y < size(binaryImage,1)) && (Phase ~= binaryImage(y,nodes(y,m))))
                    Step = (nodes(y-1,m) - PhBnd(1,2))/(y-1 - PhBnd(1,1));
                    for i = PhBnd(1,1)+1:y-2
                        nodes(i,m) = round(nodes(PhBnd(1,1),m)+((i-PhBnd(1,1))*Step));
                    end
                    Phase = binaryImage(y,nodes(y,m));
                    PhBnd = [y nodes(y,m)];
                end
                if (y == size(binaryImage,1))
                    Step = (nodes(y,m) - PhBnd(1,2))/(y - PhBnd(1,1));
                    for i = PhBnd(1,1)+1:y
                        nodes(i,m) = round(nodes(PhBnd(1,1),m)+((i-PhBnd(1,1))*Step));
                    end
                    Phase = binaryImage(y,nodes(y,m));
                    PhBnd = [y nodes(y,m)];
                end
            end
        end
        
    end

end

end

