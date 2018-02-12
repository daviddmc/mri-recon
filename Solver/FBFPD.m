function [ x, info ] = FBFPD( f, g, A, h, x0, param )

t1 = tic;

if nargin < 4
    param = struct();
end

if isempty(A)
    A = Identity();
end

if ~isfield(param, 'tau')
    if(~isempty(h.L) && A.l2norm)
        mu = h.L + A.l2norm;
        tau = 1 / (2*mu);
    else
        tau = 0.1;
    end
else
    tau = param.tau;
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

x = x0;
v = A.apply(x);

for iter = 1 : maxIter
    
    if verbose >= 2
        fprintf('Iteration %d:\n', iter);
    end
    
    y1 = x - tau * (h.grad(x) + A.adjoint(v));
    y2 = v + tau * A.apply(x);
    p1 = f.prox(y1, tau);
    p2 = proxConj(g, y2, tau);
    q1 = p1 - tau * (h.grad(p1) + A.adjoint(p2));
    q2 = p2 + tau * A.apply(p1);
    
    primalUpdate = q1 - y1;
    dualUpdate = q2 - y2;
    
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
