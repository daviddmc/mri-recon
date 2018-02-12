function parseParam_(pg, param)

pg.param.isSearch = 0;
if ~isfield(param, 'lambda')
    if(pg.f.L)
        pg.param.lambda = 1 / pg.f.L;
    else
        pg.param.lambda = 1;
        pg.param.isSearch = 1;
        warning('line search is used');
        if ~isfield(param, 'maxIterLS')
            pg.param.maxIterLS = 10;
        else
            pg.param.maxIterLS = param.maxIterLS;
        end
    end
else
    pg.param.lambda = param.lambda;
end

pg.param.isFast = 0;
if ~isfield(param, 'omega')
    pg.param.isFast = 1;
else
    pg.param.omega = param.omega;
end

end

