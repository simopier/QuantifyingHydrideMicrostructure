% Run verification of the continuity code

% clean workspace
close all
clear

% Initialize inputs
codeFolderNameRHCF = 'Connectivity_Code_RHCF';
codeFolderNameHCC = 'Connectivity_Code_HCC';
codeFolderNameRHCP = 'RHCP_Matlab_Code';
imageFolderName = 'Continuous_Verification_Micrographs'; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
imageFolderNameExpectedContinuity = 'Connectivity_HCC_RHCF_RHCP_Verification_data';
csvfilename_Expected = 'RHCF_HCC_RHCP_values_verification.csv';
startingLowThreshold = 250;
startingHighThreshold = 500;
SpotSize = 0;
HoleSize = 0;
resolution = 0;
resultsFolderNameRHCF = 'Connectivity_Code_RHCF_Verification_results_2';
resultsFolderNameHCC = 'Connectivity_Code_HCC_Verification_results_2';
resultsFolderNameRHCP = 'RHCP_Verification_results_bands_1_nan_2';% 'Connectivity_Code_RHCP_paths_test'; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Min_Segment_Length = 20;
PerCut = 0.01; % 0.03
tolConvergence = 1e-4;
numPaths = 50;
Mutation = 0.05;
primary_nodes_dist = 1;
disp_num = 50;
disp_size = 20;
annealingTime = 10000; % 100000;
numRun = 1; %%%2
CPMax =  50001;
num_smoothing = 1;
fracParamZr = 50;
fracParamZrH = 1;
valueZrH = 1;
num_bands = 1; %%%%%%%%%%%%%%%%%%%%
bridge_criteria_ratio = 0.6;
plotFrequency = 5000; % 500
desiredAngle = nan; % angle in rad, or nan
W = 13;
y_step = 10;


L = 1000;
if not(isnan(desiredAngle))
    disp('With this choice of desiredAngle and W:')
    syms theta
    S_max = vpasolve( 4*W*theta*(theta^2-desiredAngle^2)*cos(theta)+(1+W*(desiredAngle-theta)^2*(desiredAngle+theta)^2)*sin(theta) == 0, theta, [0.0000000001 pi/2]);
        if size(S_max,1) == 0
            disp('There is no solution at all when there is no hydride')
        else
            theta_max = double(S_max);
            Delta_theta = desiredAngle-theta_max;
            RHCP_max = ((L/cos(desiredAngle)-L/cos(desiredAngle)*(1+W*(desiredAngle+theta_max)^2*(desiredAngle-theta_max)^2))*fracParamZr-0*fracParamZrH)/(L*(fracParamZr/cos(desiredAngle)-fracParamZrH));
            disp('The error on the angle is expected to be equal to (in degrees):')
            Delta_theta*180/pi
            disp('With the given image length, the error on RHCP is expected to be equal to:')
            RHCP_max
        end
    pause
end

% Perform verification
Continuity_Verification( codeFolderNameRHCF,codeFolderNameHCC,codeFolderNameRHCP,imageFolderName,imageFolderNameExpectedContinuity,csvfilename_Expected,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution,resultsFolderNameRHCF,resultsFolderNameHCC,resultsFolderNameRHCP, Min_Segment_Length, PerCut, tolConvergence, numPaths, Mutation, primary_nodes_dist, disp_num, disp_size, annealingTime, numRun, CPMax, num_smoothing,fracParamZr,fracParamZrH,valueZrH, num_bands, bridge_criteria_ratio, plotFrequency,desiredAngle,W,y_step)



