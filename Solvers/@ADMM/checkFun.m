function checkFun(admm)

[admm.f, admm.B, admm.g] = admm.inList{:};

if ~admm.f.isProx
    error(' ');
end

if ~admm.g.isProx
    error(' ');
end

if ~isempty(admm.B) && ~admm.B.isLinear
    error(' ');
end

if length(admm.f.getVarList) ~= 1 || length(admm.g.getVarList) ~= 1
    error(' ');
end

end

