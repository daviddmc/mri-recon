function y = adjoint(linOp, x)

y = linOp.gradOp(x);

end