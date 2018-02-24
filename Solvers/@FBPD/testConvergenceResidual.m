function [isStop, convergenceInfo] = testConvergenceResidual( solver, state )

isStop = 0;

if ~state.useA || state.unitary
    pNorm = norm(state.var(:));
    dNorm = norm(state.varDual(:));
    primalNorm = max([pNorm / state.tau, dNorm * state.unitary, norm(state.grad(:))]);
    dualNorm = max(dNorm / state.sigma, pNorm * state.unitary);
else
    primalNorm = max([norm(state.var(:)) / state.tau, norm(state.Atv(:)), norm(state.grad(:))]);
    dualNorm = max(norm(state.varDual(:)) / state.sigma, norm(state.Ax(:)));
end

primalNormRel = norm(state.primalRes(:)) / primalNorm;
dualNormRel = norm(state.dualRes(:)) / dualNorm;

if primalNormRel <= solver.param.tol && dualNormRel <= solver.param.tol
    isStop = 1;
end
convergenceInfo = {'primal residual rel', primalNormRel,...
    'dual residual rel', dualNormRel};
    

end
