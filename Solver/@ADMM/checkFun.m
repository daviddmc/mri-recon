function checkFun(admm)

if ~admm.f.isProx
    error(' ');
end

if ~admm.g.isProx
    error(' ');
end

if ~isempty(admm.B) && ~admm.B.isLinear
    error(' ');
end

if length(admm.f.varList) ~= 1 || length(admm.g.varList) ~= 1
    error(' ');
end

end

