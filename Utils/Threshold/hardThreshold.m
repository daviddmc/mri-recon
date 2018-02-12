function x = hardThreshold(x, lambda)

x(abs(x) < lambda) = 0;