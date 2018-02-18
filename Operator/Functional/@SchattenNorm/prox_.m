function z = prox_(nuc, lambda, x)

sizeX = size(x);
x = reshape(x,[prod(sizeX(1:nuc.dim)),prod(sizeX(nuc.dim+1:end))]);
z = GSVT(x, lambda, nuc.p);
z = reshape(z, sizeX);
    
end

%{
if nuc.proxOption.type
    
    z = schattenProx(x, lambda, nuc.p);
    
else
    lambda = nuc.p * lambda;
    e = nuc.p/2 - 1;
    [m, n] = size(x);
    
    if e
        for iter = 1 : nuc.proxOption.maxIter
            if m > n %xtx
                A = lambda * (x'*x)^e;
                A(1:n+1:end) = abs(A(1:n+1:end)) + 1;
                %x = x / A;
                R = chol(A);
                x = x/R;
                x = x/R';
            else %xxt
                A = lambda * (x*x')^e;
                A(1:m+1:end) = abs(A(1:m+1:end)) + 1;
                R = chol(A);
                x = R'\x;
                x = R\x;
            end
        end
        z = x;
    else
        z = 1/(lambda + 1) * x;
    end
    
end
%}