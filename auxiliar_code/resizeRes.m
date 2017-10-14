
function imRes = resizeRes(im, hsize)

    incremento = floor(hsize/2);
    
    [fil, col] = size(im);
    
    imRes = im((1+incremento):(fil-incremento),(1+incremento):(col-incremento));
    
            
            
