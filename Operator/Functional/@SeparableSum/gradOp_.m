function g = gradOp_( ss, preGrad )

x = ss.cache;

g = zeros(size(x));
ndimX = ndims(x);
nLast = size(x, ndimX);
prefix = cell(1, ndimX - 1);
prefix(:) = {':'};

for ii = 1 : nLast
    if isempty(prefix)
        g(ii) = ss.funList{ii}.grad(x(ii)) * preGrad;
    else
        g(prefix{:}, ii) = ss.funList{ii}.grad(x(prefix{:}, ii)) * preGrad;
    end
end


end

