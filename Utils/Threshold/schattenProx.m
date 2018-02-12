function z = schattenProx(z, lambda, p)

if p == 1
    z = SVT(z, lambda);
else
    [u, s, v] = svd(z, 'econ');
    s = powerProx(diag(s), lambda, p);
    r = find(s > eps, 1, 'last');
    if isempty(r)
        z = z * 0;
    else
        z = u(:, 1:r) * bsxfun(@times, s(1:r), v(:, 1:r)');
    end    
end
