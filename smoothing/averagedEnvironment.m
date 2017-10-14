
% Realiza un suavizado basado en el promediado del entorno.
%
% [Entradas]
% imGray : Imagen en escala de grises.
% hsize  : Tamaño de la máscara con la que realizar el suavizado. Por
%          ejemplo, si se elige un hsize de 3, la máscara será:
%                  mask = [1 1 1; 1 1 1; 1 1 1]/9;
%
% [Salidas]
% imRes : Imagen resultado (imGray suavizada).
% time  : Tiempo que ha tardado en ejecutarse.

function [imRes, time] = averagedEnvironment(imGray, hsize)

    tic;
    
    % Creamos la mascara
    h = ones(hsize, hsize) * (1 / (hsize*hsize) );
    
    % Realizamos la convolucion
    imGrayRes = conv2(double(imGray), h,'same');
    
    % Transformamos el formato de la imGrayagen
    imRes = uint8(imGrayRes);
    
    time = toc;
    