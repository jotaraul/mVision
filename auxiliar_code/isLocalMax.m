
function res = isLocalMax(A, tau, tita, see)

    value = A(tau,tita);
    [fil,col] = size(A);
    res = 1;
    minFil = tau - see;
    maxFil = tau + see;
    minCol = tita - see;
    maxCol = tita + see;
    
    if minFil < 1
        minFil = 1;
    end

    if maxFil > fil
        maxFil = fil;
    end
    
    if minCol < 1
        minCol = 1;
    end
    
    if maxCol > col
        maxCol = col;
    end
    
    for i=minFil:maxFil
        for j=minCol:maxCol
            if value < A(i,j)
                res = 0;
            end
        end
    end
        
    