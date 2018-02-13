function state = update( fbpd, state )

x0 = state.var;
v0 = state.varDual; 
grad0 = state.grad;

if state.useA
    Ax0 = state.Ax;
    Atv0 = state.Atv;
else
    Ax0 = x0;
    Atv0 = v0;
end

if state.isPDHG
    x = fbpd.f.prox(state.tau, x0 - state.tau * Atv0);
    grad = 0;
else
    x = fbpd.f.prox(state.tau, x0 - state.tau * (grad0 + Atv0));
    grad = fbpd.h.grad(x);
end

if state.useA
    Ax = fbpd.A.apply(x);
    v = fbpd.g.proxConj(state.sigma, v0 + state.sigma * (2 * Ax - Ax0));
    Atv = fbpd.A.adjoint(v);
else
    v = fbpd.g.proxConj(state.sigma, v0 + state.sigma * (2 * x - x0));
end

if state.useRes
    if state.useA
        state.primalRes = 1/state.tau * (x0 - x) - (Atv0 - Atv);
        state.dualRes = 1/state.sigma * (v0 - v) - (Ax0 - Ax);
    else
        dx = (x0 - x);
        dv = (v0 - v);
        state.primalRes = 1/state.tau * dx - dv;
        state.dualRes = 1/state.sigma * dv - dx;
    end
    
    if state.isPDHG
        state.primalRes = norm(state.primalRes(:));
        state.dualRes = norm(state.dualRes(:));
        if state.primalRes / state.dualRes < fbpd.param.delta1
            state.tau = state.tau * (1 - state.alpha);
            state.sigma = state.sigma / (1 - state.alpha);
            state.alpha = state.alpha * fbpd.param.eta;
        elseif state.primalRes / state.dualRes > fbpd.param.delta2
            state.tau = state.tau / (1 - state.alpha);
            state.sigma = state.sigma * (1 - state.alpha);
            state.alpha = state.alpha * fbpd.param.eta;
        end
    else
        state.primalRes = state.primalRes - (grad0 - grad);
    end
end

state.var = x;
state.varDual = v;
if state.useA
    state.Ax = Ax;
    state.Atv = Atv;
end
state.grad = grad;

end

