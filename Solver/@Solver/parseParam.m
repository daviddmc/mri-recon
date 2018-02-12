function parseParam(solver, param)

if ~isfield(param, 'maxIter')
    solver.param.maxIter = 30;
else
    solver.param.maxIter = param.maxIter;
end

if ~isfield(param, 'plotFun')
    solver.param.plotFun = [];
else
    solver.param.plotFun = param.plotFun;
end

if ~isfield(param, 'verbose')
    solver.param.verbose = 1;
else
    solver.param.verbose = param.verbose;
end

if ~isfield(param, 'tol')
    solver.param.tol = 1e-3;
end

%{
if ~isfield(param, 'tolRel')
    solver.param.tolRel = 1e-3;
else
    solver.param.tolRel = param.tolRel;
end

if ~isfield(param, 'tolAbs')
    solver.param.tolAbs = solver.param.tolRel * 1e-3;
else
    solver.param.tolAbs = param.tolAbs;
end
%}
%{
if iscell(x0)
    nx = 0;
    for x = x0
        nx = nx + numel(x);
    end
else
    nx = numel(x0);
end
solver.param.nsqrt = sqrt(nx);
%}
if ~isfield(param, 'stopCriteria')
    solver.param.stopCriteria = 'COST_UPDATE';
else
    solver.param.stopCriteria = param.stopCriteria;
end

solver.parseParam_(param);
%{
switch param.algorithm
    case 'PG'
        param.lambda
        param.omega
        
    case 'FBPD'
        param.tau
        param.sigma
        param.omega
        
    case 'FBFPD'
    case 'ADMM'
    case 'ALM'
    case 'PPXA'
    case 'POCS'
    case 'LSQR'
        L, labmda
    case 'NLCG'
        param.alpha
        param.beta
        param.t0
        param.maxIterLS
        param.CGtype
    case 'LBFGS'
    otherwise
        error(' ');
end
%}
end

