function [g1, g2] = gradOp_(ssd, prevGrad)

    if ssd.inList{1}.isConstant
        g1 = [];
    else
        g1 = prevGrad * ssd.cache;
    end
    
    if ssd.inList{2}.isConstant
        g2 = [];
    else
        g2 = -prev_grad * ssd.cache;
    end
    