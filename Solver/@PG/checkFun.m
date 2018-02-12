function checkFun(pg)

if ~pg.f.isGrad
    error(' ');
end

if ~pg.g.isProx
    error(' ');
end

if length(pg.f.varList) ~= 1 || length(pg.g.varList) ~= 1
    error(' ');
end

end

