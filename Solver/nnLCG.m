function [x, info] = NLCG(fList, AList, x0, param)


t1 = tic;

if nargin < 4
    param = struct();
end

if ~isfield(param, 'alpha')
    alpha = 0.01;
else
    alpha = param.alpha;
end

if ~isfield(param, 'beta')
    beta = 0.5;
else
    beta = param.beta;
end

if ~isfield(param, 't0')
    t0 = 1;
else
    t0 = param.t0;
end

if ~isfield(param, 'maxIter')
    maxIter = 100;
else
    maxIter = param.maxIter;
end

if ~isfield(param, 'maxIterLS')
    maxIterLS = 100;
else
    maxIterLS = 100;
end

if ~isfield(param, 'tol')
    tol = 1e-4;
else
    tol = param.tol;
end

if ~isfield(param, 'method')
    method = 1;
else
    if strcmpi(param.method, 'FR')
        method = 1;
    elseif strcmpi(param.method, 'PR')
        method = 0;
    else
        error(' ');
    end
end

if ~isfield(param, 'verbose')
    verbose = 1;
else
    verbose = param.verbose;
end

x = x0;
g0 = grad(fList, AList, x);
p = -g0;

% iterations
for iter = 1 : maxIter
    
    if verbose >= 1
        fprintf('Iteration %d:\n', iter);
    end

% backtracking line-search

	% pre-calculate values, such that it would be cheap to compute the objective
	% many times for efficient line-search
	[AxList, ApList] = precompute(AList, x, p);
	f0 = fun(fList, AxList, ApList, x, p, 0);
	t = t0;
    gp = alpha * abs(g0(:)' * p(:));
    for iterLS = 1 : maxIterLS
        
        if verbose >= 2
            fprintf('Line Search Iteration %d:\n', iterLS);
        end
        
        f1 = fun(fList, AxList, ApList, x, p, t);
        if f1 < f0 - t * gp
            break;
        end
        t = t * beta;
    end
    
    if verbose == 1
        fprintf('Line Search Iteration number %d:\n', iterLS);
    end
	
	if iterLS > 3
		t0 = t0 * beta;
	end 
	
	if iterLS == 1
		t0 = t0 / beta;
	end

	x = x + t * p;
    
    if verbose >= 2
        fprintf('cost: %f\n', f1);
    end

	%--------- uncomment for debug purposes ------------------------	
	%disp(sprintf('%d   , obj: %f, RMS: %f, L-S: %d', k,f1,RMSerr,lsiter));

	%---------------------------------------------------------------
	
    %conjugate gradient calculation
    
	g = grad(fList, AList, x);
    if method
        b = g(:)'*g(:)/(g0(:)'*g0(:)+eps);
    else
    end
	p =  - g + b* p;
    
    g0 = g;
	
	%TODO: need to "think" of a "better" stopping criteria ;-)
	%if  (abs((f1-f0)/f0) < tol) 
	%	break;
	%end

end

info.algo = mfilename;
info.time = toc(t1);

end

function f = fun(fList, AxList, ApList, x, p, t)
    f = 0;
    len = length(fList);
    for ii = 1 : len
        if isempty(AxList{ii})
            f = f + fList{ii}.eval(x + t * p);
        else
            f = f + fList{ii}.eval(AxList{ii} + t * ApList{ii});
        end
    end
end

function g = grad(fList, AList, x)

    g = 0;
    len = length(fList);
    for ii = 1 : len
        if isempty(AList{ii})
            g = g + fList{ii}.grad(x);
        else
            g = g + AList{ii}.adjoint(fList{ii}.grad(AList{ii}.apply(x)));
        end
    end
    
end

function [AxList, ApList] = precompute(AList, x, p)
    len = length(AList);
    AxList = cell(1, len);
    ApList = cell(1, len);
    
    for ii = 1 : len
        if ~isempty(AList{ii})
            AxList{ii} = AList{ii}.apply(x);
            ApList{ii} = AList{ii}.apply(p);
        end
    end
end


