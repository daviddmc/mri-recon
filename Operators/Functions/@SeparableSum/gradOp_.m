function g = gradOp_( ss, preGrad )

x = ss.cache;
g = zeros(size(x));
ndimX = ndims(x);
nLast = size(x, ndimX);
prefix = cell(1, ndimX - 1);
prefix(:) = {':'};

for ii = 1 : nLast
    if isempty(prefix)
        g(ii) = ss.inList{ii+1}.grad(x(ii));
    else
        g(prefix{:}, ii) = ss.inList{ii+1}.grad(x(prefix{:}, ii));
    end
end

g = g * preGrad;

end

