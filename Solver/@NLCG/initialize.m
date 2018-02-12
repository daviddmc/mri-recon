function state = initialize( nlcg, state)

if ~iscell(state.var)
    state.var = {state.var};
end
state.nvar = length(state.var);
state.t = nlcg.param.t0;
[cost, g] = nlcg.f.funGrad(state.var);
state.dir = g;
for ii = 1 : state.nvar
    g{ii} = g{ii}(:);
    state.dir{ii} = -state.dir{ii};
end
state.grad = cat(1, g{:});
state.alpha = nlcg.param.alpha;
state.beta = nlcg.param.beta;
state.cost = cost;

switch nlcg.param.method
    case 'FR'
        state.method = 1;
    case 'PR'
        state.method = 2;
    case 'HS'
        state.method = 3;
    case 'DY'
        state.method = 4;
end

end

