function f = JacOp_(l1norm, x)

f = l1norm.cache(:)' * x(:);
    