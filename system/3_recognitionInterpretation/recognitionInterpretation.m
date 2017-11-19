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
%  Step:  3.  - Recognition and Interpretation
%**************************************************************************

%--------------------------------------------------------------------------
% Prepare environment
%--------------------------------------------------------------------------

close all
clear all
clc

%--------------------------------------------------------------------------
% Get theta
%--------------------------------------------------------------------------

INP_DIR = '..\resources\theta';
INP_EXT = '.txt';

INP_FILENAME = strcat(INP_DIR,INP_EXT);

theta = dlmread(INP_FILENAME);

%--------------------------------------------------------------------------
% Get dataset
%--------------------------------------------------------------------------

INP_DIR = '..\resources\dataset';
INP_EXT = '.txt';

INP_FILENAME = strcat(INP_DIR,INP_EXT);

dataset = dlmread(INP_FILENAME);
DAT_SIZE = size(dataset);
dataset = [dataset zeros(DAT_SIZE(1),1)];

for i=1:DAT_SIZE(1)
       
    if dataset(i,4) == 0
        
        dataset(i,:) = 0;
        
    end
    
end

dataset(:,2) = dataset(:,2)/max(dataset(:,2));

%--------------------------------------------------------------------------
% Count plaques
%--------------------------------------------------------------------------

X = dataset(:, [3, 2]);
[m, n] = size(X);
X = [ones(m, 1) X];

p = sigmoid(X*theta');
p = (p >= 0.4);

plaqueCounting = size(find(p==1));

disp('Number of plaques:')
disp(plaqueCounting(1));