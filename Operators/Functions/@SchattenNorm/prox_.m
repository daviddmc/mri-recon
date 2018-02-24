function z = prox_(nuc, lambda, x)

sizeX = size(x);
x = reshape(x,[prod(sizeX(1:nuc.dim)),prod(sizeX(nuc.dim+1:end))]);
z = GSVT(x, lambda, nuc.p);
z = reshape(z, sizeX);
    
end
