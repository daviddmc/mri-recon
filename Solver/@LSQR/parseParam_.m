function parseParam_(lq, param)

if ~isfield(param, 'stopCriteria')
    lq.param.stropCriteria = 'RESIDUAL';
end

if ~isfield(param, 'tol')
    lq.param.tol = 1e-6;
end