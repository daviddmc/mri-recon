function z = prox_(nuc, lambda, x)
    
    blockFun = @ (X) blockSVT(X, lambda);
    z = blockproc( x, nuc.blockSize , blockFun);
    
end

function x = blockSVT(X, lambda)

[m,n,k] = size(X.data);

if k == 1
    
    x = SVT(X.data, lambda, true);
    
else
    
    x = reshape( SVT( reshape(X.data, m*n, k), lambda, true), size(X.data) );
    
end
end
