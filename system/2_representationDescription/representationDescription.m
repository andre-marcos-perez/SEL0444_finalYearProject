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
%  Step:  2.  - REPRESENTATION AND DESCRIPTION
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
counter = 1;

%--------------------------------------------------------------------------
% Prepare file names
%--------------------------------------------------------------------------

INP_DIR = '..\resources\plaqueData\Iplaque_';
INP_EXT = '.txt';
OUT_DIR = '..\resources\dataset';
OUT_EXT = '.txt';

%--------------------------------------------------------------------------
% Prepare output directory
%--------------------------------------------------------------------------

OUT_FILENAME = strcat(OUT_DIR,OUT_EXT);

warning('off','MATLAB:DELETE:FileNotFound');
delete(OUT_FILENAME);

for i=1:NUM_PLAQUES
     
    %----------------------------------------------------------------------
    % Files
    %----------------------------------------------------------------------
    
    INP_FILENAME = strcat(strcat(INP_DIR,num2str(i)),INP_EXT);
    
    try
	
        plaqueImage = dlmread(INP_FILENAME);
        plaqueBoundaries = bwboundaries(plaqueImage,4);
        plaqueBoundary = plaqueBoundaries{2};
        plaqueData = regionprops(plaqueImage,'centroid','area',...
                                             'eccentricity');
        isCentroidInside = inpolygon(plaqueData.Centroid(1),...
                                     plaqueData.Centroid(2),...
                                     plaqueBoundary(:,2),...
                                     plaqueBoundary(:,1));

        if isCentroidInside
            
            try

                FILE = fopen(OUT_FILENAME, 'at+');
                fprintf(FILE, '%d',counter);
                fprintf(FILE, ',');
                fprintf(FILE, '%d',plaqueData.Area);
                fprintf(FILE, ',');
                fprintf(FILE, '%d',plaqueData.Eccentricity);
                fprintf(FILE, '\n');
                fclose(FILE);
                counter = counter + 1;

            catch error

                disp(error.message)

            end
        end
        
    catch error
	
        disp(error.message)
		
    end
end
