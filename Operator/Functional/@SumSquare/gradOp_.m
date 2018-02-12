function g = gradOp_(ssd, prevGrad)


g = prevGrad * ssd.cache;

    