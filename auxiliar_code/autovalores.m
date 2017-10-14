function [val,vec,covars]=autovalores(puntos,show,modo)

    %Comprobamos que el tamaño sea el adecuado (vector 2xN)
    if size(puntos,1)< 2
        error('La entrada debe ser un vector de puntos en dos dimensiones.');
    end
    
    if nargin < 3
        modo = 0;
    end
    
    oldPuntos = puntos;
    
    [basura n] = size(puntos);
    %Cálculo de medias y normalización de puntos
    
    if modo == 0        

        upuntos1 = mean(puntos(1,:));
        puntos(1,:) = puntos(1,:) - upuntos1;

        upuntos2 = mean(puntos(2,:));
        puntos(2,:) = puntos(2,:) - upuntos2;

        %Matriz de covarianzas
        covars = (1/n)*[puntos(1,:)*puntos(1,:)' puntos(1,:)*puntos(2,:)' ; ...
                     puntos(2,:)*puntos(1,:)' puntos(2,:)*puntos(2,:)'];

        %covars = 1/n*(puntos*puntos');
    
    elseif modo == 1
            
        upuntos11 = mean(puntos(1,:));
        puntos(1,:) = puntos(1,:) - upuntos11;

        upuntos12 = mean(puntos(2,:));
        puntos(2,:) = puntos(2,:) - upuntos12; 
        
        upuntos21 = mean(puntos(3,:));
        puntos(3,:) = puntos(3,:) - upuntos21;

        upuntos22 = mean(puntos(4,:));
        puntos(4,:) = puntos(4,:) - upuntos22; 
        
        puntos2(1,:) = [puntos(1,:) puntos(3,:)];
        puntos2(2,:) = [puntos(2,:) puntos(4,:)];
        
        %Matriz de covarianzas
        covars = (1/n)*[puntos2(1,:)*puntos2(1,:)' puntos2(1,:)*puntos2(2,:)' ; ...
                 puntos2(2,:)*puntos2(1,:)' puntos2(2,:)*puntos2(2,:)'];

        %covars = 1/n*(puntos*puntos');
        
        
    end
    
    
    %Autovalores y autovectores
    [vec,val]=eig(covars);
    val = sqrt(diag(val));
    
    if show
        
        %Mostramos los autovectores con un tamaño igual a los autovalores       
        figure,hold on
    
        for i=1:2
            plot(upuntos1 + [0 val(i)*vec(1,i)], upuntos2 +[0 val(i)*vec(2,i)]);
        end

        %Mostramos los puntos base
    
        plot(oldPuntos(1,:),oldPuntos(2,:),'r*');
        grid,hold off
        title('Autovectores de la nube de puntos');
    
        %Calculamos y mostramos los puntos en el nuevo espacio
%         recalculados = zeros(2,N,'double');
%         for i=1:3,recalculados(:,i)=vec'*normalizados(:,i);end
%         figure
%         plot(recalculados(1,:),recalculados(2,:),'r*')
%         grid,hold off
%         title('Puntos en el nuevo espacio');
        
    end
    
    
    
    