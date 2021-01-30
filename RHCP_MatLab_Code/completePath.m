function [child] = completePath(nodes, pos_y_current, pos_y_aim, desiredAngle, binaryImage)
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
% complatePath completes the path between the current point and the aim
% point, and returns the updated path.


% Inputs:
% - nodes: The horitontal positions of the numPaths paths.
% - pos_y_current: The current position of the zigzig algorithm on the path.
% - pos_y_aim: The aim position that complatePath is going for.
% - desiredAngle: For the genetic algorithm. To use the regular definition of the RHCP, use nan. If you want to add a penalty to favor a given angle orientation in the zirconium phase, enter this angle in rad. We recommend using nan or pi/4.
% - binaryImage: The binary image.

% Outputs:
% - child: The horitontal positions of the child path.


%%%%%%%%%%%%%%%%%%%% Derive the size of binary image %%%%%%%%%%%%%%%%%%%%%%
limit_binaryImage_x_min = 1;
limit_binaryImage_x_max = size(binaryImage,2);
limit_binaryImage_y_min = 1;
limit_binaryImage_y_max = size(binaryImage,1);

%%%%%%%%%%%%%%%%%% Initialize child as equal to nodes %%%%%%%%%%%%%%%%%%%%%
child = nodes;

%%%%%%%%%%%%%%%%%% Determine if desiredAngle is used %%%%%%%%%%%%%%%%%%%%%%
if isnan(desiredAngle) % if there is no desired angle, then the child is simply equal to the node with a vertical line between pos_y_current and pos_y_aim
    if pos_y_current > pos_y_aim
        child(pos_y_aim:pos_y_current,1)=nodes(pos_y_current,1);
    else
        child(pos_y_current:pos_y_aim,1)=nodes(pos_y_current,1);
    end
    
else
    % if there is a desired angle, then the path will follow that
    % orientation and bounce against the edges of the image until
    % reaching the desired position
    pos_y_it = pos_y_current;
    end_reached = 0;
    while end_reached == 0 % continue as long as the end isn't reached
        dx = abs((pos_y_it-pos_y_aim)*tan(desiredAngle));
        x0p = child(pos_y_it,1)+dx;
        x0m = child(pos_y_it,1)-dx;
        if x0p>limit_binaryImage_x_max % x0p is out
            if x0m>=limit_binaryImage_x_min % x0p is out and x0m is in
                x0 = x0m;
                end_reached = 1;
            else % both x0p and x0m are out
                x0m_delta = abs(x0m-limit_binaryImage_x_min);
                x0p_delta = abs(x0p-limit_binaryImage_x_max);
                x0_delta = min(x0m_delta,x0p_delta);
                if x0_delta == x0p_delta
                    x0 = limit_binaryImage_x_max;
                else
                    x0 = limit_binaryImage_x_min;
                end
                % Determine the position along y at which the
                % path will be bouncing off the edge of the
                % image
                dy = floor((dx-x0_delta)/tan(pi/2-desiredAngle));
                
                % Change the path between the current point and
                % the bouncing point
                Step = -(child(pos_y_it,1) - x0)/dy;
                if pos_y_it > pos_y_aim % if the current point position is higher than the aim point, i.e later on the path. (usually, pos_y_aim = 1)
                    for i = pos_y_it-dy:pos_y_it
                        child(i,1) = round(x0+((i-(pos_y_it-dy))*Step));
                    end
                    pos_y_it = pos_y_it - dy;
                else
                    for i = pos_y_it:pos_y_it+dy
                        child(i,1) = round(child(pos_y_it,1)+((i-(pos_y_it))*Step));
                    end  
                    pos_y_it = pos_y_it + dy;
                end

            end
        elseif x0m<limit_binaryImage_x_min % x0p is in and x0m is out
            x0 = x0p;
            end_reached = 1;
        elseif rand <= 1/5 % both x0p and x0m are in
            x0 = x0m;
            end_reached = 1;
        else
            x0 = x0p;
            end_reached = 1;
        end
    end
    
    % Create the new path
    Step = (child(pos_y_it,1) - x0)/(pos_y_it-pos_y_aim);
    if pos_y_it > pos_y_aim
        for i = pos_y_aim:pos_y_it
            child(i,1) = round(x0+((i-pos_y_aim)*Step));
        end
    else
        if pos_y_it < pos_y_aim
            for i = pos_y_it:pos_y_aim
                child(i,1) = round(child(pos_y_it,1)+((i-pos_y_it)*Step));
            end 
        end
    end
   
    
end

% clean up the path in case it goes outside of the image because of 'round'
child(child<limit_binaryImage_x_min)=limit_binaryImage_x_min;
child(child>limit_binaryImage_x_max)=limit_binaryImage_x_max;


end


            

