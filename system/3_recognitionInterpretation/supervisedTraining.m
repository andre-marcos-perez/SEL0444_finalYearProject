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
%  Block  3.1 - Supervised Training
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

truePlaques = [2 3 5 6 7 9 11 14 24 62 63 64 65 66 68 69 70 71 27 28 29 ...
               31 32 34 37 39 47 50 53 55 56 57 72 73 74 75];

%--------------------------------------------------------------------------
% Prepare file names
%--------------------------------------------------------------------------

INP_DIR = '..\resources\dataset';
INP_EXT = '.txt';
OUT_DIR = '..\resources\theta';
OUT_EXT = '.txt';

%--------------------------------------------------------------------------
% Prepare files
%--------------------------------------------------------------------------

INP_FILENAME = strcat(INP_DIR,INP_EXT);
OUT_FILENAME = strcat(OUT_DIR,OUT_EXT);

warning('off','MATLAB:DELETE:FileNotFound');
delete(OUT_FILENAME);

%--------------------------------------------------------------------------
% Prepare dataset
%--------------------------------------------------------------------------

dataset = dlmread(INP_FILENAME);
DAT_SIZE = size(dataset);
dataset = [dataset zeros(DAT_SIZE(1),1)];

for i=1:DAT_SIZE(1)
    
    if ismember(dataset(i,1),truePlaques)
       
        dataset(i,5) = 1;
        
    end
    
    if dataset(i,4) == 0
        
        dataset(i,:) = 0;
        
    end
    
end

dataset(:,2) = dataset(:,2)/max(dataset(:,2));

%--------------------------------------------------------------------------
% Compute cost function and theta parameters
%--------------------------------------------------------------------------

X = dataset(:, [3, 2]); 
y = dataset(:, 5);

[m, n] = size(X);
X = [ones(m, 1) X];
initial_theta = zeros(n + 1, 1);

options = optimset('GradObj', 'on', 'MaxIter', 400);
[theta, cost] = fminunc(@(t)(costFunction(t, X, y)), initial_theta, options);

%--------------------------------------------------------------------------
% Outputs theta parameters
%--------------------------------------------------------------------------

try

    FILE = fopen(OUT_FILENAME, 'at+');
    fprintf(FILE, '%d',theta(1));
    fprintf(FILE, ',');
    fprintf(FILE, '%d',theta(2));
    fprintf(FILE, ',');
    fprintf(FILE, '%d',theta(3));
    fprintf(FILE, '\n');
    fclose(FILE);

catch error

    disp(error.message)

end
