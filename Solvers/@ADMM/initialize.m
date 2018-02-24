function state = initialize( admm, state)

state.tau = admm.param.tau;
state.gamma = admm.param.gamma;
state.useB = admm.param.useB;
state.useRes = strcmpi(admm.param.stopCriteria, 'RESIDUAL');
state.updateInterval = admm.param.updateInterval;

if state.useB
    state.Bv = admm.B.apply(state.var);
else
    state.Bv = state.var;
end

state.varDual = 0 * state.Bv;

if state.updateInterval && isfinite(state.updateInterval)
    state.adaptive.lambda = state.varDual;
    state.adaptive.lambdah = state.varDual;
    state.adpative.Bv = state.Bv;
    state.adaptive.u = state.Bv;
else
    state.updateInterval = inf;
end


    
end
