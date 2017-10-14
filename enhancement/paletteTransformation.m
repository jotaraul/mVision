
% Transforma la paleta de niveles de gris de una imagen. Para ello, el
% nivel de gris 0 (negro) se desplazar hasta el parámetro de entrada min, y
% el nivel de gris 255 (blanco) se desplaza hasta max. Si max < min se
% invierten los tonos de gris.
%
% [Entradas]
% imGray : Imagen en escala de grises.
% min    : Nuevo nivel de gris mínimo (0) para la imagen resultado.
% max    : Nuevo nivel de gris máximo (255) para la imagen resultado.
%
% [Salidas]
% imRes  : Imagen resultado.
% time   : Tiempo que ha tardado en ejecutarse.
% tabla  : Tabla de consulta creada para la transformación de la paleta.

function [imRes, time, tabla] =  paletteTransformation(imGray, min, max)

    tic;    

    % Creamos la tabla de consulta
    tabla = ones(256,1);
    if (min <= max)
        tabla(1:min+1) = 0;
        tabla(max+1:256) = 255;
        
        if ( max - min > 1)        
            for i=min+2:1:max
                tabla(i) = (i-(min+1))*(255/(max-min));
            end
        end
    else
        tabla(1:max+1) = 255;
        tabla(min+1:256) = 0;
        
        if ( min - max > 1)
            for i=max+2:1:min
                tabla(i) = ((min-max+2)-(i-max))*(255/(min-max));
            end
        end
    end

    % Aplicamos la tabla a la imagen
    imRes = tabla(imGray+1);
    

    % Convertirmos la imagen obtenida
    imRes = uint8(imRes);  
    
    time = toc;
    