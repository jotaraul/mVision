%Este programa lee una imagen de niveles de gris, de donde se recorta 
%una subimagen (crop), que luego se binariza.
%Esta imagen binaria es adelgazada mediante el algoritmo de ZHANG Y SUEN
%(funcion 'veradel')
%J.Gonzalez - 20 Abril 2005 
im=imread('shapessm.jpg');
%im=imread('numeros.jpg');
figure(1),imshow(im)
im_crop=imcrop;
im_bin=im2bw(im_crop,0.5);
figure(2),imshow(im_bin)
figure,veradel (double(im_bin)); %Llamada a funcion de adelgazamiento