function z = prox_(b, ~, x )

normx = norm(x(:));
if normx > b.r
    z = (b.r / normx) * x;
else
    z = x;
end

end

