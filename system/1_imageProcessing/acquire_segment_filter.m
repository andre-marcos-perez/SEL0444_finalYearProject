%--------------------------------------------------------------------------
% Project:      Automation of Zika Virus plaque counting from the plaque 
%               assay experiment using computer vision
%--------------------------------------------------------------------------
% Step:         1.  - IMAGE PROCESSING
% Block:        1.1 - Well image acquisition
%               1.2 - Segmentation 
%               1.3 - Filtering
%--------------------------------------------------------------------------
% Author:       Andre Marcos Perez
% Contact:      andre.marcos.perez@usp.br
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Prepare environment
%--------------------------------------------------------------------------

close all
clear all
clc

%--------------------------------------------------------------------------
% Prepare file names
%--------------------------------------------------------------------------

INP_DIR = '..\resources\I_';
INP_EXT = '.jpg';
OUT_DIR = '..\resources\Ibinary_';
OUT_EXT = '.txt';

for i=1:2
     
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
    image = im2bw(image, T);

    %----------------------------------------------------------------------
    % 1.3 - Filtering: Ibinary(x,y) -> Ibinary(x,y)
    %----------------------------------------------------------------------

    SE = strel('disk',6);
    image = imopen(image,SE);
    image = imclose(image,SE);
    
    %----------------------------------------------------------------------
    % Print
    %----------------------------------------------------------------------
    
    figure, imshow(image,'InitialMagnification','fit'); 
    dlmwrite(OUT_FILENAME,image);
    
end
