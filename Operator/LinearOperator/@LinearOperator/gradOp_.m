function y = gradOp_(linOp, preGrad)

linOp.isAdjoint = ~linOp.isAdjoint;
y = linOp.apply_(preGrad);
linOp.isAdjoint = ~linOp.isAdjoint;

