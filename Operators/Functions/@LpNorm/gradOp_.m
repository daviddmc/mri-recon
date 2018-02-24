function g = gradOp_(lp, prevGrad)
    x = lp.cache;
    g = prevGrad * sign(x) * abs(x).^(lp.p - 1);
    