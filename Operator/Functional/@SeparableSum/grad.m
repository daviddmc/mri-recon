function g = grad( ss, x )


g = zeros(size(x));
ndimX = ndims(x);
nLast = size(x, ndimX);
prefix = cell(1, ndimX - 1);
prefix(:) = {':'};

if flag
    backup = ss.varList{1}.cache;
    ss.varList{1}.setVar();
end

for ii = 1 : nLast
    if isempty(prefix)
        g(ii) = ss.inputList{ii}.grad(x(ii));
    else
        g(prefix{:}, ii) = ss.inputList{ii}.grad(x(prefix{:}, ii));
    end
end

if flag
    ss.varList{1}.setVar(backup);
end

g = g * ss.mu;


end

