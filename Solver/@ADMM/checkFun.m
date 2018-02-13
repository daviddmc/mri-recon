function checkFun(fbpd)

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

if length(fbpd.f.varList) ~= 1 || length(fbpd.g.varList) ~= 1 || length(fbpd.h.varList) ~= 1
    error(' ');
end

end

