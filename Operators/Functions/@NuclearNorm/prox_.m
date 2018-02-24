function z = prox_(nuc, lambda, x)
    
sizeX = size(x);
x = reshape(x,[prod(sizeX(1:nuc.dim)),prod(sizeX(nuc.dim+1:end))]);
z = SVT(x, lambda, true);
z = reshape(z, sizeX);

end