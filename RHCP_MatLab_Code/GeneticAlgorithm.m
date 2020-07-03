function [nodes, eval, bestPath, bestEval] = GeneticAlgorithm(primary_nodes,nodes, Mutation,CPMax, PerCut, tolConvergence,binaryImage,fracParamZr,fracParamZrH,valueZrH,num_smoothing, plotFrequency, filename, codeFolderName, resultsFolderName, numRun, desiredAngle, W, y_step, first_column, bands_global_iteration, bands_iteration)
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
% GeneticAlgorithm takes an initial generation of paths and successively
% generates children paths that will replace their parents when they
% improve the population. A child is created by combining the positions of 
% two parent paths. A child improves the population when its RHCP_x value 
% is better than one of its parents. 
% The algorithm stops when one of the user-defined convergence criteria is
% met. 
% This function also plots its populations RHCP values evolution when
% prompted.

% Inputs:
% - primary_nodes: The positions of the primary nodes.
% - nodes: The horitontal positions of the numPaths paths.
% - Mutation: For the genetic algorithm. The chance of random mutation when deriving a child path. We recommend using 0.05.
% - CPMax: For the genetic algorithm. Maximum number of generations. We recommend using 50001.
% - PerCut: For the genetic algorithm convergence. The acceptance rate for new generations under which the porgram should stop. We recommend using 0.01.
% - tolConvergence: For the genetic algorithm convergence. The tolerance for the difference between the RHCP value of the best and worst paths. The algorithm stops when the difference is smaller than this tolerance. We recommend using 1e-4.
% - binaryImage: The binary image.
% - fracParamZr: For the genetic algorithm. Fracture toughness of the zirconium phase. We recommend using 50.
% - fracParamZrH: For the genetic algorithm. Fracture toughness of the hydride phase. We recommend using 1.
% - valueZrH: For the genetic algorithm. Binary value representing the hydride phase, as opposed to the zirconium phase in the image. With the microstructures given here, you should use 1.
% - num_smoothing: For the genetic algorithm. Number of times the path is smoothed. We recommend using 1, doing it more than that does not really increase the path quality..
% - plotFrequency: For the genetic algorithm. Number of generation between plots of the paths. Having a small number here slows down the algorithm as it wastes time plotting figures. We recommend using 1000.
% - filename: Name of the microstructure file.
% - codeFolderName: The name of the folder in which the RHF code is stored.
% - resultsFolderName: The name of the folder in which the results will be stored. The folder is created if it does not already exist.
% - numRun: For the genetic algorithm. Number of times the genetic algorithm is run on each microstructure. To save time, we recommend using 1.
% - desiredAngle: For the genetic algorithm. To use the regular definition of the RHCP, use nan. If you want to add a penalty to favor a given angle orientation in the zirconium phase, enter this angle in rad. We recommend using nan or pi/4.
% - W: For the genetic algorithm. Magnitude of the penalty to favor a given angle. This is not used if desiredAngle = nan. We recommend using 13 otherwise.
% - y_step: For the genetic algorithm. Length of the paths section used to determine its orientation. This is not used if desiredAngle = nan. Otherwise, it is used to accurately determine the paths orientation and apply the angle penalty. We recommend using 10.
% - first_column: The position of the left end of the band being analyzed.
% - bands_global_iteration: The number of the iteration for the global for-loop in RHCP_file.
% - bands_iteration: The number of the band being analyzed. 

% Outputs:
% - nodes: The horitontal positions of the paths at the end of the genetic algorithm.
% - eval: The evaluation values of the paths in nodes.
% - bestPath: The positions of the points of the best path created by the genetic algorithm.
% - bestEval: The evaluation value of the best path.
% During this function, the evolution of the RHCP values of the generations
% are plotted and saved.

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Initialize %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bestPath = zeros(size(binaryImage,1),1); %The best pathway from the gene pool from this run of the search
bestEval = zeros(1,2); %Evaluations for the best pathway
num_primary_nodes = length(primary_nodes);
primary_nodes_dist = abs(primary_nodes(2)-primary_nodes(1)); % distance between primary nodes
numPaths = size(nodes,2);
max_eval = [];
min_eval = [];
median_eval = [];
mean_eval = [];
perAcc = 1; %Initialize PerAcc to enter while loop
cPAttempts = 1; %The number of child pathways attempted
CPAccepted = 0; %The number of child pathways accepted into gene pool
CPTotal = 1; %The total number of child pathways attempted
perAcc_vect = [perAcc];
perAcc_vect_abscissa = [0];

%%%%%%%%%%%%%%%%%%%%%%%%% Evaluate Initial Guesses %%%%%%%%%%%%%%%%%%%%%%%%
eval = EvalPaths(nodes,binaryImage,fracParamZr,fracParamZrH,valueZrH,desiredAngle,W,y_step);
max_eval = [max_eval max(eval(:,1))];
min_eval = [min_eval min(eval(:,1))];
median_eval = [median_eval median(eval(:,1))];
mean_eval = [mean_eval mean(eval(:,1))];


%%%%%%%%%%%%%%%%%%%%%%%%% Run GA until convergence %%%%%%%%%%%%%%%%%%%%%%%%
while not((CPTotal > CPMax) || (perAcc < PerCut) || (abs(max_eval(end)-min_eval(end)) < tolConvergence))
    % Mix two pathways
    parent_A = 0; %Parent pathway A
    parent_B = 0; %Parent pathway B
    while parent_A == parent_B %Pick two different random pathways
       parent_A = randi([1,numPaths]);
       parent_B = randi([1,numPaths]);
    end

    % Mix primary nodes between the two parents
    child = zeros(size(binaryImage,1),1); % Stores child pathway node coordinates
    for m = 1:num_primary_nodes
        if rand < Mutation % Mutation chance
            child(primary_nodes(m)) = randi([1,size(binaryImage,2)-1]);
        elseif rand > rand % Parent pathway A passes on gene
            child(primary_nodes(m)) = nodes(primary_nodes(m),parent_A);
        else % Parent pathway B passes on gene
            child(primary_nodes(m)) = nodes(primary_nodes(m),parent_B);
        end
    end

    % Place guide nodes for Child
    child = PlaceGuideNodes(primary_nodes_dist, primary_nodes, child);

    % Improve the child by smoothing it out
    child = ImprovePaths(child,binaryImage,fracParamZr,fracParamZrH,valueZrH,num_smoothing,desiredAngle,W,y_step);

    % Evaluate child pathway
    childEval = EvalPaths(child,binaryImage,fracParamZr,fracParamZrH,valueZrH,desiredAngle,W,y_step);

    % Replace worst parent pathway with child pathway if it is better
    if eval(parent_B,1) >= eval(parent_A,1) %Determine worst parent pathway
        low = parent_A;
    else
        low = parent_B;
    end
    if childEval(1,1) > eval(low,1) %If child pathway is better it replaces worst parent
        nodes(:,low) = child(:);
        eval(low,:) = childEval(:);
        CPAccepted = CPAccepted +1; %Incriment number of child pathways accepted into gene pool
    end

    % Determine the delta mean P periodically
    if CPAccepted ==  max(100,numPaths) || cPAttempts == max(1000,CPMax/100)
        perAcc = CPAccepted/cPAttempts; %Update ratio of accepted paths to control while loop
        cPAttempts = 1; %The number of child pathways attempted
        CPAccepted = 0; %The number of child pathways accepted into gene pool

        perAcc_vect = [perAcc_vect perAcc];
        perAcc_vect_abscissa = [perAcc_vect_abscissa CPTotal];
        plotAcceptance(codeFolderName, filename, resultsFolderName, CPTotal, perAcc_vect, perAcc_vect_abscissa, PerCut, numRun, bands_global_iteration, bands_iteration)
    end

    % Plot the new paths
    plotPaths(nodes, plotFrequency, filename, codeFolderName, resultsFolderName, CPTotal, numRun,first_column, bands_global_iteration, bands_iteration);

    % Plot the new path evaluations
    max_eval = [max_eval max(eval(:,1))];
    min_eval = [min_eval min(eval(:,1))];
    median_eval = [median_eval median(eval(:,1))];
    mean_eval = [mean_eval mean(eval(:,1))];
    plotEval(codeFolderName, filename, resultsFolderName, plotFrequency, max_eval, min_eval, median_eval, mean_eval, CPTotal, numRun, bands_global_iteration, bands_iteration)

    % Update the numbers of child pathways (total and attempted)
    cPAttempts = cPAttempts + 1;
    CPTotal = CPTotal + 1;

end

%%%%%%%%%%%%%%%%%%%%%%% Evaluate all paths %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eval = EvalPaths(nodes,binaryImage,fracParamZr,fracParamZrH,valueZrH,desiredAngle,W,y_step);
max_eval = [max_eval max(eval(:,1))];
min_eval = [min_eval min(eval(:,1))];
median_eval = [median_eval median(eval(:,1))];
mean_eval = [mean_eval mean(eval(:,1))];
plotEval(codeFolderName, filename, resultsFolderName, CPTotal-1, max_eval, min_eval, median_eval, mean_eval, CPTotal, numRun, bands_global_iteration, bands_iteration)

%%%%%%%%%%%%%%%%%%%%%%%%% Find best path %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[bestEval_1, bestEval_ind] = max(eval(:,1));
bestEval(1,:) = eval(bestEval_ind,:);
bestPath = nodes(:,bestEval_ind);

end
