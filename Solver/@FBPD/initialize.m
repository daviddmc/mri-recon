function state = initialize( fbpd, state)

if fbpd.A.shape == 0
    state.unitary = sqrt(fbpd.A.unitary);
else
    state.unitary = 0;
end

state.tau = fbpd.param.tau;
state.sigma = fbpd.param.sigma;
state.useA = fbpd.param.useA;
state.isPDHG = fbpd.param.isPDHG;
state.useRes = strcmpi(fbpd.param.stopCriteria, 'RESIDUAL');

if state.isPDHG
    state.grad = 0;
else
    state.grad = fbpd.h.grad(state.var);
end

if state.useA
    state.varDual = fbpd.A.apply(state.var);
    state.Ax = state.varDual;
    state.Atv = fbpd.A.adjoint(state.varDual);
else
    state.varDual = state.var;
end
    
end
