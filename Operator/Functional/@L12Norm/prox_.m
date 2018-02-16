function z = prox_(norm12, lambda, x)

    absx = sqrt(sum(abs(x).^2, norm12.dim2));
    unity = x ./ (absx + eps);
    z = (absx > lambda) .* (unity .* (absx - lambda));
    
end
    