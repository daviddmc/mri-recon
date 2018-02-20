function parseParam_(alm, param)

if ~isfield(param, 'stopCriteria')
    alm.param.stopCriteria = 'PRIMAL_DUAL_UPDATE';
else
    alm.param.lambda = param.stopCriteria;
end

if ~isfield(param, 'mu')
    alm.param.mu = 1;
else
    alm.param.mu = param.mu;
end

if length(alm.param.mu) ~= length(alm.eqList)
    if length(alm.param.mu) == 1
        alm.param.mu = alm.param.mu * ones(1, length(alm.eqList));
    else
        error(' ');
    end
end

if ~isfield(param, 'beta')
    alm.param.beta = 4;
else
    alm.param.beta = param.beta;
end

if length(alm.param.beta) ~= length(alm.eqList)
    if length(alm.param.beta) == 1
        alm.param.beta = alm.param.beta * ones(1, length(alm.eqList));
    else
        error(' ');
    end
end

if ~isfield(param, 'paramCG')
    alm.param.paramCG = [];
else
    alm.param.paramCG = param.paramCG;
end

if ~isfield(param, 'updateInterval')
    alm.param.updateInterval = 1;
else
    alm.param.updateInterval = param.updateInterval;
end

