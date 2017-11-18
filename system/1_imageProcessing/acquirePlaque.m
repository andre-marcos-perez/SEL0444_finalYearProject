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
%  Block: 1.4 - Plaque image acquisition
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

NUM_SAMPLES = 2;
counter = 1;

%--------------------------------------------------------------------------
% Prepare file names
%--------------------------------------------------------------------------

INP_DIR = '..\resources\Ibinary_';
INP_EXT = '.txt';
OUT_DIR = '..\resources\plaqueData\Iplaque_';
OUT_EXT = '.txt';

%--------------------------------------------------------------------------
% Prepare output directory
%--------------------------------------------------------------------------

NUM_PLAQUES = length(dir('..\resources\plaqueData\'));

if  NUM_PLAQUES > 2
    
    for i=1:NUM_PLAQUES
       
        OUT_FILENAME = strcat(strcat(OUT_DIR,num2str(i)),OUT_EXT);
        delete(OUT_FILENAME);
        
    end
end


for i=1:NUM_SAMPLES
     
    %----------------------------------------------------------------------
    % Files
    %----------------------------------------------------------------------
    
    INP_FILENAME = strcat(strcat(INP_DIR,num2str(i)),INP_EXT);
    
    image = dlmread(INP_FILENAME);
    
    %----------------------------------------------------------------------
    % 1.4 - Plaque image acquisition: Ibinary(x,y) -> Iplaque(x,y)
    %----------------------------------------------------------------------
    
    plaqueBoundaries = bwboundaries(image,4);
    NUM_PLAQUES = size(plaqueBoundaries);
    
    % starts at j=2 because j=1 is the well boundary
    for j=2:NUM_PLAQUES(1)
        
        OUT_FILENAME = strcat(strcat(OUT_DIR,num2str(counter)),OUT_EXT);       
        
        plaqueBoundary = plaqueBoundaries{j};
        xMax = max(plaqueBoundary(:,2));
        xMin = min(plaqueBoundary(:,2));
        yMax = max(plaqueBoundary(:,1));
        yMin = min(plaqueBoundary(:,1));
        plaqueImage = image(yMin-1:yMax+1,xMin-1:xMax+1);
        plaqueBoundary(:,2) = plaqueBoundary(:,2) - (xMin-2);
        plaqueBoundary(:,1) = plaqueBoundary(:,1) - (yMin-2);
        
        for k=1:(yMax-yMin)+3
            
            for l=1:(xMax-xMin)+3
                
                if(~inpolygon(l,k,plaqueBoundary(:,2),plaqueBoundary(:,1)))
                
                    plaqueImage(k,l) = 1;
                
                end
            end
        end
        
        dlmwrite(OUT_FILENAME,plaqueImage);
        counter = counter + 1;
        
    end
end