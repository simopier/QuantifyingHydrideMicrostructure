function [ RHF ] = RHFCalculations( length_proj_c,length_proj_r )
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
% This function is called by RHF_file and derives the RHF value of a
% hydride given its vertical and horizontal projected lengths.


% Inputs:
% - length_proj_c: The length of the hydride along the horizontal (circumferential) direction
% - length_proj_r: The length of the hydride along the vertical (radial) direction

% Outputs:
% RHF value for this hydride.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Derive RHF %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% The RHF of a microstructure needs to be a linear function of the angle of
% the hydride ranging from 0 when al hydrides are circumferential, to 1
% when all hydrides are radial. 
RHF=2/pi*atan2(length_proj_r,length_proj_c);

% Only the real part of the value is kept (sometimes the returned value is 
% a complex number)
RHF=real(RHF);

end

