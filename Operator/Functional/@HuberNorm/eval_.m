function y = eval_(normh, x, isCache)

if isCache
    normh.cache = x;
end
if nargout > 0
    omega = normh.omega;
    y = abs(x);
    interval = y < omega;
    y = y - omega/2;
    y(interval) = 0.5/omega * (y(interval) + omega/2).^2;
end

end