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
else
    solver.param.tol = param.tol;
end

if ~isfield(param, 'stopCriteria')
    solver.param.stopCriteria = 'COST_UPDATE';
else
    solver.param.stopCriteria = param.stopCriteria;
end

solver.parseParam_(param);

end

