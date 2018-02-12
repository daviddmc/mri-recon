function f = JacOp_(ssd, x, y)
    f = 0;
    if ~ssd.inputList{1}.isConstant
        f = f + ssd.cache(:)' * x(:);
    end
    
    if ~ssd.inputList{2}.isConstant(2)
        f = f - ssd.cache(:)' * y(:);
    end
    