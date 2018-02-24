function y = eval_(nuc, x, ~)

if nargout > 0
    y = blockproc( x, nuc.blockSize , @blockNuc);
    y = sum(y(:));
end
    
end

function x = blockNuc(X)

[m,n,k] = size(X.data);

if k == 1
    
    x = svd(X.data);
   
else
    
    x = svd(reshape(X.data, m*n, k));
    
end

x = sum(x);

end