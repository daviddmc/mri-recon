function state = initialize( lq, state)

for ii = 1 : length(lq.bList)
    lq.bList{ii} = lq.lambdas(ii) * lq.bList{ii}(:);
end

state.sizeX = size(state.var);
state.var = state.var(:);
state.u = cat(1, lq.bList{:});
state.normb = norm(state.u);
state.u = state.u - lq.Afun(state.var, 1, state.sizeX, 0);
state.beta = norm(state.u);
state.normr = state.beta;
state.u = state.u / state.beta;
state.c = 1;
state.s = 0;
state.phibar = state.beta;
state.v = lq.Afun(state.u, [], [], 1);
state.alpha = norm(state.v);
state.v = state.v / state.alpha;
state.d = 0;
state.normar = state.alpha * state.beta;
state.norma = 0;

end

