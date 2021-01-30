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
% Run verification of the RHCP code

%%%%%%%%%%%%%%%%%%%%%%%%% Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clean workspace
close all
clear

% Initialize inputs
codeFolderNameRHCF = 'RHCF_Matlab_Code';
codeFolderNameHCC = 'HCC_Matlab_Code';
codeFolderNameRHCP = 'RHCP_Matlab_Code';
imageFolderName = 'RHCP_Band_Microstructure';
imageFolderNameExpectedContinuity = 'Connectivity_HCC_RHCF_RHCP_Verification_data';
csvfilename_Expected = 'RHCF_HCC_RHCP_values_verification.csv';
startingLowThreshold = 250;
startingHighThreshold = 500;
SpotSize = 0;
HoleSize = 0;
resolution = 0;
resultsFolderNameRHCF = 'RHCF_Verification_results';
resultsFolderNameHCC = 'HCC_Verification_results';
resultsFolderNameRHCP = 'RHCP_Band_Results_45_1'; %%%%%%%%
band_width = Inf; % Use the whole image for HCC and RHCF
Min_Segment_Length = 5;
PerCut = 0.005; % 0.03
tolConvergence = 1e-4;
numPaths = 50;
Mutation = 0.05;
primary_nodes_dist = 1;
disp_num = 50;
disp_size = 20;
annealingTime = 1000;
numRun = 1; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CPMax =  50001;
num_smoothing = 1;
fracParamZr = 50;
fracParamZrH = 1;
valueZrH = 1;
num_bands = 1; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
bridge_criteria_ratio = 0.6;
plotFrequency = 5000; % 500
desiredAngle = pi/4; % angle in rad (pi/4), or nan
W = 13;
y_step = 10;

%%%%%%%%%%%%%%%%%%%%%% Provide possible error %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

%%%%%%%%%%%%%%%%%%%%%%% Perform verification %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Verification_Continuity( codeFolderNameRHCF,codeFolderNameHCC,codeFolderNameRHCP,imageFolderName,imageFolderNameExpectedContinuity,csvfilename_Expected,startingLowThreshold,startingHighThreshold,SpotSize,HoleSize,resolution,resultsFolderNameRHCF,resultsFolderNameHCC,resultsFolderNameRHCP, Min_Segment_Length, band_width, PerCut, tolConvergence, numPaths, Mutation, primary_nodes_dist, disp_num, disp_size, annealingTime, numRun, CPMax, num_smoothing,fracParamZr,fracParamZrH,valueZrH, num_bands, bridge_criteria_ratio, plotFrequency,desiredAngle,W,y_step)
