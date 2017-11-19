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
%  Func:  drawLine
%  Desc:  Uses the bresenham algorithm to draw a white line between two
%         points
%**************************************************************************

function im = drawLine(f,startPixel,endPixel)

    xStart = startPixel(1);
    yStart = startPixel(2);
    xEnd = endPixel(1);
    yEnd = endPixel(2);
    
    deltaX = abs(xEnd - xStart);
    deltaY = abs(yEnd - yStart);
    
    sx = sign(xEnd - xStart);
    sy = sign(yEnd - yStart);
       
    interchange = 0;

    if deltaY > deltaX

        temp = deltaX;
        deltaX = deltaY;
        deltaY = temp;
        
        interchange = 1;
        
    end

    e = 2*deltaY - deltaX;
    a = 2*deltaY;
    b = 2*(deltaY - deltaX);
    
    x = xStart;
    y = yStart;
    
    for i=1:deltaX
       
        if e < 0
            
            if interchange == 1
                
                y = y + sy;
                
            else
                
                x = x + sx;
                
            end
            
            e = e + a;
            
        else
            
            y = y + sy;
            x = x + sx;
            e = e + b;
            
        end
        
        f(x,y) = 1;
        
        f(x,y+1) = 1;
        f(x,y-1) = 1;
        f(x+1,y) = 1;
        f(x-1,y) = 1;
        
        f(x+1,y+1) = 1;
        f(x-1,y+1) = 1;
        f(x+1,y-1) = 1;
        f(x-1,y-1) = 1;

    end
       
    im = f;
    
end