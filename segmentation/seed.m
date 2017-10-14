
% Siembra una semilla en la posición xPos,yPos y la expande.
%
% [Entradas]
% imGray : Imagen en escala de grises.
% xPos   : Posición x (columna) donde plantar la semilla.
% yPos   : Posición y (fila) donde plantar la semilla.
% variation : Variación del tono de gris para considerar que un vecino
%          cumple la propiedad "semejante tono de gris".
%
% [Salidas]
% imRes  : Imagen resultado.
% time   : Tiempo que ha tardado en ejecutarse.


function [imRes, time] = seed(imGray, xPos, yPos, variation)

    tic;
    
    % Creamos la imagen resultado
    [fil,col] = size(imGray);
    imRes = ones(fil,col)*255;
    % Inserto la semilla
    imRes(yPos,xPos) = 0;
    
    % Creo la matriz que controla si tengo que expandir una cierta casilla
    imExp = zeros(fil,col);
    imExp(yPos,xPos) = 1;
    
    % Número inicial de pixels que pertenecen a la region
    plantasOld = 0;
    plantasNew = 1;
    
    while plantasOld < plantasNew
        
        plantasOld = plantasNew;
        
        for y=1:fil
            for x=1:col
                % Compruebo si tengo que expandir ese pixel
                if imExp(y,x) == 1
                    imExp(y,x) = 2; % La marco como ya expandida
                    % Recorro los vecinos para comprobar si cumplen con la
                    % variacion
                    for i=-1:1
                        for j=-1:1
                            % Comprobamos que no nos salimos por los
                            % extremos
                            if y+i>0 && y+i<=fil && x+j>0 && x+j<=col
                                % Comprobamos que no se trata de la propia
                                % semilla y que no ha sido ya expandida
                                if ~((i==0 && j==0) || ~(imExp(y+i,x+j)==0))
                                    if abs(double(imGray(y,x))-double(imGray(y+i,x+j))) <= variation
                                        
                                        imRes(y+i,x+j) = 0;
                                        imExp(y+i,x+j) = 1;
                                        plantasNew = plantasNew + 1;
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end                 
    
    time = toc;
