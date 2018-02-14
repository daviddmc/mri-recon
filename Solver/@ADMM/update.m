function state = update( admm, state )

p = state.varDual;
Bv = state.Bv;
tau = state.tau;
gamma = state.gamma;

u = admm.f.prox(1/tau, Bv - p);
ur = gamma * u + (1 - gamma) * Bv;
if state.useB
    state.var = admm.g.prox(1/tau, ur + p, admm.B);
    state.Bv = admm.B.apply(state.var);
else
    state.var = admm.g.prox(1/tau, ur + p, []);
    state.Bv = state.var;
end
    
state.varDual = p + ur - state.Bv;

if state.useRes
    state.d = norm(state.Bv(:) - Bv(:)) / norm(state.varDual(:));
    state.r = norm(u(:) - state.Bv(:)) / max(norm(u(:)), norm(state.Bv(:)));
end

if mod(state.iter, state.updateInterval) == 1
    lambdah = tau * (p + u - Bv);
    dL =  lambdah - state.adaptive.lambdah;
    dh = state.adaptive.u - u;
    dLdL = dL(:)' * dL(:);
    dhdL = dh(:)' * dL(:);
    dhdh = dh(:)' * dh(:);
    alphaSD = dLdL / dhdL;
    alphaMG = dhdL / dhdh;
    if 2 * alphaMG > alphaSD
        alpha = alphaMG;
    else
        alpha = alphaSD - alphaMG / 2;
    end
    
    lambda = tau * state.varDual;
    dl = lambda - state.adaptive.lambda;
    dg = state.Bv - state.adpative.Bv;
    dldl = dl(:)' * dl(:);
    dgdl = dg(:)' * dl(:);
    dgdg = dg(:)' * dg(:);
    betaMG = dldl / dgdl;
    betaSD = dgdl / dgdg;
    if 2 * betaMG > betaSD
        beta = betaMG;
    else
        beta = betaSD - betaMG / 2;
    end
    
    alphaCor = dhdL / sqrt(dhdh * dLdL);
    betaCor = dgdl / sqrt(dgdg * dldl);
    
    if alphaCor > admm.param.epsilon
        if betaCor > admm.param.epsilon
            state.tau = sqrt(alpha * beta);
            state.gamma = 1 + 2*state.tau / (alpha + beta);
        else
            state.tau = alpha;
            state.gamma = 1.9;
        end
        state.varDual = state.varDual * (tau / state.tau);
        % state.tau = min(state.tau, (1+Ccg/state.iter^2) * tau);
        % state.gamma = min(state.gamma, (1+Ccg/state.iter^2));
    elseif betaCor > admm.param.epsilon
        state.tau = beta;
        state.gamma = 1.1;
        state.varDual = state.varDual * (tau / state.tau);
    else
        state.gamma = 1.5;
    end

    state.adaptive.lambdah = lambdah;
    state.adaptive.u = u;
    state.adaptive.lambda = lambda;
    state.adaptive.Bv = state.Bv;
end



end

