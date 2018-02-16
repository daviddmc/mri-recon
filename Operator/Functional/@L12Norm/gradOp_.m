function g = gradOp_(l1norm, prevGrad)

    g = l1norm.cache * prevGrad;
    