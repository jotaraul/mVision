%Funcion que implementa el adelgazamiento de regiones blancas mediante el
% algoritmo de ZHANG Y SUEN
%im: imagen binaria- Fondo oscuro y objetos a adelgazar blancos
%esq: imagen con los esqueletos

function esq = veradel (im)

mx = size (im,1);
my = size (im,2);
imn (2:mx+1,2:my+1) = im;
imn (mx+2,my+2) = 0;

im = imn;

figure
image (im), colormap (gray(256)), axis image
drawnow;
im = (im > 0); % imagen binaria 0-1 

borrado = 1;
while (borrado) % mientras se borren puntos
   borrado = 0;
   [x,y] = find (im > 0); % seleccionar puntos del objeto
   imb = im;
   for k = 1:size(x,1) % para los puntos del objeto
      u = x(k);
      v = y(k);
      p = [im(u,v),im(u,v-1),im(u+1,v-1),im(u+1,v),im(u+1,v+1),...
            im(u,v+1),im(u-1,v+1),im(u-1,v),im(u-1,v-1)];
      n = sum(p(2:9));
      s = sum((diff([p(2:9),p(2)])==1));
      c = p(2)*p(4)*p(6);
      d = p(4)*p(6)*p(8);
      if ((n>=2) & (n<=6) & (s==1) & (c==0) & (d==0))
         borrado = 1;
         imb (x(k),y(k)) = 0;
      end
   end
   im = im.*imb;
   image (im*255), axis image;
   [x,y] = find (im > 0); % seleccionar puntos del objeto
   imb = im;
   drawnow;
   for k = 1:size(x,1) % para los puntos del objeto
      u = x(k);
      v = y(k);
      p = [im(u,v),im(u,v-1),im(u+1,v-1),im(u+1,v),im(u+1,v+1),...
           im(u,v+1),im(u-1,v+1),im(u-1,v),im(u-1,v-1)];
      n = sum(p(2:9));
      s = sum((diff([p(2:9),p(2)])==1));
      c = p(2)*p(6)*p(8);
      d = p(2)*p(4)*p(8);
      if ((n>=2) & (n<=6) & (s==1) & (c==0) & (d==0))
         borrado = 1;
         imb (x(k),y(k)) = 0;
      end
   end
   im = im.*imb;
   image (im*255),axis image;
   drawnow;
end

esq = im*255;
image (esq), axis image;

