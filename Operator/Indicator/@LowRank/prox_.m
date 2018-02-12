function z = prox_(lr, ~, x)

[u, s, v] = svd(x, 'econ');
s = diag(s);
[m, n] = size(x);
r = min([m, n, lr.r]);
idx = 1 : r;
z = u(:, idx) * bsxfun(@times, s(idx), v(:, idx)');

end

