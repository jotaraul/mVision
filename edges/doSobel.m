% Detecta bordes de una imagen utilizando la aproximación discreta del
% operador gradiente Sobel.
%
% [Entradas]
% imGray : Imagen en escala de grises.
% th     : Umbral para considerar a partir de valor en la imagen gradiente
%           se considera borde.
% type   : Si type = 1, se utiliza una máscara de tamaño 3x3. Para
%          cualquier otro valor de type, la máscara usada es de tamaño 5x5.
%
% [Salidas]
% imRes  : Imagen resultado (bordes detectados en imGray).
% imX    : Imagen gradiente a lo largo de las columnas (detección de bordes
%          verticales).
% imY    : Imagen gradiente a lo largo de las filas (detección de bordes
%          horizontales).
% imGrad : Imagen gradiente.
% time   : Tiempo que ha tardado en ejecutarse.

function [imRes, imX, imY, imGrad, time] = doSobel (imGray, th, type)

    tic;
    
    % Creamos las mascaras para derivar
    if ( type == 1 )

        sobel_y = [1 0 -1; 2 0 -2; 1 0 -1]/4; 
        sobel_x = [1 2 1; 0 0 0; -1 -2 -1]/4;

    else
        
        sobel_y = [1 2 0 -2 -1; 2 3 0 -3 -2; 3 5 0 -5 -3; 2 3 0 -3 -2; 1 2 0 -2 -1]/24;
        sobel_x = -sobel_y';

    end
    
    % Obtenemos las imagenes gradientes
    imX = conv2(double(imGray),sobel_x,'same');
    imY = conv2(double(imGray),sobel_y,'same');
    
    % Renombramos el umbral
    umbral = th;
   
    % Comprobamos que pixels de las imagenes gradiente superan el umbral
    % |x| + |x| > umbral    
    imGrad = abs(imX) + abs(imY);
    imRes = ((abs(imX) + abs(imY)) < umbral)*255;
    
    % Convertimos de formato la imagen gradiente
	imGrad = uint8(imGrad);
    
    time = toc;
   
  
