function [ x, info ] = ADMM( f, g, A, x0, param )

t1 = tic;

if nargin < 4
    param = struct();
end

isId = 0;
if isempty(A)
    A = Identity("ADMM_IDENTITY");
    isId = 1;
end

if ~isfield(param, 'rho0')
    rho = 1;
else
    rho = param.rho0;
end

if ~isfield(param, 'normA')
    if(A.L)
        step =  1 / A.L;
    else
        step = 1;
    end
else
    step = 1 / param.normA ^ 2;
end

if ~isfield(param, 'maxIter')
    maxIter = 100;
else
    maxIter = param.maxIter;
end

if ~isfield(param, 'tol')
    tol = 1e-4;
else
    tol = param.tol;
end

if ~isfield(param, 'verbose')
    verbose = 1;
else
    verbose = param.verbose;
end

%z0 = A.apply(x0);
if ~isId
    Ax0 = A.apply(x0);
    u = 0*Ax0;
else
    u = 0*x0;
end

for iter = 1 : maxIter
    
    lambda = 1 / rho;
    
    
    if verbose >= 2
        fprintf('Iteration %d:\n', iter);
    end
    
    if isId
        z = g.prox(lambda, x0 + u);
        x = f.prox(lambda, z - u);
        %x = f.prox(z0 - u, lambda);
        %z = g.prox(x + u, lambda);
        r = x - z;
        s = x - x0;
        
        
    else
        
        z = g.prox(lambda, Ax0 + u);
        x = f.prox(step * lambda, x - step * A.adjoint(Ax0 - z + u)); % mu = step * lambda
        Ax = A.apply(x);
        %tmp = (mu/lambda)*A.adjoint(Ax0 - z0 + u);
        %x = f.prox(x0 - tmp, mu);
        %Ax = A.apply(x);
        %z = g.prox(Ax + u, lambda);
        r = Ax - z;
        s = Ax - Ax0;
    end
    
    u = u + r;
    
    tolDual = tol * rho *norm(u(:));
    if isId
        tolPrimal = tol * norm(x(:));
    else
        tolPrimal = tol * norm(Ax(:));
    end
    
    primalResidual = norm(r(:));
    dualResidual = rho * norm(s(:));
    
    if primalResidual < tolPrimal && ...
            dualResidual < tolDual && ...
            iter>1
        break;
    end
    
    x0 = x;
    %z0 = z;
    if ~isId
        Ax0 = Ax;
    end
    
    if primalResidual > 10 * dualResidual
        rho = rho * 2;
        u = u * 0.5;
    elseif dualResidual > 10 * primalResidual
        rho = rho * 0.5;
        u = u * 2;
    end
    
    if verbose >= 2
        fprintf('primal residual: %f, primal tolerance: %f, dual residual: %f, dual tolerance: %f\n', ...
            primalResidual, tolPrimal, dualResidual, tolDual);
        costf = f.eval(x);
        costg = g.eval(A.apply(x));
        cost = sum(costf) + sum(costg);
        fprintf('costf: %s, costg: %s, cost: %f\n',...
            mat2str(costf, 6), mat2str(costg, 6), cost);
        fprintf('new rho: %f\n', rho);
    end
end

info.iter = iter;
info.algo = mfilename;
info.time = toc(t1);
%info.v = v;
