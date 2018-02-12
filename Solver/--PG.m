function [ x, info ] = PG( f, g, x0, param )

t1 = tic;

if nargin < 4
    param = struct();
end

isSearch = 0;
if ~isfield(param, 'lambda')
    if(~isempty(f.L))
        lambda = 1 / f.L;
    else
        lambda = 1;
        isSearch = 1;
        warning('line search is used');
    end
else
    lambda = param.lambda;
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

if ~iscell(x0)
    x0 = {x0};
end
lenVar = length(x0);
grad = cell(1, length(x0));
grad(:) = {0};
[fidx, gidx] = uniqueVarList( f.varList, g.varList );

t0 = 1;
x = x0;
for iter = 1 : maxIter
    
    if verbose >= 1
        fprintf('Iteration %d:\n', iter);
    end
    
    if isSearch
        [x, iterLS] = LineSearch(f, g, x0, lambda, maxIterLS);
        if iterLS == 1
            lambda = lambda * 2;
        elseif iterLS >= 3
            lambda = lambda * 0.5;
        end
    else
        [grad{fidx}] = f.grad(x0{fidx});
        for ii = fidx
            x{ii} = x0{ii} - lambda * grad{ii};
        end
        x{gidx} = g.prox(lambda, x{gidx});
        %x = g.prox(x0 - lambda * f.grad(x0), lambda);
    end
    
    if isFast
        t = (1 + sqrt(1 + 4 * t0^2)) / 2;
        omega = (t0 - 1) / t;
        t0 = t;
    end
    
    if omega
        for ii = 1 : lenVar
            x{ii} = x{ii} + omega * (x{ii} - x0{ii});
        end
    end
    
    costf = f.eval(x{fidx});
    costg = g.eval(x{gidx});
    cost = costf + costg;
    info.cost(iter+1) = cost;
    rel = abs(cost - info.cost(iter))/(cost + eps);
    if (abs(rel) < tol) && iter>1
        break;
    end
    
    if verbose >= 2
        fprintf('f: %f, g: %f, cost: %f, rel_update: %f\n', ...
           costf, costg, cost, rel);
    end
    
    x0 = x;
end

info.iter = iter;
info.costFinal = cost;
info.algo = mfilename;
info.time = toc(t1);
    
    
function [x, iter] = LineSearch(f, g, x0, fidx, gidx, lambda0, maxIterLS)

grad = cell(1, length(x0));
grad(:) = {0};
[grad{fidx}] = {f.grad(x0{fidx})};
fval = f.eval(x0{fidx});
lambda = lambda0;
x = x0;
for iter = 1 : maxIterLS
    for ii = fidx
        x{ii} = x0{ii} - lambda * grad{ii};
    end
    x{gidx} = g.prox(lambda, x{gidx});
    f_hat = fval;
    for ii = 1:length(x0)
        dif = x{ii}(:) - x0{ii}(:);
        f_hat = f_hat + grad{ii}(:)' * dif + (dif' * dif) / (2 * lambda);
    end
    if(f.eval(x{fidx}) <= f_hat)
        break;
    end
    lambda = lambda / 2;
end

function [idx1, idx2] = uniqueVarList( varList1, varList2 )

len1 = length(varList1);
len2 = length(varList2);

idx1 = zeros(1, len1);
idx2 = zeros(1, len2);

ii = 1;
jj = 1;
kk = 1;

while(1)

    if varList1{ii}.name == varList2{jj}.name
        idx1(ii) = kk;
        idx2(jj) = kk;
        ii = ii + 1;
        jj = jj + 1;
    elseif varList1{ii}.name < varList2{jj}.name
        idx1(ii) = kk;
        ii = ii + 1;
    else
        idx2(jj) = kk;
        jj = jj + 1;
    end
    kk = kk + 1;
    
    if ii > len1
        idx2(jj:len2) = kk:len2-jj+kk;
        break;
    end
    
    if jj > len2
        idx1(ii:len1) = kk:len1-ii+kk;
        break;
    end

end

