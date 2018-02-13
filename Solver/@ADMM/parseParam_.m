function parseParam_(fbpd, param)

if ~isfield(param, 'stopCriteria')
    fbpd.param.stopCriteria = 'RESIDUAL';
end

if fbpd.param.isPDHG
    
    if ~isfield(param, 'tau')
        if(fbpd.param.useA && fbpd.A.L)
            fbpd.param.tau = 0.95 * sqrt(1 / fbpd.A.L);
        else
            fbpd.param.tau = 0.95;
        end
    else
        fbpd.param.tau = param.tau;
    end

    if ~isfield(param, 'sigma')
        fbpd.param.sigma = fbpd.param.tau;
    else
        fbpd.param.sigma = param.sigma;
    end
    
    if ~isfield(param, 'delta1')
        fbpd.param.delta1 = 2/3;
    else
        fbpd.param.delta1 = param.delta1;
    end

    if ~isfield(param, 'delta2')
        fbpd.param.delta2 = 3/2;
    else
        fbpd.param.delta2 = param.delta2;
    end

    if ~isfield(param, 'eta')
        fbpd.param.eta = 0.95;
    else
        fbpd.param.eta = param.eta;
    end

    if ~isfield(param, 'alpha')
        fbpd.param.alpha = 0.5;
    else
        fbpd.param.alpha = param.alpha;
    end
else
    if ~isfield(param, 'tau')
        if(fbpd.h.L)
            fbpd.param.tau = 1 / fbpd.h.L;
        else
            fbpd.param.tau = 1;
        end
    else
        fbpd.param.tau = param.tau;
    end

    if ~isfield(param, 'sigma')
        if(fbpd.param.useA && fbpd.A.L)
            fbpd.param.sigma = 1 / (2 * fbpd.param.tau * fbpd.A.L);
        else
            fbpd.param.sigma = 1 / (2 * fbpd.param.tau);
        end
    else
        fbpd.param.sigma = param.sigma;
    end
end




end

