function z = prox( ss, lambda, x, H)

if nargin < 4
    H = [];
end

z = zeros(size(x));
ndimX = ndims(x);
nLast = size(x, ndimX);
prefix = cell(1, ndimX - 1);
prefix(:) = {':'};
lambda = lambda * ss.mu;
for ii = 1 : nLast
    if isempty(prefix)
        z(ii) = ss.inputList{ii}.prox(lambda, x(ii), H);
    else
        z(prefix{:}, ii) = ss.inputList{ii}.prox(lambda, x(prefix{:}, ii), H);
    end
end

end

