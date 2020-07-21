function[hydride_segments_lengths] = HydrideSegments(binaryImage)
%-------------------------------------------------------------------------%
%                                                                         %
%       Script developed by Pierre-Clement A Simon and Cailon Frank       %
%       From Penn State University                                        %
%                                                                         %
%       Definition originally proposed in                                 %
%           Bell L, Duncan R. 1975. Hydride orientation in Zr-2.5%Nb;     %
%           How it is affected by stress, temperature and heat treatment. %
%           Report AECL-5110                                              %
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
% This function is called by RHCF_file and measure the length of the
% projected hydrides. It also filters out hydrides that are too small to be
% taken into account.

% Inputs:
% - binaryImage: The matrix representing the binary image.

% Outputs:
% - hydride_segments_lengths: vector of the lengths of the projected
% hydrides

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[row,col] = find(binaryImage>0);%find what rows have at least 1 hydride occupying 1 pixels in them
FilledRows = unique(row);% count every row only once
hydride_segments_lengths=zeros(1,length(FilledRows));%create hydride segment vector with max length of filled rows
n=1;


if(isempty(FilledRows)==1)
    hydride_segments_lengths = 0;
else
    if (FilledRows(1)~= 0)%One if statement to to check if first row has filled space and if so start with value of 1
        hydride_segments_lengths(1)=1;
    end
    for x=2:length(FilledRows)%for loop which find continuous lengths of hydrides by checking if every following row is only 1 row down from the last
        %filled row. If it is not then a new segment is created in the next
        %slot in the hydride segments vector.
        if(FilledRows(x) == FilledRows(x-1)+1)
            hydride_segments_lengths(n)=hydride_segments_lengths(n)+1;
        else
            n=n+1;
            hydride_segments_lengths(n)=1;
        end
        
        
    end
    % shorten Hydride segments vector by truncating zeroes
    hydride_segments_lengths=nonzeros(hydride_segments_lengths);
end
end