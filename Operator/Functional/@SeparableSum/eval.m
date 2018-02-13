function y = eval( ss, x)

ndimX = ndims(x);
nLast = size(x, ndimX);
prefix = cell(1, ndimX - 1);
prefix(:) = {':'};
y = 0;

for ii = 1 : nLast
    if isempty(prefix)
        y = y + ss.inputList{ii}.eval(x(ii));
    else
        y = y + ss.inputList{ii}.eval(x(prefix{:}, ii));
    end
end

y = y * ss.mu;

end

