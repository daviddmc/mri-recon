function z = prox_( ss, lambda, x)

z = zeros(size(x));
ndimX = ndims(x);
nLast = size(x, ndimX);
prefix = cell(1, ndimX - 1);
prefix(:) = {':'};

for ii = 1 : nLast
    if isempty(prefix)
        z(ii) = ss.funList{ii}.prox(lambda, x(ii));
    else
        z(prefix{:}, ii) = ss.funList{ii}.prox(lambda, x(prefix{:}, ii));
    end
end

end

