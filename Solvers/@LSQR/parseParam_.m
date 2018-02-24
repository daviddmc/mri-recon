function param = parseParam_(lq, param)

defaultParam = struct('stopCriteria', 'RESIDUAL',...
                      'tol', 1e-6);
param = setDefaultField(defaultParam, param);     
