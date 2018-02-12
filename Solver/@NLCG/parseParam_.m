function parseParam_(nlcg, param)

if ~isfield(param, 'alpha')
    nlcg.param.alpha = 0.01;
else
    nlcg.param.alpha = param.alpha;
end

if ~isfield(param, 'beta')
    nlcg.param.beta = 0.5;
else
    nlcg.param.beta = param.beta;
end

if ~isfield(param, 't0')
    nlcg.param.t0 = 1;
else
    nlcg.param.t0 = param.t0;
end

if ~isfield(param, 'maxIterLS')
    nlcg.param.maxIterLS = 100;
else
    nlcg.param.maxIterLS = param.maxIterLS;
end

if ~isfield(param, 'method')
    nlcg.param.method = 'FR';
else
    if ismember(param.method, {'FR', 'PR', 'HS', 'DY'})
        nlcg.param.method = param.method;
    else
        error(' ');
    end
end

end

