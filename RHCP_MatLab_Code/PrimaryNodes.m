function [num_primary_nodes,primary_nodes] = PrimaryNodes(length_binaryImage,primary_nodes_dist)
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
% PrimaryNodes determines the position of the primary nodes, which are the
% nodes that are part of the genome.

% Inputs:
% - length_binaryImage: The vertical length of the binary image.
% - primary_nodes_dist: The user-set distance between primary nodes.

% Outputs:
% - num_primary_nodes: The number of primary nodes.
% - primary_nodes: A vector containing the vertical positions of the primary nodes.

%%%%%%%%%%%%%%%%%%%%%% Determine primary nodes %%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (rem(length_binaryImage,primary_nodes_dist)==0 || rem(length_binaryImage,primary_nodes_dist)==1)
    num_primary_nodes = floor(length_binaryImage/primary_nodes_dist);
else
    num_primary_nodes = floor(length_binaryImage/primary_nodes_dist)+1;
end

primary_nodes = zeros(num_primary_nodes+1,1); %Stores Y-coordinate of each primary node

for m = 0:num_primary_nodes
    primary_nodes(m+1) = 1+m*primary_nodes_dist;
end
if (primary_nodes(num_primary_nodes+1) > length_binaryImage)
    primary_nodes(num_primary_nodes+1) = length_binaryImage;
end

end