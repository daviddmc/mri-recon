function y = pinv_(zp, x)
    y = zp.gradOp_(x);
end