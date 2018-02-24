function checkFun(pg)

pg.f = pg.inList{1};
pg.g = pg.inList{2};

if ~pg.f.isGrad
    error(' ');
end

if ~pg.g.isProx
    error(' ');
end

if length(pg.f.getVarList) ~= 1 || length(pg.g.getVarList) ~= 1
    error(' ');
end

end

