function [isStop, convergenceInfo] = testConvergence( solver, state )

isStop = 0;
NarDivNaNr = state.normar / (state.norma * state.normr);
if NarDivNaNr <= solver.param.tol || state.normr <= solver.param.tol * state.normb
    isStop = 1;
end
convergenceInfo = {'norm r / norm b', state.normr / state.normb,...
    'norm Ar / (norm A * norm r)', NarDivNaNr};
    

end
