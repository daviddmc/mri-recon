function y = apply_( s, x, ~)


if s.isAdjoint
    y = zeros(s.sizeIn);
    y(s.str{:}) = x;
else
    y = x(s.str{:});
end
