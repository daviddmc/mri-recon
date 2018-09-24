function g = gradOp_(l1norm, prevGrad)
    % g = l1norm.cache * prevGrad;
    g = l1norm.cache ./ sqrt(1e-15 + abs(l1norm.cache).^2) * prevGrad;
    