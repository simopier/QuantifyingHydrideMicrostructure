% solve maximum for RHCP(45) as a function of the angle theta
close all
clear

% parameters
fracParamZr = 50;
fracParamZrH = 1;

% solve equation
syms theta
S1 = vpasolve( -fracParamZr*(2/cos(theta)*((pi/4-theta)^2*(pi/4+theta)+(pi/4-theta)*(pi/4+theta)^2)+sin(theta)/cos(theta)^2*(1+(pi/4-theta)^2*(pi/4+theta)^2)) + fracParamZrH/cos(theta)^2 == 0, theta)
S1_degrees = S1*180/3.14159265

S2 = vpasolve( -2*fracParamZr*((pi/4-theta)^2*(pi/4+theta)+(pi/4-theta)*(pi/4+theta)^2) + fracParamZrH/cos(theta)^2 == 0, theta)
S2_degrees = S2*180/3.14159265

% Plot RHCP as a function of the angle theta
L = 100;
l = 10;
W=50;

theta_vect = [0:0.0001:pi/2];
RHCPbasic_vect = zeros(1,length(theta_vect));
for i=1:length(theta_vect)
    RHCPbasic_vect(i) = ((L-L/cos(theta_vect(i)))*fracParamZr-0*fracParamZrH)/(L*(fracParamZr-fracParamZrH));
end
RHCPequal_vect = zeros(1,length(theta_vect));
for i=1:length(theta_vect)
    RHCPequal_vect(i) = ((L-cos(theta_vect(i))*L/cos(theta_vect(i)))*fracParamZr-0*fracParamZrH)/(L*(fracParamZr-fracParamZrH));
end
RHCPWg_vect = zeros(1,length(theta_vect));
for i=1:length(theta_vect)
    RHCPWg_vect(i) = ((L-L/cos(theta_vect(i))*(1+W*(pi/4+theta_vect(i))^2*(pi/4-theta_vect(i))^2))*fracParamZr-0*fracParamZrH)/(L*(fracParamZr-fracParamZrH));
end
RHCPequalWg_vect = zeros(1,length(theta_vect));
for i=1:length(theta_vect)
    RHCPequalWg_vect(i) = ((L-cos(theta_vect(i))*L/cos(theta_vect(i))*(1+W*(pi/4+theta_vect(i))^2*(pi/4-theta_vect(i))^2))*fracParamZr-0*fracParamZrH)/(L*(fracParamZr-fracParamZrH));
end
RHCPequalWg_vect_final = zeros(1,length(theta_vect));
for i=1:length(theta_vect)
    RHCPequalWg_vect_final(i) = ((L/cos(pi/4)-L/cos(theta_vect(i))*(1+W*(pi/4+theta_vect(i))^2*(pi/4-theta_vect(i))^2))*fracParamZr-0*fracParamZrH)/(L*(fracParamZr/cos(pi/4)-fracParamZrH));
end
RHCPWgl_vect = zeros(1,length(theta_vect));
for i=1:length(theta_vect)
    RHCPWgl_vect(i) = ((L/cos(pi/4)-L/cos(theta_vect(i))*(1+W*(cos(theta_vect(i))/cos(pi/4)-1)^2))*fracParamZr-0*fracParamZrH)/(L*(fracParamZr/cos(pi/4)-fracParamZrH));
end

hydride_RHCPbasic_vect = zeros(1,length(theta_vect));
for i=1:length(theta_vect)
    hydride_RHCPbasic_vect(i) = ((L-l/sin(theta_vect(i)))*fracParamZr-(L-l/tan(theta_vect(i)))*fracParamZrH)/(L*(fracParamZr-fracParamZrH));
end
hydride_RHCPequal_vect = zeros(1,length(theta_vect));
for i=1:length(theta_vect)
    hydride_RHCPequal_vect(i) = ((L-l/sin(theta_vect(i))*cos(theta_vect(i)))*fracParamZr-(L-l/tan(theta_vect(i)))*fracParamZrH)/(L*(fracParamZr-fracParamZrH));
end
hydride_RHCPWg_vect = zeros(1,length(theta_vect));
for i=1:length(theta_vect)
    hydride_RHCPWg_vect(i) = ((L-l/sin(theta_vect(i))*(1+W*(pi/4+theta_vect(i))^2*(pi/4-theta_vect(i))^2))*fracParamZr-(L-l/tan(theta_vect(i)))*fracParamZrH)/(L*(fracParamZr-fracParamZrH));
end
hydride_RHCPequalWg_vect = zeros(1,length(theta_vect));
for i=1:length(theta_vect)
    hydride_RHCPequalWg_vect(i) = ((L-l/sin(theta_vect(i))*cos(theta_vect(i))*(1+W*(pi/4+theta_vect(i))^2*(pi/4-theta_vect(i))^2))*fracParamZr-(L-l/tan(theta_vect(i)))*fracParamZrH)/(L*(fracParamZr-fracParamZrH));
end
hydride_RHCPequalWg_vect_final = zeros(1,length(theta_vect));
for i=1:length(theta_vect)
    hydride_RHCPequalWg_vect_final(i) = ((L/cos(pi/4)-l/sin(theta_vect(i))*(1+W*(pi/4+theta_vect(i))^2*(pi/4-theta_vect(i))^2))*fracParamZr-(L-l/tan(theta_vect(i)))*fracParamZrH)/(L*(fracParamZr/cos(pi/4)-fracParamZrH));
end
hydride_RHCPWgl_vect = zeros(1,length(theta_vect));
for i=1:length(theta_vect)
    hydride_RHCPWgl_vect(i) = ((L/cos(pi/4)-l/sin(theta_vect(i))*(1+W*(cos(theta_vect(i))/cos(pi/4)-1)^2))*fracParamZr-(L-l/tan(theta_vect(i)))*fracParamZrH)/(L*(fracParamZr/cos(pi/4)-fracParamZrH));
end

figure
hold on
plot(theta_vect,cos(theta_vect))
axis([0 pi/2 0 1])

figure
hold on
plot(theta_vect,1./cos(theta_vect))
axis([0 pi/2 0 100])

figure
hold on
plot(theta_vect,RHCPbasic_vect)
plot(theta_vect,RHCPequal_vect)
plot(theta_vect,RHCPWg_vect)
plot(theta_vect,RHCPequalWg_vect)
plot(theta_vect,RHCPequalWg_vect_final)
legend('RHCP basic','RHCP equal','RHCP g','RHCP equal Wg','RHCP Wg final')
axis([0 pi/2 -2 0.2])

figure
hold on
plot(theta_vect,hydride_RHCPbasic_vect)
plot(theta_vect,hydride_RHCPequal_vect)
plot(theta_vect,hydride_RHCPWg_vect)
plot(theta_vect,hydride_RHCPequalWg_vect)
plot(theta_vect,hydride_RHCPequalWg_vect_final)
legend('hydride RHCP basic','hydride RHCP equal','hydride RHCP g','hydride RHCP equal Wg','hydride RHCP Wg inal')
axis([0 pi/2 0 1])


%% Check theta_max-theta0 and RHCP_no_hydride_max as a function of theta_0 and W
theta_0_num = 20;
theta_0 = [0:pi/2/theta_0_num:pi/2-pi/theta_0_num];
W_vect = [1:5:100];
theta_max = zeros(length(theta_0),length(W_vect));
Delta_theta = zeros(length(theta_0),length(W_vect));
RHCP_max = zeros(length(theta_0),length(W_vect));

for i=1:length(theta_0)
    for j=1:length(W_vect)
        S_max = vpasolve( 4*W_vect(j)*theta*(theta^2-theta_0(i)^2)*cos(theta)+(1+W_vect(j)*(theta_0(i)-theta)^2*(theta_0(i)+theta)^2)*sin(theta) == 0, theta, [0.0000000001 pi/2]);
        if size(S_max,1) == 0
            theta_max(i,j) = nan;
            Delta_theta(i,j) = nan;
            RHCP_max(i,j) = nan;
        else
            theta_max(i,j) = double(S_max);
            Delta_theta(i,j) = theta_0(i)-theta_max(i,j);
            RHCP_max(i,j) = ((L/cos(theta_0(i))-L/cos(theta_max(i,j))*(1+W_vect(j)*(theta_0(i)+theta_max(i,j))^2*(theta_0(i)-theta_max(i,j))^2))*fracParamZr-0*fracParamZrH)/(L*(fracParamZr/cos(theta_0(i))-fracParamZrH));
        end
    end
end

figure
surf(W_vect,theta_0,Delta_theta,'FaceColor','interp','EdgeColor','interp')
xlabel('W')
ylabel('\theta_0')
zlabel('\Delta theta')

figure
surf(W_vect,theta_0,RHCP_max,'FaceColor','interp','EdgeColor','interp')
xlabel('W')
ylabel('\theta_0')
zlabel('RHCP_{max}')



