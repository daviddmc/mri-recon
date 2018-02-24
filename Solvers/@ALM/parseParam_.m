function param = parseParam_(alm, param)

defaultParam = struct('stopCriteria', 'PRIMAL_DUAL_UPDATE',...
                      'mu', 1,...
                      'beta', 4,...
                      'paramCG', [],...
                      'updateInterval', 1);
param = setDefaultField(defaultParam, param);     

if length(param.mu) ~= length(alm.eqList)
    if length(param.mu) == 1
        param.mu = param.mu * ones(1, length(alm.eqList));
    else
        error(' ');
    end
end

if length(param.beta) ~= length(alm.eqList)
    if length(param.beta) == 1
        param.beta = param.beta * ones(1, length(alm.eqList));
    else
        error(' ');
    end
end



