function [nodes] = RandomPathsGenerator(binaryImage,numPaths,primary_nodes,primary_nodes_dist)
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
% RandomPathsGenerator generates numPaths random paths across the image,
% defines the primary nodes, and defines the guide nodes as well.

% Inputs:
% - binaryImage: The binary image.
% - numPaths: The user-defined number of paths per generation.
% - primary_nodes: The position of the primary nodes.
% - primary_nodes_dist: The user-set distance between primary nodes.

% Outputs:
% - nodes: The horitontal positions of the numPaths paths.

%%%%%%%%%%%%%%%%%% Derive the number of primary nodes %%%%%%%%%%%%%%%%%%%%%
num_primary_nodes = length(primary_nodes);

%%%%%%%%%%%%%%%% Determine x position for primary nodes %%%%%%%%%%%%%%%%%%%
nodes = zeros(size(binaryImage,1),numPaths); %Stores all X-coordinates making up all pathways, Nodes's index is the Y-coordinate
for m = 1:numPaths
    for n = 1:num_primary_nodes
        % Assign random X-coordinate within segments boundaries to each primary node
        nodes(primary_nodes(n),m) = randi([2,size(binaryImage,2)-1]); 
    end
end

%%%%%%%%%%%%%%%% Place guide nodes between primary nodes %%%%%%%%%%%%%%%%%%
% Guide nodes are placed in a straight line between primary nodes
nodes = PlaceGuideNodes(primary_nodes_dist, primary_nodes, nodes);

end
