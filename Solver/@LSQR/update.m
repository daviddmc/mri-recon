function state = update( lq, state )

    state.u = lq.Afun(state.v, [], state.sizeX, 0) - state.alpha * state.u; 
    state.beta = norm(state.u);
    state.u = state.u / state.beta;
    state.norma = norm([state.norma, state.alpha, state.beta]);
    thet = - state.s * state.alpha;
    rhot = state.c * state.alpha;
    rho = sqrt(rhot^2 + state.beta^2);
    state.c = rhot / rho;
    state.s = - state.beta / rho;
    
    phi = state.c * state.phibar;
    state.phibar = state.s * state.phibar;
    state.d = (state.v - thet * state.d) / rho;
    state.var = state.var + phi * state.d;
    state.normr = abs(state.s) * state.normr;

    vt = lq.Afun(state.u, [], [], 1);
    state.v = vt - state.beta * state.v;
    state.alpha = norm(state.v);
    state.v = state.v / state.alpha;
    state.normar = state.alpha * abs( state.s * phi);

end


