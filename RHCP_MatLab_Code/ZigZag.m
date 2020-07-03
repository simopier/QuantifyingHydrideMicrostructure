function [nodes] = ZigZag(nodes,binaryImage,fracParamZr,fracParamZrH,valueZrH,desiredAngle,W,y_step)
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
% ZigZag takes the nodes of paths described by nodes and the binaryImage,
% and removes parts of the paths that go in and out of the ZrH phase.


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

%%%%%%%%%%%%%%% Go through each path and remove zigzags %%%%%%%%%%%%%%%%%%%
for m = 1:numPaths
    % Define child path
    Child(:,1) = nodes(:,m);
    num_PhBnd = 2;
    PhBnd = zeros(num_PhBnd,2); % X and Y coordinates for num_PhBnd phase boundary points
    PhBnd(1,1) = 1;
    PhBnd(1,2) = Child(1,1); %Set first point as first phase boundary
    Phase = binaryImage(1,Child(1,1)); %Determine phase of first point
    hydride_detected = (Phase == valueZrH); % boleen to determine if the path touched the hydride phase


    for n = 2:size(binaryImage,1) %Loop through all y points of a path
        if binaryImage(n,Child(n,1)) ~= Phase  %Find next phase boundary
            if binaryImage(n,Child(n,1)) == valueZrH
                hydride_detected = 1; % take note that a hydride was found
            end
            if (PhBnd(1,1)==1) && (binaryImage(n,Child(n,1)) == valueZrH)
                % Change the first part of the path to reach the first hydride
                % with the right angle
                Child = completePath(Child, n, 1, desiredAngle, binaryImage);

            end
            if binaryImage(n,Child(n,1)) ~= valueZrH % Determine if the path leaves the hydride phase
                b = n; %Incriment to track y-coordinate of current point
                PB = 1; %Phase boundaries kept so far
                PhBnd(1,1) = n-1; % Select the last point in the hydride before the path leaves
                PhBnd(1,2) = Child(n-1,1);
                Phase = binaryImage(n,Child(n,1)); % First point in Zr phase
                while PB < num_PhBnd && b <= size(binaryImage,1) %Find up to the next num_PhBnd-1 phase boundaries
                    if (Phase ~= binaryImage(b,Child(b,1)))
                        PB = PB + 1;
                        PhBnd(PB,1) = b;
                        PhBnd(PB,2) = Child(b,1);
                        Phase = binaryImage(b,Child(b,1)); %Update phase

                    elseif b == size(binaryImage,1)
                        % Change the last part of the path to reach the bottom
                        % with the right angle
                        Child = completePath(Child, n-1 , size(binaryImage,1), desiredAngle, binaryImage);

                    end
                    b = b + 1;
                end
                j = 0; %Increments which phase boundary is being considered
                while j < PB %Starts with first and last phase boundaries and moves on to closer phase boundaries to first
                    dx = PhBnd(PB-j,2) - PhBnd(1,2); %horizontal distance between first and current phase boundary
                    dy = PhBnd(PB-j,1) - PhBnd(1,1); %vertical distance between first and current phase boundary
                    for i = PhBnd(1,1)+1:PhBnd(PB-j,1)-1 %Create straight line between first and current phase boundary
                        Child(i,1) = round(PhBnd(1,2)+((i-PhBnd(1,1))*dx/dy));
                    end
                    % The original path is replaced if the child path is better
                    % than the original path
                    eval = EvalPaths([nodes(:,m) Child(:,1)],binaryImage,fracParamZr,fracParamZrH,valueZrH,desiredAngle,W,y_step);
                    evalNode = eval(1,:);
                    evalChild = eval(2,:);
                    if (evalNode(1,1) < evalChild(1,1))
                        nodes(:,m) = Child(:,1);
                        j = PB; %When a smoothing operation is successful stop while loop
                    end
                    j = j + 1; %Update j
                    Child(:,1) = nodes(:,m); %Removes the changes to the pathway if a smoothing operation was unsuccessful
                end
            end
            PhBnd(1,1) = n; % Make previous phase boundary the new starting phase boundary, because this is where the for loop will continue from
            PhBnd(1,2) = Child(n,1);
            Phase = binaryImage(n,Child(n,1));
        end
    end
    if (hydride_detected == 0) && not(isnan(desiredAngle))
        % Complete the path if no hydride was detected
        nodes(:,m) = completePath(Child, 1, size(binaryImage,1), desiredAngle, binaryImage);
    end

end
end