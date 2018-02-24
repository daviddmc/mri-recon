function param = parseParam_(pg, param)

param.isSearch = 0;
if ~isfield(param, 'lambda')
    if(pg.f.L)
        param.lambda = 1 / pg.f.L;
    else
        param.lambda = 1;
        param.isSearch = 1;
        warning('line search is used');
        if ~isfield(param, 'maxIterLS')
            param.maxIterLS = 10;
        else
            param.maxIterLS = paramUser.maxIterLS;
        end
    end
end

param.isFast = 0;
if ~isfield(param, 'omega')
    param.isFast = 1;
end

end

