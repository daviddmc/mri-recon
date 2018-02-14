function y = eval( ss, x)

ndimX = ndims(x);
nLast = size(x, ndimX);
prefix = cell(1, ndimX - 1);
prefix(:) = {':'};
y = 0;

flag = ss.isConstant;

if flag
    backup = ss.varList{1}.cache;
    ss.varList{1}.setVar();
end

for ii = 1 : nLast
    if isempty(prefix)
        y = y + ss.inputList{ii}.eval(x(ii));
    else
        y = y + ss.inputList{ii}.eval(x(prefix{:}, ii));
    end
end

if flag
    ss.varList{1}.setVar(backup);
end

y = y * ss.mu;

end

