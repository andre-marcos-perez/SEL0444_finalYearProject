%**************************************************************************
% @INSTITUTION
%  University of Sao Paulo | Sao Carlos School of Engineering | SEL
%--------------------------------------------------------------------------
% @DISCIPLINE
%  Name: SEL0444 | Final Year Project
%  Professor: Marcelo Andrade da Costa Vieira
%  Semester: 2017\02
%--------------------------------------------------------------------------
% @DEVELOPMENT
%  IDE: MATLAB R2017a
%--------------------------------------------------------------------------
% @WARRANTY
%  Copyright (c) 2017 Andre Marcos Perez
%  The software is provided by "as is", without warranty of any kind, 
%  express or implied, including but not limited to the warranties of 
%  merchantability, fitness for a particular purpose and noninfringement. 
%  In no event shall the authors or copyright holders be liable for any 
%  claim, damages or other liability, whether in an action of contract, 
%  tort or otherwise, arising from, out of or in connection with the 
%  software or the use or other dealings in the software.
%--------------------------------------------------------------------------
% @AUTHOR
%  Name:  Andre Marcos Perez
%  Email: andre.marcos.perez@usp.br
%  #USP:  8006891
%--------------------------------------------------------------------------
% @DESCRIPTION
%  Title: Automation of Zika Virus plaque counting from the plaque 
%         assay experiment using computer vision
%  Step:  1.  - IMAGE PROCESSING
%  Block: 1.5 - Separe Overlapping Plaques
%**************************************************************************

%--------------------------------------------------------------------------
% Prepare environment
%--------------------------------------------------------------------------

close all
clear all
clc

%--------------------------------------------------------------------------
% Constants & variables
%--------------------------------------------------------------------------

NUM_PLAQUES = length(dir('..\resources\plaqueData\')) - 2;
counter = NUM_PLAQUES + 1;

%--------------------------------------------------------------------------
% Prepare file names
%--------------------------------------------------------------------------

INP_DIR = '..\resources\plaqueData\Iplaque_';
INP_EXT = '.txt';
OUT_DIR = '..\resources\plaqueData\Iplaque_';
OUT_EXT = '.txt';

%----------------------------------------------------------------------
% 1.5 - Separe Overlapping Plaques: Iplaque(x,y) -> Iplaque(x,y)
%----------------------------------------------------------------------

for i=1:NUM_PLAQUES(1)

    INP_FILENAME = strcat(strcat(INP_DIR,num2str(i)),INP_EXT);
    
    try
    
        plaqueImage = dlmread(INP_FILENAME);
        plaqueData = regionprops(plaqueImage,'Area','Centroid');

        if(plaqueData.Area > 3000)

            %Boundary
            
            plaqueBoundaries = bwboundaries(plaqueImage,4);
            plaqueBoundary = plaqueBoundaries{2};
            sizeBoundary = size(plaqueBoundary);
            sizeBoundary = sizeBoundary(1);
            
            %Signature
            
            signature = zeros(1,sizeBoundary);
            step = 2*pi/sizeBoundary;

            for k=1:sizeBoundary

                x = plaqueData.Centroid(1) - plaqueBoundary(k,2);
                y = plaqueData.Centroid(2) - plaqueBoundary(k,1);
                signature(k) = sqrt(x^2 + y^2);

            end
            
            [maxValue,indexMax] = max(signature);
            
            %Valley
            
            ssign = smooth(signature,5*step);
            dssign = diff(ssign);

            zcr = zeros(1,sizeBoundary-2);
            for k=1:(sizeBoundary-2)

                zcr(k) = sign(dssign(k))-sign(dssign(k+1));

            end

            zc = find(zcr>0);
            sizeZc = size(zc);
            sizeZc = sizeZc(2);

            head = 1;
            tail = zc(1);
            
            for k=2:1:sizeZc+2

                [minVal(k-1),minIndex(k-1)] = min(signature(head:tail));
                minIndex(k-1) = minIndex(k-1) + head;

                head = tail;

                if(k <= sizeZc)

                    tail = zc(k);

                else

                    tail = sizeBoundary;

                end
                
            end
            
            %Bresenham
            
            [value, index] = min(minVal);
            startPixel = minIndex(index);
            minVal(index) = NaN;
            [value, index] = min(minVal);
            endPixel = minIndex(index);           
            
            plaqueImage = drawLine(plaqueImage,...
                          [(plaqueBoundary(endPixel,1))... 
                           (plaqueBoundary(endPixel,2))],...
                          [(plaqueBoundary(startPixel,1))...
                           (plaqueBoundary(startPixel,2))]);        
            
            %----------------------------------------------------------------------
            % 1.4 - Plaque image acquisition: Ibinary(x,y) -> Iplaque(x,y)
            %----------------------------------------------------------------------

            delete(INP_FILENAME);

            plaqueBoundaries = bwboundaries(plaqueImage,4);
            NUM_PLAQUES_SEP = size(plaqueBoundaries);

            for j=2:NUM_PLAQUES_SEP(1)

                OUT_FILENAME = strcat(strcat(OUT_DIR,num2str(counter)),OUT_EXT);
                
                plaqueBoundary = plaqueBoundaries{j};
                xMax = max(plaqueBoundary(:,2));
                xMin = min(plaqueBoundary(:,2));
                yMax = max(plaqueBoundary(:,1));
                yMin = min(plaqueBoundary(:,1));
                image = plaqueImage(yMin-1:yMax+1,xMin-1:xMax+1);
                plaqueBoundary(:,2) = plaqueBoundary(:,2) - (xMin-2);
                plaqueBoundary(:,1) = plaqueBoundary(:,1) - (yMin-2);

                for k=1:(yMax-yMin)+3

                    for l=1:(xMax-xMin)+3

                        if(~inpolygon(l,k,plaqueBoundary(:,2),plaqueBoundary(:,1)))

                            image(k,l) = 1;

                        end
                    end
                end

                dlmwrite(OUT_FILENAME,image);
                counter = counter + 1;

            end
                        
        end
    
    catch error
        
        disp(error.message);
        
    end
end