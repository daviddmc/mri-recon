function param = parseParam_(fbpd, param)

param.useA = ~isa(fbpd.A, 'Identity');
param.isPDHG = isa(fbpd.h, 'ZeroFunction');

if ~isfield(fbpd.param, 'stopCriteria')
    param.stopCriteria = 'RESIDUAL';
end

if param.isPDHG
    
    if ~isfield(param, 'tau')
        if(param.useA && fbpd.A.L)
            param.tau = 0.95 * sqrt(1 / fbpd.A.L);
        else
            param.tau = 0.95;
        end
    end

    if ~isfield(param, 'sigma')
        param.sigma = param.tau;
    end
    
    if ~isfield(param, 'delta1')
        param.delta1 = 2/3;
    end

    if ~isfield(param, 'delta2')
        param.delta2 = 3/2;
    end

    if ~isfield(param, 'eta')
        param.eta = 0.95;
    end

    if ~isfield(param, 'alpha')
        param.alpha = 0.5;
    end
else
    if ~isfield(param, 'tau')
        if(fbpd.h.L)
            param.tau = 1 / fbpd.h.L;
        else
            param.tau = 1;
        end
    end

    if ~isfield(param, 'sigma')
        if(param.useA && fbpd.A.L)
            param.sigma = 1 / (2 * param.tau * fbpd.A.L);
        else
            param.sigma = 1 / (2 * param.tau);
        end
    end
end




end

