function [table] = AutoSort(table)
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
% This function sorts a table based on its first column and return the
% sorted table.


% Inputs:
% - table: unsorted table

% Outputs:
% Sorted table


%%%%%%%%%%%%%%%%% Sort the table on its first column %%%%%%%%%%%%%%%%%%%%%%

for i=1: size(table,1)-1
    if(table(i,1)>table(i+1,1))
        a=table(i,1);
        b=table(i+1,1);
        c=table(i,2);
        d=table(i+1,2);
        table(i+1,1)=a;
        table(i,1)=b;
        table(i+1,2)=c;
        table(i,2)=d;
        
    end
end
for i=1: size(table,1)-1
    if(table(i,1)>table(i+1,1))
        a=table(i,1);
        b=table(i+1,1);
        c=table(i,2);
        d=table(i+1,2);
        table(i+1,1)=a;
        table(i,1)=b;
        table(i+1,2)=c;
        table(i,2)=d;
        
    end
end
end

