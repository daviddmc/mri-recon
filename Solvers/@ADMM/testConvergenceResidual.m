function [isStop, convergenceInfo] = testConvergenceResidual( solver, state )

isStop = 0;

if state.d <= solver.param.tol && state.r <= solver.param.tol
    isStop = 1;
end
convergenceInfo = {'primal residual rel', state.r,...
    'dual residual rel', state.d};
    

end
