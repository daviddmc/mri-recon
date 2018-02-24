function g = gradOp_(LapReg, preGrad)

    g = idctn(LapReg.cache, LapReg.dim) * preGrad;
    
end