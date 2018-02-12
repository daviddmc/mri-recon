function y = pinv_(w, x)

y = w.gradOp_(x);

end

