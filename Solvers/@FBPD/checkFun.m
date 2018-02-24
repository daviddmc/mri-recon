function checkFun(fbpd)

[fbpd.f, fbpd.g, fbpd.A, fbpd.h] = fbpd.inList{:};

if ~fbpd.f.isProx
    error(' ');
end

if ~fbpd.g.isProx
    error(' ');
end

if ~fbpd.h.isGrad
    error(' ');
end

if ~fbpd.A.isLinear
    error(' ');
end

if length(fbpd.f.getVarList) ~= 1 || length(fbpd.g.getVarList) ~= 1 || length(fbpd.h.getVarList) ~= 1
    error(' ');
end

end

