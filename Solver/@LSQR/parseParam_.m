function parseParam_(lq, param)

if isfield(param, 'stopCriteria') && ~strcmp(param.stopCriteria, 'RESIDUAL')
    warning(' ');
end
lq.param.stropCriteria = 'RESIDUAL';

if ~isfield(param, 'tol')
    lq.param.tol = 1e-6;
end