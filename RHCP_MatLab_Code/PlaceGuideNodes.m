function [ nodes ] = PlaceGuideNodes(primary_nodes_dist, primary_nodes, nodes)
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
% PlaceGuideNodes places the guide nodes in straight lines between the
% primary nodes.

% Inputs:
% - nodes: The horitontal positions of the numPaths paths.
% - primary_nodes: The position of the primary nodes.
% - primary_nodes_dist: The user-set distance between primary nodes.

% Outputs:
% - nodes: The horitontal positions of the numPaths paths.

%%%%%%%%%%%%%%%%%%%%%% Derive the number of paths %%%%%%%%%%%%%%%%%%%%%%%%%
numPaths = size(nodes,2);
num_primary_nodes = length(primary_nodes);

%%%%%%%%%%%%%%%% Place guide nodes between primary nodes %%%%%%%%%%%%%%%%%%
% Guide nodes are placed in a straight line between primary nodes
for m = 1:numPaths
    for n = 1:num_primary_nodes-1
        for i = 1:primary_nodes(n+1)-primary_nodes(n)-1 %1 to the number of guide nodes between primary nodes
            nodes((n-1)*primary_nodes_dist+i+1,m) = round(nodes(primary_nodes(n),m)+i*((nodes(primary_nodes(n+1),m)-nodes(primary_nodes(n),m))/(primary_nodes(n+1)-primary_nodes(n)))); %Calculate position of each guide node
        end
    end
end

end
