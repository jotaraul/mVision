
% Evalua la función de decisión de una clase para un determinado punto (elemento).
% 
% > Entradas <
%
% modo    : Modo de la función de decisión
%			modo = 1 para distribución normal.
%			modo = 2 para distribución normal en la que las probabilidades 
%				     a priori son iguales (igual dispersión de clases). 
%					 Distancia de Mahalanobis.
%			modo = 3 para distribución normal con matriz de covarianzas 
%					 isotrópica (no hay correlación entre las características).
%					 Distancia euclidea.
% xyObj   : Coordenadas del punto (elemento) a clasificar.
% xyClase : Coordenadas de los puntos (elementos) pertenecientes a la clase.
% covar   : Matriz de covarianza de los puntos (elementos) de la clase.
% prob    : Probabilidad a priori de la clase.
%
% > Salidas <
%
% d : Resultado de la evaluación de la función de decisión.
%
% > Notas <
%
% > En el caso de querer forzar el modo 2 (distancia de Mahalanobis)
% se puede calcular la matriz de covarianza cov = A*A', donde A es la
% matriz con todos los puntos de todas las clases, en la que la normalización
% se ha realizado restando a cada posición de la matriz la media de la característica
% a la que corresponda de los elementos que pertenezcan a esa misma clase. P.ej:
% Puntos de la clase 1: x1 = [1 2] y1 = [2 5]
% Puntos de la clase 2: x2 = [5 7] y2 = [1 3] 
% Medias: ux1 = 1.5 uy1 = 3.5 ux2 = 6 uy2 = 2
% Matriz A = [1-1.5 2-1.5 5-6 7-6; 2-3.5 5-3.5 1-2 3-2];
% covar = A*A';
%
% > Si queremos forzar el modo 3 (distancia euclidea) se procede igual que en el
% apartado anterior, y una vez calculada la matriz de covarianza se ponen a cero
% los elementos que no pertenezcan a la matriz diagonal.


function d = evaluarFuncDecision(modo, xyObj, xyClase, covar, prob)
    
	% Calculamos la media de cada característica
    media = mean(xyClase,2);
    
    if modo == 1
        
	    % Numero de caracteristicas
		[n, basura] = size(xyClase);
        d = log(prob) + log((1/(((2*pi)^(n/2))*(det(covar)^0.5)))*exp(1)^(-0.5*(xyObj-media)'*inv(covar)*(xyObj-media)));
        
    elseif modo == 2
        
        d = -(xyObj - media)'*inv(covar)*(xyObj-media);
        
    elseif modo == 3
        
        d = -(xyObj-media)'*(xyObj-media);
        
    end
    