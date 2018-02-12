function state = update( pg, state )

lambda = state.lambda;
x = state.var;
t0 = state.t;

if pg.param.isSearch
    [x, iterLS] = LineSearch(pg.f, pg.g, x, lambda, pg.param.maxIterLS);
    if iterLS == 1
        lambda = lambda * 2;
    elseif iterLS >= 3
        lambda = lambda * 0.5;
    end
else
    x = pg.g.prox(lambda, x - lambda * pg.f.grad(x));
end
    
if pg.param.isFast
    t = (1 + sqrt(1 + 4 * t0^2)) / 2;
    omega = (t0 - 1) / t;
else
    omega = pg.param.omega;
end

if omega
    x = x + omega * (x - state.var);
end

state.var = x;
state.t = t;
state.lambda = lambda;

end

function [x, iter] = LineSearch(f, g, x0, lambda0, maxIterLS)

grad = f.grad(x0);
fval = f.eval(x0);
lambda = lambda0;
x = x0;
for iter = 1 : maxIterLS
    x = x0 - lambda * grad;
    x = g.prox(lambda, x);
    
    dif = x(:) - x0(:);
    f_hat = fval + grad(:)' * dif + (dif' * dif) / (2 * lambda);
    
    if(f.eval(x) <= f_hat)
        break;
    end
    lambda = lambda / 2;
end
end

