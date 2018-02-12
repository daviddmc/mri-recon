function [ x, info ] = FBPD( f, g, A, h, x0, param )

t1 = tic;

if nargin < 4
    param = struct();
end

if isempty(A)
    A = Identity("FBPD_IDENTITY");
end

if ~isfield(param, 'tau')
    if(~isempty(h.L))
        tau = 1 / h.L;
    else
        tau = 1;
    end
else
    tau = param.tau;
end

if ~isfield(param, 'sigma')
    if(A.L)
        sigma = 1 / (2 * tau * A.L);
    else
        sigma = 1 / (2 * tau);
    end
else
    sigma = param.sigma;
end

isFast = 0;
if ~isfield(param, 'omega')
    isFast = 1;
else
    omega = param.omega;
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

t0 = 1;
%{
if iscell(x0)
    x = x0;
else
    x = {x0};
end
%}
x = x0;
v = A.apply(x) / sigma;

for iter = 1 : maxIter
    
    if verbose >= 2
        fprintf('Iteration %d:\n', iter);
    end
    
    %q = g.proxConj(sigma, v + sigma * A.apply(x));
    %grad = h.grad(x);
    %tmp = x - tau * (grad + A.adjoint(2 * q - v));
    %p = f.prox(tau, tmp);
    
    grad = h.grad(x);
    tmp = x - tau * (grad + A.adjoint(v));
    p = f.prox(tau, tmp);
    q = g.proxConj(sigma, v + sigma * A.apply(2*p - x));
    
    %grad = h.grad(x);
    %tmp = x - tau * (grad + sigma * A.adjoint(v));
    %p = f.prox(tau, tmp);
    %tmp = v + sigma * A.apply(2*p - x);
    %q = tmp - g.prox(1/sigma, tmp);
    
    if isFast
        t = (1 + sqrt(1 + 4 * t0^2)) / 2;
        omega = (t0 - 1) / t;
        t0 = t;
    end
    
    primalUpdate = omega * (p - x);
    dualUpdate = omega * (q - v);
    
    primalNormRel = norm(primalUpdate(:)) / (norm(x(:)) + eps);
    dualNormRel = norm(dualUpdate(:)) / (norm(v(:)) + eps);
    
    x = x + primalUpdate;
    v = v + dualUpdate;
    
    if primalNormRel < tol && dualNormRel < tol && iter>1
        break;
    end
    
    if verbose >= 2
        fprintf('primal norm rel: %f, dual norm rel: %f\n', ...
            primalNormRel, dualNormRel);
        costf = f.eval(x);
        costg = g.eval(A.apply(x));
        costh = h.eval(x);
        cost = costf + costg + costh;
        fprintf('costf: %f, costg: %f, costh: %f, cost: %f\n',...
            costf, costg, costh, cost);
    end
end

info.iter = iter;
info.algo = mfilename;
info.time = toc(t1);
info.v = v;
