function [nodes_bridge_band] = bridgeBands(nodes_first_band,nodes_second_band,bridge_criteria_ratio,length_binaryImage,binaryImage_band,valueZrH)
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
% This function is called by RHCP_file and creates new paths from the two
% best paths from the populations from two different bands. It creates new 
% paths by merging the paths when they touch, or when the is enough hydride
% pixels between them. 

% Inputs:
% - nodes_first_band: Best path from the first band.
% - nodes_second_band: Best path from the second band.
% - bridge_criteria_ratio: For the genetic algorithm. Fraction of hydride that should be present between two path to justify building a bridge between two paths from two different bands. We recommend using 0.6.
% - length_binaryImage: vertical length of the binary image.
% - valueZrH: For the genetic algorithm. Binary value representing the hydride phase, as opposed to the zirconium phase in the image. With the microstructures given here, you should use 1.
% - inaryImage_band: Current band of the microstructure being studied.

% Outputs:
% - nodes_bridge_band: paths created by merging the two populations.

%%%%%%%%%%%%%%%%%%%%%%%%%% Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nodes_bridge_band = [];
close_path = 0; % booleen used to keep track when the path were close to limit the number of redundant bridges
existing_bridges = [0 0]; % store the position couples that were selected to create a bridge to limit the number of redundant bridges

%%%%%%%%%%%%%%%%%%%%% Go through the first path %%%%%%%%%%%%%%%%%%%%%%%%%%%
for pos_y=2:length_binaryImage
    %%%%%%%%%%%% Merge the two paths if they (almost) touch %%%%%%%%%%%%%%%
    if abs(nodes_first_band(pos_y,1)-nodes_second_band(pos_y,1))<5 % test if the two paths are very close
        % if this is the case, then there is no need to go through the
        % second path, we can just merge the two paths together here,
        % unless is has been done above and the two path haven't been
        % separated since.
        if close_path == 0 % test if the paths were close or not
            % if the paths were not connected, then we connect them
            nodes_new1 = [nodes_first_band(1:pos_y,1)' nodes_second_band((pos_y+1):end,1)']';
            nodes_new2 = [nodes_second_band(1:pos_y,1)' nodes_first_band((pos_y+1):end,1)']';
            nodes_bridge_band = [nodes_bridge_band nodes_new1 nodes_new2];
        end
        % Save the fact that the path were close
        close_path = 1;
    else
        %%%%%%% If paths are far, test if a hydride can bridge them %%%%%%%
        % Save the fact that the path were not close
        close_path = 0;
        % In that case, we try to connect the two paths in every way
        % possible
        for pos_y_2=1:(length_binaryImage-1)
            bridge_positions_x = [];
            % derive which position along y is higher, and to which path it
            % corresponds
            pos_y_tab = [pos_y pos_y_2];
            nodes_band_tab = [nodes_first_band nodes_second_band];
            [pos_y_min,ind_pos_x_tab_min] = min(pos_y_tab);
            [pos_y_max,ind_pos_x_tab_max] = max(pos_y_tab);
            if pos_y_max ~= pos_y_min % only merge path when the two nodes are on a different level
                % create new bridge
                % derive the x positions of the bridge between the two
                % paths
                num_overlap_points = 0;
                for i=pos_y_min:pos_y_max
                    bridge_positions_x(i-pos_y_min+1) = round((nodes_band_tab(pos_y_max,ind_pos_x_tab_max)-nodes_band_tab(pos_y_min,ind_pos_x_tab_min))/(pos_y_max-pos_y_min)*(i-pos_y_min) + nodes_band_tab(pos_y_min,ind_pos_x_tab_min));
                    % test if that point is already on a path (i=pos_y_min and i=pos_y_min will count, so num_overlap_points >=2)
                    num_overlap_points = num_overlap_points + (nodes_first_band(i,1)==bridge_positions_x(i-pos_y_min+1))+(nodes_second_band(i,1)==bridge_positions_x(i-pos_y_min+1)); 
                end
                
                % test if that bridge is along a path, and is thus a
                % lesser double to another bride built on the path
                criteria1 = (num_overlap_points<4); % by definition num_overlap_points>=2
                
                % test if that bridge is very similar to an existing bridge
                f1 = find(existing_bridges(:,1)==pos_y);
                f2 = find(existing_bridges(:,2)==pos_y_2);
                k = length(f2);
                size_find = 0; % initiate at false
                while (k>0) && (size_find == 0)
                    size_find = size(find(f1==f2(k)),1);
                    k=k-1;
                end

                if criteria1 && (size_find == 0) % if criteria 1 is respected and the bridge doesn't already exists, we test the other criteria, otherwise we just disregard that bridge altogether
                    % test if the hydride criteria is met for this bridge
                    fracZrH = 0;
                    fracZr = 0;
                    for n = 1:length_binaryImage-1
                        pos_x_bridge_detailed=round((nodes_band_tab(pos_y_max,ind_pos_x_tab_max)-nodes_band_tab(pos_y_min,ind_pos_x_tab_min))/(length_binaryImage-1)*n+nodes_band_tab(pos_y_min,ind_pos_x_tab_min));
                        % Determine the position along y
                        pos_y_bridge_detailed = round((pos_y_max-pos_y_min)/(length_binaryImage-1)*n+pos_y_min);
                        % Determine the phase of the current pixel  and add it to the
                        % corresponding fraction
                        if isnan(pos_y_bridge_detailed)||(pos_y_bridge_detailed<=0)||(pos_x_bridge_detailed<=0)%%%%%%%%%%%%%%%%%%%%% 
                            disp('debug - bridgeBands - 2.7') %%% I had an issue with these indices
                            pos_y_min
                            pos_y_max
                            nodes_band_tab(pos_y_max,ind_pos_x_tab_max)
                            nodes_band_tab(pos_y_min,ind_pos_x_tab_min)
                            pos_y_bridge_detailed
                            pos_x_bridge_detailed
                        end
                        if binaryImage_band(pos_y_bridge_detailed,pos_x_bridge_detailed) == valueZrH
                            fracZrH = fracZrH + 1;
                        else
                            fracZr = fracZr + 1;
                        end
                    end
                    total_pixels = fracZrH + fracZr;
                    fracZrH = fracZrH/total_pixels;
                    if fracZrH > bridge_criteria_ratio
                        % create new path and add it to the list of paths
                        if pos_y < pos_y_2
                            nodes_new = [nodes_first_band(1:pos_y-1,1)' bridge_positions_x nodes_second_band((pos_y_2+1):end,1)']';
                        else
                            nodes_new = [nodes_second_band(1:pos_y_2-1,1)' bridge_positions_x nodes_first_band((pos_y+1):end,1)']';
                        end
                        nodes_bridge_band = [nodes_bridge_band nodes_new];
                        % add the bridge to the list of existing bridges,
                        % plus the ones that we do not want to add to avoid
                        % redundancy
                        
                        existing_bridges_add = []; % using this vector rather than the base vector is great for speed
                        k_lim = 3;
                        for k1=-k_lim:k_lim
                            for k2=-k_lim:k_lim
                                existing_bridges_add = [existing_bridges_add; pos_y+k1 pos_y_2+k2];
                            end
                        end
                        existing_bridges = [existing_bridges; existing_bridges_add];
                    end
                end
            end
        end
    end
end

end

