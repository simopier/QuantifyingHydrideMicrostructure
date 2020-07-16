function [ ] = plotVerification( codeFolderName, VerificationResultsFolderName,filename_results, VerificationExpectedResultsFolderName, VerificationExpectedResultsFile )
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
% This function is used for the verification of the RHF definition and
% implementation. It is called by RHF_Verification_Script.m to perform the
% analysis. It calls RHF_main to measure the RHF of verification
% microstructures.

% Inputs:
% - codeFolderName: The name of the folder in which the RHF code is stored.
% - VerificationResultsFolderName: Name of the folder containing the verification results.
% - filename_results: Name of the file that will be saved in VerificationResultsFolderName and contain the verification results.
% - VerificationExpectedResultsFolderName: Name of the folder containing the expected values for RHF.
% - VerificationExpectedResultsFile: Name of the .csv file in imageFolderNameExpectedRHF containing the list of the microstructures names and expected RHF values.

% Outputs:
% None, but this function plots and save the verification results in the 
% result folder.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Extract data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd ../
cd(VerificationResultsFolderName)
Table1=csvread(filename_results,1,0);
RHF_Experimental=Table1(:,2);    % This column corresponds to the measured radial hydride fractions of the images
cd ../
cd(VerificationExpectedResultsFolderName)
Table2=csvread(VerificationExpectedResultsFile,1,0);
RHF_Expected=Table2(:,2);       % This column corresponds to the expected radial hydride fractions of the images
RHF_previous=Table2(:,3);          % This column corresponds to the radial
% hydride fractions of the images measured with the old method
cd ../
cd(VerificationResultsFolderName)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Plot results %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
color1 = [1 133 113]/255;
color1Fill = [128 205 193]/255;
color2 = [166 97 26]/255;
color2Fill = [223 194 125]/255;
opts.width      = 13;
opts.height     = 13;
opts.fontType   = 'Latex';

figRHF = figure;
hold on
axis([0 1 0 1])
sz = 60;
plot(RHF_Expected,RHF_Expected,...
    '--o',...
    'Color',color1,...
    'LineWidth',1)
scatter(RHF_Expected,RHF_previous,...
    sz-20,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','k',...
    'LineWidth',1)
scatter(RHF_Expected,RHF_Experimental,...
    sz,...
    'MarkerEdgeColor',color2,...
    'MarkerFaceColor',color2Fill,...
    'LineWidth',1)

xlab=xlabel('Expected RHF');
ylab=ylabel('RHF');
legend({'Expected RHF', 'Existing RHF','Measured new RHF'})

set([xlab,ylab,legend],'fontsize',18)
set([legend],'fontsize',18,'location', 'NorthWest')
%axis([0 1 0 1])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Save figure %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% scaling
fig.Units               = 'centimeters';
fig.Position(3)         = opts.width;
fig.Position(4)         = opts.height;
% remove unnecessary white space
set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
box on
% Export to PDF
set(gca,'units','centimeters')
set(gcf,'PaperUnits','centimeters');
set(gcf,'PaperSize',[opts.width opts.height]);
set(gcf,'PaperPositionMode','manual');
set(gcf,'PaperPosition',[0 0 opts.width opts.height]);
saveas(gcf,'RHFcurve.pdf')

cd ../
cd(codeFolderName)

end

