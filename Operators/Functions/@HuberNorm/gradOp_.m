function g = gradOp_(normh, preGrad)
    omega = normh.omega;
    g = x / omega;
    g(g > 1) = 1;
    g(g < -1) = -1;
    g = g * preGrad;
end