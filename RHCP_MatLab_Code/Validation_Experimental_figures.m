%-------------------------------------------------------------------------%
%                                                                         %
%       Script developed by Pierre-Clement A Simon                        %
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
% For RHCP validation against experiment. It also validate RHF. 
% This script uses the relevant data developped in the .xlsx file named 
% 'RHCP_Validation_experiment.xlsx' and plots and analyzes the data to
% validate RHCP against experimental measurements

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Initialization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clear workspace
close all
clear

% Initialization
codeFolderName = 'RHCP_MatLab_Code';
resultsFileName =  'RHCP_Validation_Experiment';

%%%%%%%%%%%%%%%%%%%%%%%%% Load and organize data %%%%%%%%%%%%%%%%%%%%%%%%%%

% The original data can be found in 'RHCP_Validation_experiment.xlsx'

% Kim 2015
% Contains all the data from Kim2015 for T=25 and 150, and for which I have
% microstructures. More data for t>150 C exists, but it then leads to
% lesser quality results
Kim2015_FractureEnergy_25_vect = [14.04494382 557.4157303 81.46067416]';
Kim2015_H_25_vect = [137 176 562]';
Kim2015_RHF_25_vect = [0.439 0.15176 0.23338]';
Kim2015_HCC_25_vect = [1 0.333655 0.98641]';
Kim2015_RHCF_25_vect = [1 0.0878525 0.94293]';
Kim2015_RHCP_25_vect = [0.790245 0.21356 0.66155]';
Kim2015_RHCP45_25_vect = [0.636575 0.1844 0.5841]';

Kim2015_FractureEnergy_150_vect = [27.52808989 603.9325843 419.6629213]';
Kim2015_H_150_vect = [129 207 843]';
Kim2015_RHF_150_vect = [0.5660975 0.333815 0.31649]';
Kim2015_HCC_150_vect = [0.88151 0.6264 0.948245]';
Kim2015_RHCF_150_vect = [0.70957 0.127005 0.504715]';
Kim2015_RHCP_150_vect = [0.7405575 0.42653 0.557485]';
Kim2015_RHCP45_150_vect = [0.57305 0.14375 0.2605]';

Kim2015_FractureEnergy_vect = [Kim2015_FractureEnergy_25_vect; Kim2015_FractureEnergy_150_vect];
Kim2015_H_vect = [Kim2015_H_25_vect; Kim2015_H_150_vect];
Kim2015_RHF_vect = [Kim2015_RHF_25_vect; Kim2015_RHF_150_vect];
Kim2015_HCC_vect = [Kim2015_HCC_25_vect; Kim2015_HCC_150_vect];
Kim2015_RHCF_vect = [Kim2015_RHCF_25_vect; Kim2015_RHCF_150_vect];
Kim2015_RHCP_vect = [Kim2015_RHCP_25_vect; Kim2015_RHCP_150_vect];
Kim2015_RHCP45_vect = [Kim2015_RHCP45_25_vect; Kim2015_RHCP45_150_vect];


%%%%%%%%%%%%%%%%%%%%%%%%% Linear regression %%%%%%%%%%%%%%%%%%%%%%%%%%%
% Linear regression 1
Kim2015_RHCP_vect_reg=[ones(length(Kim2015_RHCP_vect),1) Kim2015_RHCP_vect];
Kim2015_RHCP45_vect_reg=[ones(length(Kim2015_RHCP45_vect),1) Kim2015_RHCP45_vect];
Kim2015_RHF_vect_reg=[ones(length(Kim2015_RHF_vect),1) Kim2015_RHF_vect];
Kim2015_HCC_vect_reg=[ones(length(Kim2015_HCC_vect),1) Kim2015_HCC_vect];
Kim2015_RHCF_vect_reg=[ones(length(Kim2015_RHCF_vect),1) Kim2015_RHCF_vect];
Kim2015_H_vect_reg=[ones(length(Kim2015_H_vect),1) Kim2015_H_vect];
Kim2015_RHCP_25_vect_reg=[ones(length(Kim2015_RHCP_25_vect),1) Kim2015_RHCP_25_vect];
Kim2015_RHCP45_25_vect_reg=[ones(length(Kim2015_RHCP45_25_vect),1) Kim2015_RHCP45_25_vect];
Kim2015_RHF_25_vect_reg=[ones(length(Kim2015_RHF_25_vect),1) Kim2015_RHF_25_vect];
Kim2015_HCC_25_vect_reg=[ones(length(Kim2015_HCC_25_vect),1) Kim2015_HCC_25_vect];
Kim2015_RHCF_25_vect_reg=[ones(length(Kim2015_RHCF_25_vect),1) Kim2015_RHCF_25_vect];
Kim2015_H_25_vect_reg=[ones(length(Kim2015_H_25_vect),1) Kim2015_H_25_vect];
    % Get the coefficients
B_Kim2015_FractureEnergy_RHCP=Kim2015_RHCP_vect_reg\Kim2015_FractureEnergy_vect;
B_Kim2015_FractureEnergy_RHCP45=Kim2015_RHCP45_vect_reg\Kim2015_FractureEnergy_vect;
B_Kim2015_FractureEnergy_RHF=Kim2015_RHF_vect_reg\Kim2015_FractureEnergy_vect;
B_Kim2015_FractureEnergy_HCC=Kim2015_HCC_vect_reg\Kim2015_FractureEnergy_vect;
B_Kim2015_FractureEnergy_RHCF=Kim2015_RHCF_vect_reg\Kim2015_FractureEnergy_vect;
B_Kim2015_FractureEnergy_H=Kim2015_H_vect_reg\Kim2015_FractureEnergy_vect;
B_Kim2015_FractureEnergy_RHCP_25=Kim2015_RHCP_25_vect_reg\Kim2015_FractureEnergy_25_vect;
B_Kim2015_FractureEnergy_RHCP45_25=Kim2015_RHCP45_25_vect_reg\Kim2015_FractureEnergy_25_vect;
B_Kim2015_FractureEnergy_RHF_25=Kim2015_RHF_25_vect_reg\Kim2015_FractureEnergy_25_vect;
B_Kim2015_FractureEnergy_HCC_25=Kim2015_HCC_25_vect_reg\Kim2015_FractureEnergy_25_vect;
B_Kim2015_FractureEnergy_RHCF_25=Kim2015_RHCF_25_vect_reg\Kim2015_FractureEnergy_25_vect;
B_Kim2015_FractureEnergy_H_25=Kim2015_H_25_vect_reg\Kim2015_FractureEnergy_25_vect;
    % Create data from the coefficients
B_Kim2015_FractureEnergy_RHCP_y=Kim2015_RHCP_vect_reg*B_Kim2015_FractureEnergy_RHCP;
B_Kim2015_FractureEnergy_RHCP45_y=Kim2015_RHCP45_vect_reg*B_Kim2015_FractureEnergy_RHCP45;
B_Kim2015_FractureEnergy_RHF_y=Kim2015_RHF_vect_reg*B_Kim2015_FractureEnergy_RHF;
B_Kim2015_FractureEnergy_HCC_y=Kim2015_HCC_vect_reg*B_Kim2015_FractureEnergy_HCC;
B_Kim2015_FractureEnergy_RHCF_y=Kim2015_RHCF_vect_reg*B_Kim2015_FractureEnergy_RHCF;
B_Kim2015_FractureEnergy_H_y=Kim2015_H_vect_reg*B_Kim2015_FractureEnergy_H;
B_Kim2015_FractureEnergy_RHCP_25_y=Kim2015_RHCP_25_vect_reg*B_Kim2015_FractureEnergy_RHCP_25;
B_Kim2015_FractureEnergy_RHCP45_25_y=Kim2015_RHCP45_25_vect_reg*B_Kim2015_FractureEnergy_RHCP45_25;
B_Kim2015_FractureEnergy_RHF_25_y=Kim2015_RHF_25_vect_reg*B_Kim2015_FractureEnergy_RHF_25;
B_Kim2015_FractureEnergy_HCC_25_y=Kim2015_HCC_25_vect_reg*B_Kim2015_FractureEnergy_HCC_25;
B_Kim2015_FractureEnergy_RHCF_25_y=Kim2015_RHCF_25_vect_reg*B_Kim2015_FractureEnergy_RHCF_25;
B_Kim2015_FractureEnergy_H_25_y=Kim2015_H_25_vect_reg*B_Kim2015_FractureEnergy_H_25;
    % Determine the residual
R2Kim2015_FractureEnergy_RHCP = 1 - sum((Kim2015_FractureEnergy_vect - B_Kim2015_FractureEnergy_RHCP_y).^2)/sum((Kim2015_FractureEnergy_vect - mean(Kim2015_FractureEnergy_vect)).^2);
R2Kim2015_FractureEnergy_RHCP45 = 1 - sum((Kim2015_FractureEnergy_vect - B_Kim2015_FractureEnergy_RHCP45_y).^2)/sum((Kim2015_FractureEnergy_vect - mean(Kim2015_FractureEnergy_vect)).^2);
R2Kim2015_FractureEnergy_RHF = 1 - sum((Kim2015_FractureEnergy_vect - B_Kim2015_FractureEnergy_RHF_y).^2)/sum((Kim2015_FractureEnergy_vect - mean(Kim2015_FractureEnergy_vect)).^2);
R2Kim2015_FractureEnergy_HCC = 1 - sum((Kim2015_FractureEnergy_vect - B_Kim2015_FractureEnergy_HCC_y).^2)/sum((Kim2015_FractureEnergy_vect - mean(Kim2015_FractureEnergy_vect)).^2);
R2Kim2015_FractureEnergy_RHCF = 1 - sum((Kim2015_FractureEnergy_vect - B_Kim2015_FractureEnergy_RHCF_y).^2)/sum((Kim2015_FractureEnergy_vect - mean(Kim2015_FractureEnergy_vect)).^2);
R2Kim2015_FractureEnergy_H = 1 - sum((Kim2015_FractureEnergy_vect - B_Kim2015_FractureEnergy_H_y).^2)/sum((Kim2015_FractureEnergy_vect - mean(Kim2015_FractureEnergy_vect)).^2);
R2Kim2015_FractureEnergy_RHCP_25 = 1 - sum((Kim2015_FractureEnergy_25_vect - B_Kim2015_FractureEnergy_RHCP_25_y).^2)/sum((Kim2015_FractureEnergy_25_vect - mean(Kim2015_FractureEnergy_25_vect)).^2);
R2Kim2015_FractureEnergy_RHCP45_25 = 1 - sum((Kim2015_FractureEnergy_25_vect - B_Kim2015_FractureEnergy_RHCP45_25_y).^2)/sum((Kim2015_FractureEnergy_25_vect - mean(Kim2015_FractureEnergy_25_vect)).^2);
R2Kim2015_FractureEnergy_RHF_25 = 1 - sum((Kim2015_FractureEnergy_25_vect - B_Kim2015_FractureEnergy_RHF_25_y).^2)/sum((Kim2015_FractureEnergy_25_vect - mean(Kim2015_FractureEnergy_25_vect)).^2);
R2Kim2015_FractureEnergy_HCC_25 = 1 - sum((Kim2015_FractureEnergy_25_vect - B_Kim2015_FractureEnergy_HCC_25_y).^2)/sum((Kim2015_FractureEnergy_25_vect - mean(Kim2015_FractureEnergy_25_vect)).^2);
R2Kim2015_FractureEnergy_RHCF_25 = 1 - sum((Kim2015_FractureEnergy_25_vect - B_Kim2015_FractureEnergy_RHCF_25_y).^2)/sum((Kim2015_FractureEnergy_25_vect - mean(Kim2015_FractureEnergy_25_vect)).^2);
R2Kim2015_FractureEnergy_H_25 = 1 - sum((Kim2015_FractureEnergy_25_vect - B_Kim2015_FractureEnergy_H_25_y).^2)/sum((Kim2015_FractureEnergy_25_vect - mean(Kim2015_FractureEnergy_25_vect)).^2);
    % Order the data (for the plot)
mat = sortrows([Kim2015_RHCP_vect B_Kim2015_FractureEnergy_RHCP_y]);
Kim2015_1_RHCP_vect_reg_plot = mat(:,1);
B_Kim2015_FractureEnergy_RHCP_y = mat(:,2);
mat = sortrows([Kim2015_RHCP45_vect B_Kim2015_FractureEnergy_RHCP45_y]);
Kim2015_1_RHCP45_vect_reg_plot = mat(:,1);
B_Kim2015_FractureEnergy_RHCP45_y = mat(:,2);
mat = sortrows([Kim2015_RHF_vect B_Kim2015_FractureEnergy_RHF_y]);
Kim2015_1_RHF_vect_reg_plot = mat(:,1);
B_Kim2015_FractureEnergy_RHF_y = mat(:,2);
mat = sortrows([Kim2015_HCC_vect B_Kim2015_FractureEnergy_HCC_y]);
Kim2015_1_HCC_vect_reg_plot = mat(:,1);
B_Kim2015_FractureEnergy_HCC_y = mat(:,2);
mat = sortrows([Kim2015_RHCF_vect B_Kim2015_FractureEnergy_RHCF_y]);
Kim2015_1_RHCF_vect_reg_plot = mat(:,1);
B_Kim2015_FractureEnergy_RHCF_y = mat(:,2);
mat = sortrows([Kim2015_H_vect B_Kim2015_FractureEnergy_H_y]);
Kim2015_1_H_vect_reg_plot = mat(:,1);
B_Kim2015_FractureEnergy_H_y = mat(:,2);
mat = sortrows([Kim2015_RHCP_25_vect B_Kim2015_FractureEnergy_RHCP_25_y]);
Kim2015_1_RHCP_25_vect_reg_plot = mat(:,1);
B_Kim2015_FractureEnergy_RHCP_25_y = mat(:,2);
mat = sortrows([Kim2015_RHCP45_25_vect B_Kim2015_FractureEnergy_RHCP45_25_y]);
Kim2015_1_RHCP45_25_vect_reg_plot = mat(:,1);
B_Kim2015_FractureEnergy_RHCP45_25_y = mat(:,2);
mat = sortrows([Kim2015_RHF_25_vect B_Kim2015_FractureEnergy_RHF_25_y]);
Kim2015_1_RHF_25_vect_reg_plot = mat(:,1);
B_Kim2015_FractureEnergy_RHF_25_y = mat(:,2);
mat = sortrows([Kim2015_HCC_25_vect B_Kim2015_FractureEnergy_HCC_25_y]);
Kim2015_1_HCC_25_vect_reg_plot = mat(:,1);
B_Kim2015_FractureEnergy_HCC_25_y = mat(:,2);
mat = sortrows([Kim2015_RHCF_25_vect B_Kim2015_FractureEnergy_RHCF_25_y]);
Kim2015_1_RHCF_25_vect_reg_plot = mat(:,1);
B_Kim2015_FractureEnergy_RHCF_25_y = mat(:,2);
mat = sortrows([Kim2015_H_25_vect B_Kim2015_FractureEnergy_H_25_y]);
Kim2015_1_H_25_vect_reg_plot = mat(:,1);
B_Kim2015_FractureEnergy_H_25_y = mat(:,2);


%%%%%%%%%%%%%%%%%%%%%%%%%%% Options for plots %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% colors
% color1 = [1 133 113]/255;
% color1Fill = [128 205 193]/255;
% color2 = [166 97 26]/255;
% color2Fill = [223 194 125]/255;
% color3 = [0 0 0]/255;
% color3Fill = [255 255 255]/255;
color1 = [1 102 94]/255;
color2 = [90 180 172]/255;
color3 = [199 234 229]/255;
color4 = [246 232 195]/255;
color5 = [216 179 101]/255;
color6 = [140 81 10]/255;
color7 = [0 0 0]/255;
color8 = [255 255 255]/255;


sz = 80;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Plot the data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fig1 = figure;
hold on

scatter(Kim2015_RHCP45_25_vect,Kim2015_FractureEnergy_25_vect,...
    sz,...
    'o',...
    'MarkerEdgeColor',color1,...
    'MarkerFaceColor',color2,...
    'LineWidth',1.5)
scatter(Kim2015_RHCP45_150_vect,Kim2015_FractureEnergy_150_vect,...
    sz,...
    '^',...
    'MarkerEdgeColor',color1,...
    'MarkerFaceColor',color2,...
    'LineWidth',1.5)
plot(Kim2015_1_RHCP45_25_vect_reg_plot,B_Kim2015_FractureEnergy_RHCP45_25_y,...
    '--',...
    'Color',color1,...
    'LineWidth',2)
plot(Kim2015_1_RHCP45_vect_reg_plot,B_Kim2015_FractureEnergy_RHCP45_y,...
    ':',...
    'Color',color1,...
    'LineWidth',2)


scatter(Kim2015_RHCP_25_vect,Kim2015_FractureEnergy_25_vect,...
    sz,...
    'o',...
    'MarkerEdgeColor',color6,...
    'MarkerFaceColor',color5,...
    'LineWidth',1.5)
scatter(Kim2015_RHCP_150_vect,Kim2015_FractureEnergy_150_vect,...
    sz,...
    '^',...
    'MarkerEdgeColor',color6,...
    'MarkerFaceColor',color5,...
    'LineWidth',1.5)
plot(Kim2015_1_RHCP_25_vect_reg_plot,B_Kim2015_FractureEnergy_RHCP_25_y,...
    '--',...
    'Color',color6,...
    'LineWidth',2)
plot(Kim2015_1_RHCP_vect_reg_plot,B_Kim2015_FractureEnergy_RHCP_y,...
    ':',...
    'Color',color6,...
    'LineWidth',2)

max_x = 1;
max_y = 700;
str = ['$R^2$ = ' num2str(R2Kim2015_FractureEnergy_RHCP_25,3)];
text(0.425,368,str,'FontSize',15,'Interpreter','latex','rotation',atan(B_Kim2015_FractureEnergy_RHCP_25(2)/(max_y/max_x))*180/pi)
str = ['$R^2$ = ' num2str(R2Kim2015_FractureEnergy_RHCP,3)];
text(0.465,428.3173076923078,str,'FontSize',15,'Interpreter','latex','rotation',atan(B_Kim2015_FractureEnergy_RHCP(2)/(max_y/max_x))*180/pi)
str = ['$R^2$ = ' num2str(R2Kim2015_FractureEnergy_RHCP45_25,3)];
text(0.397474747474748,331.6826923076,str,'FontSize',15,'Interpreter','latex','rotation',atan(B_Kim2015_FractureEnergy_RHCP45_25(2)/(max_y/max_x))*180/pi)
str = ['$R^2$ = ' num2str(R2Kim2015_FractureEnergy_RHCP45,3)];
text(0.352424242424243,300.096153846,str,'FontSize',15,'Interpreter','latex','rotation',atan(B_Kim2015_FractureEnergy_RHCP45(2)/(max_y/max_x))*180/pi)

xlab=xlabel('Microstructure metric (RHCP)','Interpreter','latex','fontsize',20);
ylab=ylabel('Fracture energy/area (KJ/m$^2$)','Interpreter','latex','fontsize',20);
legend({'$RHCP^{45} - 25^{\circ}$','$RHCP^{45} - 150^{\circ}$','$RHCP^{45} - 25^{\circ}$ ','$RHCP^{45}$','$RHCP - 25^{\circ}$','$RHCP - 150^{\circ}$','$RHCP - 25^{\circ}$ ','$RHCP$'},'Interpreter','latex')
% set([legend],'fontsize',15,'location', 'NorthEast')
set([legend],'fontsize',15,'location', 'SouthOutside','Orientation','vertical','NumColumns',2)
axis([0 max_x 0 max_y])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Save the plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% options
opts.width      = 18;
opts.height     = 22;
opts.fontType   = 'Latex';
% scaling
fig1.Units               = 'centimeters';
fig1.Position(3)         = opts.width;
fig1.Position(4)         = opts.height;
% remove unnecessary white space
% set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
box on
% Export to PDF
set(gca,'units','centimeters')
set(gcf,'PaperUnits','centimeters');
set(gcf,'PaperSize',[opts.width opts.height]);
set(gcf,'PaperPositionMode','manual');
set(gcf,'PaperPosition',[0 0 opts.width opts.height]);
saveas(gcf,[resultsFileName '_Kim2015_RHCP.pdf'])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Plot the data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fig2 = figure;
hold on

scatter(Kim2015_H_25_vect,Kim2015_FractureEnergy_25_vect,...
    sz,...
    'o',...
    'MarkerEdgeColor',color7,...
    'MarkerFaceColor',color8,...
    'LineWidth',1.5)
scatter(Kim2015_H_150_vect,Kim2015_FractureEnergy_150_vect,...
    sz,...
    '^',...
    'MarkerEdgeColor',color7,...
    'MarkerFaceColor',color8,...
    'LineWidth',1.5)
plot(Kim2015_1_H_25_vect_reg_plot,B_Kim2015_FractureEnergy_H_25_y,...
    '--',...
    'Color',color7,...
    'LineWidth',2)
plot(Kim2015_1_H_vect_reg_plot,B_Kim2015_FractureEnergy_H_y,...
    ':',...
    'Color',color7,...
    'LineWidth',2)

max_x = 900;
max_y = 700;
str = ['$R^2$ = ' num2str(R2Kim2015_FractureEnergy_H_25,3)];
text(400,193,str,'FontSize',15,'Interpreter','latex','rotation',atan(B_Kim2015_FractureEnergy_H_25(2)/(max_y/max_x))*180/pi)
str = ['$R^2$ = ' num2str(R2Kim2015_FractureEnergy_H,3)];
text(400,305,str,'FontSize',15,'Interpreter','latex','rotation',atan(B_Kim2015_FractureEnergy_H(2)/(max_y/max_x))*180/pi)

xlab=xlabel('Hydrogen content [H] (wt.ppm)','Interpreter','latex','fontsize',20);
ylab=ylabel('Fracture energy/area (KJ/m$^2$)','Interpreter','latex','fontsize',20);
legend({'$[H] - 25^{\circ}$','$[H] - 150^{\circ}$','$[H] - 25^{\circ}$ ','$[H]$'},'Interpreter','latex')
set([legend],'fontsize',15,'location', 'SouthOutside','Orientation','vertical','NumColumns',1)
axis([0 max_x 0 max_y])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Save the plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% options
opts.width      = 18;
opts.height     = 22;
opts.fontType   = 'Latex';
% scaling
fig2.Units               = 'centimeters';
fig2.Position(3)         = opts.width;
fig2.Position(4)         = opts.height;
% remove unnecessary white space
% set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
box on
% Export to PDF
set(gca,'units','centimeters')
set(gcf,'PaperUnits','centimeters');
set(gcf,'PaperSize',[opts.width opts.height]);
set(gcf,'PaperPositionMode','manual');
set(gcf,'PaperPosition',[0 0 opts.width opts.height]);
saveas(gcf,[resultsFileName '_Kim2015_H.pdf'])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Plot the data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fig3 = figure;
hold on

scatter(Kim2015_RHF_25_vect,Kim2015_FractureEnergy_25_vect,...
    sz,...
    'o',...
    'MarkerEdgeColor',color6,...
    'MarkerFaceColor',color5,...
    'LineWidth',1.5)
scatter(Kim2015_RHF_150_vect,Kim2015_FractureEnergy_150_vect,...
    sz,...
    '^',...
    'MarkerEdgeColor',color6,...
    'MarkerFaceColor',color5,...
    'LineWidth',1.5)
plot(Kim2015_1_RHF_25_vect_reg_plot,B_Kim2015_FractureEnergy_RHF_25_y,...
    '--',...
    'Color',color6,...
    'LineWidth',2)
plot(Kim2015_1_RHF_vect_reg_plot,B_Kim2015_FractureEnergy_RHF_y,...
    ':',...
    'Color',color6,...
    'LineWidth',2)


scatter(Kim2015_RHCF_25_vect,Kim2015_FractureEnergy_25_vect,...
    sz,...
    'o',...
    'MarkerEdgeColor',color2,...
    'MarkerFaceColor',color3,...
    'LineWidth',1.5)
scatter(Kim2015_RHCF_150_vect,Kim2015_FractureEnergy_150_vect,...
    sz,...
    '^',...
    'MarkerEdgeColor',color2,...
    'MarkerFaceColor',color3,...
    'LineWidth',1.5)
plot(Kim2015_1_RHCF_25_vect_reg_plot,B_Kim2015_FractureEnergy_RHCF_25_y,...
    '--',...
    'Color',color2,...
    'LineWidth',2)
plot(Kim2015_1_RHCF_vect_reg_plot,B_Kim2015_FractureEnergy_RHCF_y,...
    ':',...
    'Color',color2,...
    'LineWidth',2)

scatter(Kim2015_HCC_25_vect,Kim2015_FractureEnergy_25_vect,...
    sz,...
    'o',...
    'MarkerEdgeColor',color1,...
    'MarkerFaceColor',color2,...
    'LineWidth',1.5)
scatter(Kim2015_HCC_150_vect,Kim2015_FractureEnergy_150_vect,...
    sz,...
    '^',...
    'MarkerEdgeColor',color1,...
    'MarkerFaceColor',color2,...
    'LineWidth',1.5)
plot(Kim2015_1_HCC_25_vect_reg_plot,B_Kim2015_FractureEnergy_HCC_25_y,...
    '--',...
    'Color',color1,...
    'LineWidth',2)
plot(Kim2015_1_HCC_vect_reg_plot,B_Kim2015_FractureEnergy_HCC_y,...
    ':',...
    'Color',color1,...
    'LineWidth',2)



max_x = 1;
max_y = 700;
str = ['$R^2$ = ' num2str(R2Kim2015_FractureEnergy_RHF_25,3)];
text(0.237460973479531,226.73076923076,str,'FontSize',15,'Interpreter','latex','rotation',atan(B_Kim2015_FractureEnergy_RHF_25(2)/(max_y/max_x))*180/pi)
str = ['$R^2$ = ' num2str(R2Kim2015_FractureEnergy_RHF,3)];
text(0.307575757575758,276.53846153,str,'FontSize',15,'Interpreter','latex','rotation',atan(B_Kim2015_FractureEnergy_RHF(2)/(max_y/max_x))*180/pi)


str = ['$R^2$ = ' num2str(R2Kim2015_FractureEnergy_RHCF_25,3)];
text(0.60939393939394,277.74,str,'FontSize',15,'Interpreter','latex','rotation',atan(B_Kim2015_FractureEnergy_RHCF_25(2)/(max_y/max_x))*180/pi)
str = ['$R^2$ = ' num2str(R2Kim2015_FractureEnergy_RHCF,3)];
text(0.566010101010101,248.269,str,'FontSize',15,'Interpreter','latex','rotation',atan(B_Kim2015_FractureEnergy_RHCF(2)/(max_y/max_x))*180/pi)
str = ['$R^2$ = ' num2str(R2Kim2015_FractureEnergy_HCC_25,3)];
text(0.581818181818183,388.894,str,'FontSize',15,'Interpreter','latex','rotation',atan(B_Kim2015_FractureEnergy_HCC_25(2)/(max_y/max_x))*180/pi)
str = ['$R^2$ = ' num2str(R2Kim2015_FractureEnergy_HCC,3)];
text(0.637777777777778,433.02,str,'FontSize',15,'Interpreter','latex','rotation',atan(B_Kim2015_FractureEnergy_HCC(2)/(max_y/max_x))*180/pi)

xlab=xlabel('Microstructure metric (RHF, HCC, and RHCF)','Interpreter','latex','fontsize',20);
ylab=ylabel('Fracture energy/area (KJ/m$^2$)','Interpreter','latex','fontsize',20);
legend({'$RHF - 25^{\circ}$','$RHF - 150^{\circ}$','$RHF - 25^{\circ}$ ','$RHF$','$RHCF - 25^{\circ}$','$RHCF - 150^{\circ}$','$RHCF - 25^{\circ}$ ','$RHCF$','$HCC - 25^{\circ}$','$HCC - 150^{\circ}$','$HCC - 25^{\circ}$ ','$HCC$'},'Interpreter','latex')
% set([legend],'fontsize',15,'location', 'NorthEast')
set([legend],'fontsize',15,'location', 'SouthOutside','Orientation','vertical','NumColumns',3)
axis([0 max_x 0 max_y])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Save the plot %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% options
opts.width      = 18;
opts.height     = 22;
opts.fontType   = 'Latex';
% scaling
fig3.Units               = 'centimeters';
fig3.Position(3)         = opts.width;
fig3.Position(4)         = opts.height;
% remove unnecessary white space
% set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))
box on
% Export to PDF
set(gca,'units','centimeters')
set(gcf,'PaperUnits','centimeters');
set(gcf,'PaperSize',[opts.width opts.height]);
set(gcf,'PaperPositionMode','manual');
set(gcf,'PaperPosition',[0 0 opts.width opts.height]);
saveas(gcf,[resultsFileName '_Kim2015_RHF_HCC_RHCF.pdf'])


%%%%%%%%%% Attempt to have [H] and RHCP in the same plot %%%%%%%%%%%%%%%%%%


% % Set up primary x axis for RHCP and RHF and secondary axis for H content
% ax1 = gca;
% ax1_pos = ax1.Position; % position of first axes
% 
% set(fig, 'CurrentAxes', ax1);
% hold(ax1,'on')
% plot(ax1,Kim2015_1_RHF_vect_reg_plot,B_Kim2015_Offset_RHF_y,...
%     ':',...
%     'Color',color2,...
%     'LineWidth',2,...
%     'DisplayName','linear RHF')
% scatter(ax1,Kim2015_1_RHF_vect,Kim2015_1_FractureEnergy_vect,...
%     sz,...
%     'MarkerEdgeColor',color2,...
%     'MarkerFaceColor',color2Fill,...
%     'LineWidth',1.5,...
%     'DisplayName','RHF')
% plot(ax1,Kim2015_1_RHCP_vect_reg_plot,B_Kim2015_Offset_RHCP_y,...
%     ':',...
%     'Color',color1,...
%     'LineWidth',2,...
%     'DisplayName','linear RHCP')
% scatter(ax1,Kim2015_1_RHCP_vect,Kim2015_1_FractureEnergy_vect,...
%     sz,...
%     'MarkerEdgeColor',color1,...
%     'MarkerFaceColor',color1Fill,...
%     'LineWidth',1.5,...
%     'DisplayName','RHCP')
% 
% ax2 = axes('Position',ax1_pos,...
%     'XAxisLocation','top',...
%     'YAxisLocation','right',...
%     'Color','none');
% 
% set(fig, 'CurrentAxes', ax2);
% hold(ax2,'on')
% plot(ax2,Kim2015_1_H_vect_reg_plot,B_Kim2015_Offset_H_y,...
%     ':',...
%     'Color',color3,...
%     'LineWidth',2,...
%     'DisplayName','linear [H]')
% scatter(ax2,Kim2015_1_H_vect,Kim2015_1_FractureEnergy_vect,...
%     sz,...
%     'MarkerEdgeColor',color3,...
%     'MarkerFaceColor',color3Fill,...
%     'LineWidth',1.5,...
%     'DisplayName','[H]')
% 
% set(fig, 'CurrentAxes', ax2);
% xlab2=xlabel('Hydrogen content (wt.ppm)','Interpreter','latex','fontsize',20);
% set(fig, 'CurrentAxes', ax1);
% xlab1=xlabel('Microstructure quantification (RHCP and RHF)','Interpreter','latex','fontsize',20);
% ylab=ylabel('Offset strain (\%)','Interpreter','latex','fontsize',20);
% legend({'$RHCP$','$RHF$','$[H]$','$RHCP$','$RHF$','$[H]$'},'Interpreter','latex')
% % set([legend],'fontsize',18,'location', 'NorthEast')
% % axis([0 CPTotal min(0,max(min(min_eval),-4)) 1.1])


