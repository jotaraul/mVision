
function imVotos = hough_circulos(imOrig,imBordes,r,imGrad,imX,imY,handleResultado)

%Esta funcion busca circulos de radio 'r' en una imagen 'im'. 
%'ubin' es el umbral de corte para decidir si un pixel de la imagen gradiente es o no del borde.
% Devuelve 'ac', el acumulador del tamaño/resolucion de la imagen con los
% votos de cada celda/pixel.
% Ejemplo: 
%   im=imread('blood1.tif');
%   ac = hough_circulos(im,60,20);
%
%Se abrira una ventana con 4 subventanas
% El gradiente se obtiene mediante el sobel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%close all
%figure, subplot (2,2,1),imshow (im), axis image, title('IMAGEN ORIGINAL')

ang = atan2(imY,imX);

% hacer lut para determinar bordes. Se ponen a 255 los que superan 'ubin', y a cero los que no
%lut = ones (max(max(imGrad))+1,1)*255; %max(gra)devuelve un vector con los maximo de cada columna. 
                                    %Lut de dimension el valor maximo del gradiente en 'im' 
%lut(1:ubin) = lut(1:ubin)*0;
%figure, plot(max(max(gra))+1,lut)

% binarizar imagen gradiente
%imb = lut(imGrad+1); %sumamos uno porque los indices en matlab empiezan en 1 (no en cero)

%subplot (2,2,2),image (imGrad*2), axis image, title('IMAGEN GRADIENTE (sobel)')
%subplot (2,2,3),image (imb), axis image, title('IMAGEN BINARIA DE BORDES')


% seleccionar puntos de la imagen gradiente binaria
[x,y] = find (imBordes > 0);

% inicializacion de la matriz de acumulacion
ac = uint8(double(imGrad(1:size(imGrad,1),1:size(imGrad,2)))*0);
[fil,col] = size(ac);
tx = size (imGrad,1);
ty = size (imGrad,2);

numpun = size (x,1);

% transformada de hough para circulos de radio r
for punto = 1:numpun
     an = ang (x(punto),y(punto));
     %votamos en la direccion del gradiente 
     xc1  = round((x(punto)+r*cos(an)));
     yc1  = round((y(punto)+r*sin(an)));
     %Ahora votamos en la otra direccion
     xc2  = round((x(punto)+r*cos(an+pi)));
     yc2  = round((y(punto)+r*sin(an+pi)));
     if (xc1 > 0 && yc1 > 0 && xc1 <= tx && yc1 <= ty) 
        ac (xc1,yc1) = uint8(double(ac (xc1,yc1)) + 1);
     end
     if (xc2 > 0 && yc2 > 0 && xc2 <= tx && yc2 <= ty) 
        ac (xc2,yc2) = uint8(double(ac(xc2,yc2)) + 1);
     end
 end

 %subplot (2,2,4), image (uint8(double(ac)*40)), axis image, title('ACUMULADOR (x40)')
 imVotos = uint8(double(ac)*40);
 rad = 0:2*pi/100:2*pi;
 figure(1);
 imshow(imOrig);
 % busqueda de maximos locales
 maximolocal = 1;
 while maximolocal
     maximolocal = 0;
     [x,y] = find (ac == max(max(ac))); %max(max(ac)) devuelve el maximo de un vector de maximos de cada columna, i.e. el max de la matriz
                                        % find devuelve indice del maximo
                                        % del ac
                               
     if ( ((x(1)-5)<1) || ((y(1)-5)<1) || ((x(1)+5)>tx) || ((x(1)+5)>ty) )    %estamos en los bordes de la imagen y descartamos este maximo local
         suma=0; 
     else 
        suma = sum(sum(ac(x-5:x+5,y-5:y+5))); %sumamos una ventana 11x11 alrededor del maximo
    
     end
     if suma > (2*pi*r) 
        hold on, plot (y(1)+r*sin(rad),x(1)+r*cos(rad),'r.'); %pintamos la circunferencia de rojo
        maximolocal = 1;
        x1 = x(1)-10;
        if x1 < 1
            x1 = 1;
        end
        
        x2 = x(1)+10;
        if x2 > col
            x2 = col;
        end
        
        y1 = y(1)-10;
        if y1 < 1
            y1 = 1;
        end 
        
        y2 = y(1)+10;
        if y2 > fil
            y2 = fil;
        end
        
        ac (x1:x2,y1:y2) = 0; %limpiamos la region11x11 para no volver a tenerla en cuenta
     end
  end
  