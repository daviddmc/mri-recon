function z = softThreshold(x, lambda)

absx = abs(x);
z = (absx > lambda) .* (sign(x) .* (absx - lambda));