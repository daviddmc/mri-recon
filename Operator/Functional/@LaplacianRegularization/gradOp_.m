function g = gradOp_(LapReg, preGrad)

    g = IDCT(LapReg.cache, LapReg.dim) * preGrad;
    
end