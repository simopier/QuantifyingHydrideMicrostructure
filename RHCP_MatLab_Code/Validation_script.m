% Run validation of the continuity code

% clean workspace
close all
clear

% Initialize inputs
codeFolderNameRHCP = 'Connectivity_Code_RHCP_bands_2';
imageFolderName = 'Continuous_Validation_Test_Images_less'; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Continuous_Validation_Test_Images
startingLowThreshold = 250;
startingHighThreshold = 500;
SpotSize = 0;
HoleSize = 0;
resolution = 0;
resultsFolderNameRHCP = 'Connectivity_Code_RHCP_Validation_results_1_45_13_bands'; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Min_Segment_Length = 20;
PerCut = 0.01; % 0.03 % 0.01
tolConvergence = 1e-4;
numPaths = 50; %100
Mutation = 0.05;
primary_nodes_dist = 1;
disp_num = 20;
disp_size = 20;
annealingTime = 100; % 100000;
numRun = 1; %%%2
CPMax = 100001; %20001
num_smoothing = 1;
fracParamZr = 50;
fracParamZrH = 1;
valueZrH = 1;
num_bands = 5;
bridge_criteria_ratio = 0.6;
plotFrequency = 1000;
desiredAngle = nan; % angle in rad, or nan
W = 13;
y_step = 10;

Connectivity_RHCP_main(codeFolderNameRHCP,imageFolderName,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution,resultsFolderNameRHCP, PerCut, tolConvergence, numPaths, Mutation, primary_nodes_dist, disp_num, disp_size, annealingTime, numRun, CPMax, num_smoothing, fracParamZr, fracParamZrH, valueZrH, num_bands, bridge_criteria_ratio, plotFrequency, desiredAngle, W, y_step)
