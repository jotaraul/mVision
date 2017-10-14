% Detecta rectas en una imagen.
%
% [Entradas]
% imBor   : Imagen en escala de grises con los bordes de una imagen.
% imX     : Imagen gradiente a lo largo de las columnas (bordes verticales).
% imY     : Imagen gradiente a lo largo de las filas (bordes horizontales).
% tauMax  : Máxima tau a detectar.
% titaMin : Mínima tita a detectar.
% titaMax : Máxima tita a detectar.
% th      : Umbral para considerar que número de votos son necesarios en el
%           acumulador para que sea una recta.
% precision : (Futuro uso).
% see     : Grados a evaluar alrededor de la dirección del gradiente
%           (mejora). Si el ángulo del vector gradiente fuera=90, y el
%           valor de see=2, se calcularían las taus correspondientes a los
%           valores de tita desde 88 a 92.
% seeLocalMax : Distancia a la que mirar si la posición actual de la matriz
%           de votos es un máximo local.
%
% [Salidas]
% imRes    : Imagen resultado (intersección entre imGray y imRectas).
% imVotos  : Imagen con los votos acumulados en el plano (tita, tau).
% imRectas : Imagen con las rectas detectadas.
% time     : Tiempo que ha tardado en ejecutarse.

function [imRes, imVotos, imRectas, time] = houghRect (imBor,imX,imY,tauMax,...
                                            titaMin,titaMax,th,precision,see,seeLocalMax)

    tic;
    
    % Obtengo las dimensiones de la imagen con bordes
    [fil,col] = size(imBor);
    
    % Creamos la matriz de votos
    filA = tauMax;
    colA = abs(titaMin) + titaMax + 1;
    A = zeros(filA, colA);
    
    for y=1:1:col % Recorro todas las columnas
        for x=1:1:fil % Recorro todas las filas
            if ( imBor(x,y) == 0 ) % Compruebo si es un borde
                % Obtengo el angulo del gradiente
                if ( imX(x,y) == 0 ) % Si no varía en x, variará solo en y
                    if (imY (x,y) > 0)
                        anguloGra = 90;
                    else
                        anguloGra = -90;
                    end   
                    
                elseif (imY(x,y) == 0) % Si no varía en x, lo hará sólo en y
                    anguloGra = 0;
                    
                else
                    anguloGra = round(rad2deg(atan2(imY(x,y),imX(x,y))));
                    
                    if anguloGra < -90
                        anguloGra = 180 + anguloGra;
                    end
                    
                end
                
                % Calculo los ángulos mínimos y máximos para los que vamos
                % a comprobar tau y verifico que están dentro del rango
                min = anguloGra - see;
                max = anguloGra + see;
                
                if min < titaMin
                    min = titaMin;
                end
                
                if max > titaMax
                    max = titaMax;
                end
                
                % Calculamos los tau asociados a las tita
                for tita=min:1:max
                    parteX = x*cos(deg2rad(tita));
                    parteY = y*sin(deg2rad(tita));
                    tau = round(parteX + parteY);
                    % Compruebo que la tau esta dentro del rango
                    if (tau > 0) && (tau < tauMax)
                        A(tauMax-tau,tita-titaMin+1) = A(tauMax-tau,tita-titaMin+1)+1;
                    end
                end
            end
        end
    end

    % Calculamos el valor maximo de votos y se lo asignamos a 255,
    % multiplicando el resto por un factor
    maxValue = 0;
    for i=1:filA
        for j=1:colA
            if A(i,j) > maxValue
                maxValue = A(i,j);
            end
        end
    end
    
    factor = 255/maxValue;
    for i=1:filA
        for j=1:colA
            A(i,j) = round(A(i,j)*factor);
        end
    end
    
    % Inicializo imagenes de salida
    imRes = ones(fil,col)*255;
    imRectas = ones(fil,col)*255;
    
    for tau=1:1:filA % Recorro las filas de la matriz de votos
        for tita=titaMin:1:titaMax % Recorro las columnas de la matriz de votos
            if ( A(tau,tita-titaMin+1) > th )
                maxLocal = isLocalMax(A, tau, tita-titaMin+1, seeLocalMax);
                if (maxLocal)
                    if  tita == 0 || tita == 180 
                       for y=1:1:col
                           imRectas(tauMax-tau,y) = 0;
                           if ( imBor(tauMax-tau,y) == 0)
                              imRes(tauMax-tau,y) = 0;
                           end   
                       end
                       
                    elseif tita == 90
                        for x=1:1:fil
                           imRectas(x,tauMax-tau) = 0;
                           if ( imBor(x,tauMax-tau) == 0)
                              imRes(x,tauMax-tau) = 0;
                           end   
                        end
                        
                    else
                        
                        for y=1:1:col
                            num = (tauMax-tau) - y*sin(deg2rad(tita));
                            den = cos(deg2rad(tita));
                            x = round(num/den);
                            if (( 0 < x ) && ( x < fil ))
                                %disp('siii')
                                imRectas(x,y) = 0;
                                if ( imBor(x,y) == 0)
                                    imRes(x,y) = 0;
                                end                            
                            end
                        end
                    end
%                     tita
               %figure(4)
               %imshow(imRectas);
                end

            end
        end
    end

    
    imVotos = uint8(A);
    
    imVotos(1,91) = 255;
    imVotos(2,91) = 255;
    imVotos(3,91) = 255;
    imVotos(1,92) = 255;
    imVotos(2,92) = 255;
    imVotos(3,92) = 255;
    
    imVotos(1,1) = 255;
    imVotos(2,1) = 255;
    imVotos(3,1) = 255;
    imVotos(1,2) = 255;
    imVotos(2,2) = 255;
    imVotos(3,2) = 255;
    
    imVotos(1,181) = 255;
    imVotos(2,181) = 255;
    imVotos(3,181) = 255;


    
    time = toc;
    
     