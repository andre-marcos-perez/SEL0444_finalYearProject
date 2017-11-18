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
%  Block: 1.1 - Well image acquisition
%         1.2 - Segmentation 
%         1.3 - Filtering
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

%--------------------------------------------------------------------------
% Prepare file names
%--------------------------------------------------------------------------

INP_DIR = '..\resources\I_';
INP_EXT = '.jpg';
OUT_DIR = '..\resources\Ibinary_';
OUT_EXT = '.txt';

for i=1:NUM_SAMPLES
     
    %----------------------------------------------------------------------
    % Files
    %----------------------------------------------------------------------
    
    INP_FILENAME = strcat(strcat(INP_DIR,num2str(i)),INP_EXT);
    OUT_FILENAME = strcat(strcat(OUT_DIR,num2str(i)),OUT_EXT);

    warning('off','MATLAB:DELETE:FileNotFound');
    delete(OUT_FILENAME);

    %----------------------------------------------------------------------
    % 1.1 - Well image acquisition: I(x,y) -> Igray(x,y)      
    %----------------------------------------------------------------------
    
    image = imread(INP_FILENAME);
    image = rgb2hsv(image);
    image = image(:,:,2);
       
    %----------------------------------------------------------------------
    % 1.2 - Segmentation: Igray(x,y) -> Ibinary(x,y)
    %----------------------------------------------------------------------

    T = graythresh(image);
    image = imbinarize(image, T);

    %----------------------------------------------------------------------
    % 1.3 - Filtering: Ibinary(x,y) -> Ibinary(x,y)
    %----------------------------------------------------------------------

    SE = strel('disk',6);
    image = imopen(image,SE);
    image = imclose(image,SE);
        
    %----------------------------------------------------------------------
    % Print
    %----------------------------------------------------------------------
    
    dlmwrite(OUT_FILENAME,image);
    
end
