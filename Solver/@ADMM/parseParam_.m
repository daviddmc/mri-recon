function parseParam_(admm, param)

%param.isExact;

if ~isfield(param, 'stopCriteria')
    admm.param.stopCriteria = 'RESIDUAL';
end

if ~isfield(param, 'tau')
    admm.param.tau = 1;
else
    admm.param.tau = param.tau;
end

if ~isfield(param, 'epsilon')
    admm.param.epsilon = 0.2;
else
    admm.param.epsilon = param.epsilon;
end

if ~isfield(param, 'gamma')
    admm.param.gamma = 1;
else
    admm.param.gamma = param.gamma;
end

if ~isfield(param, 'updateInterval')
    admm.param.updateInterval = 2;
else
    admm.param.updateInterval = param.updateInterval;
end

end

