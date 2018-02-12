function z = SVT(z, lambda)
% Singular Value Thresholding
% Check if upper bound is lower than threshold first
% if not then proceed with SVT

if isvector(z)
    t = norm(z(:));
    z = SoftThresh(t, lambda) * z / (t + eps);
    return;
end

if ( size(z,1) > size(z,2) )
    zz = z' * z;
else
    zz = z * z';
end

if (max( sum( abs( zz ), 1 ) ) < lambda^2)
    
    z = z * 0;
    
else
    [u, s, v] = svd(z, 'econ');
    s = softThreshold(diag(s), lambda);
    r = find(s > eps, 1, 'last');
    if isempty(r)
        z = z * 0;
    else
        z = u(:, 1:r) * bsxfun(@times, s(1:r), v(:, 1:r)');
    end
end
