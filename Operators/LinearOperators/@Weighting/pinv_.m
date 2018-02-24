function y = pinv_(m, x)

if m.isAdjoint
    y = x ./ conj(m.w);
else
    y = x ./ m.w;
end

end

