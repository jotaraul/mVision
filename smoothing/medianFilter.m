
% Realiza un suavizado basado en el filtro de la mediana
%
% [Entradas]
% imGray : Imagen en escala de grises.
% hsize  : Número de elementos sobre los que se calculará la mediana. Si
%          hsize = 1, se tendrán en cuenta los 8 vecinos directos.
%
% [Salidas]
% imRes : Imagen resultado (imGray suavizada).
% time  : Tiempo que ha tardado en ejecutarse.

function [imRes, time] = medianFilter(imGray, hsize)

    tic;
    
    % Obtenemos el tamaño de la imagen
    [fil, col] = size(imGray);
    imRes = zeros(fil,col);
    
    see = floor(hsize/2);
    
    for i=1:1:fil % Recorro todas las filas
        for j=1:1:col % Recorro todas las columnas
            v = []; % Vector con los valores de los vecinos y el propio
            for k=-see:1:see % Recorroro los vecinos fila
                for r=-see:1:see % Recorro los vecinos columna
                    % Compruebo si la coordenada es valida
                    if (((i+k >= 1)&&(i+k <= fil))&&((j+r>=1)&&(j+r<=col)))
                        v = [ v ; imGray(i+k,j+r) ];
                    end
                end
            end
            % Ordeno el vector con los valores de los vecinos y propio
            ordenado = sort(v);
            [vSize, basura] = size(v);
            % Me quedo con la mediana del vector ordenado
            imRes(i,j) = ordenado( floor(vSize/2) );
        end
    end
    
    imRes = uint8(imRes);
    
    time = toc;
    