function z = proxConj(fun, lambda, x)

z = lambda * fun.prox(1/lambda, x/lambda);
z = x - z;

end

