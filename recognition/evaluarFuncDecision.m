% Evaluates the decision function of a class for a given object (point)
% 
% > Inputs <
%
% mode    : Type of the decision function
%			mode = 1 for the normal (gaussian) distribution. It uses the
%                    Mahalanobis distance.
%			mode = 2 for the normal (gaussian) distribution where the prior 
%                    probabilities and the covariances are the same for all 
%                    the classes. It uses the Mahalanobis distance.
%			mode = 3 for the normal (gaussian) distribution with classes 
%                    having the same prior probability and isotropic 
%                    covariance matrices. Uses an Euclidean distance.
% xyObj   : Coordinates of the object (point) to classify.
% xyClass : Coordinates of the objects (elements) belonging to the class.
% covar   : Covariance matrix of the objects (points) of the class.
% prob    : Prior probability of the class.
%
% > Outputs <
%
% d : Evaluation result.
%
% > Notes <
%
% > En el caso de querer forzar el modo 2 (distancia de Mahalanobis)
% se puede calcular la matriz de covarianza cov = A*A', donde A es la
% matriz con todos los puntos de todas las clases, en la que la normalizaci�n
% se ha realizado restando a cada posici�n de la matriz la media de la caracter�stica
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
    
	% Calculamos la media de cada caracter�stica
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
    