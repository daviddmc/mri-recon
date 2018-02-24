function param = parseParam_(admm, param)

param.useB = ~isa(admm.B, 'Identity');

defaultParam = struct('stopCriteria', 'RESIDUAL',...
                      'tau', 1,...
                      'epsilon', 0.2,...
                      'gamma', 1,...
                      'updateInterval', 2);
param = setDefaultField(defaultParam, param);

end
