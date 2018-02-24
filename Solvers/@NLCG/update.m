function state = update( nlcg, state )

g0 = state.grad;
f0 = nlcg.f.funGrad(state.var, 0, state.dir);
t = state.t;
dircol = cell2col(state.dir, state.nvar);
gp = state.alpha * abs(g0' * dircol);

for iterLS = 1 : nlcg.param.maxIterLS
    f1 = nlcg.f.funGrad([], t);
    if f1 < f0 - t * gp
        break;
    end
    t = t * state.beta;
end
	
if iterLS > 3
    state.t = state.t * state.beta;
end 

if iterLS == 1
    state.t = state.t / state.beta;
end

for ii = 1 : state.nvar
    state.var{ii} = state.var{ii} + t * state.dir{ii};
end

[~, g] = nlcg.f.funGrad([], t);
gcol = cell2col(g, state.nvar);

switch state.method
    case 1 % FR
        b = gcol' * gcol/(g0' * g0 + eps);
    case 2 % PR
        b = gcol'*(gcol - g0) / (gcol'*g0 + eps);
        if b < 0
            b = 0;
        end
    case 3 % HS
        d = gcol - g0;
        b = - (gcol' * d) / (dircol' * d + eps);
    case 4 % DY
        b = - (gcol' * gcol) / (dircol' * (gcol - g0) + eps);
    otherwise
        error(' ');
end

for ii = 1 : state.nvar
    state.dir{ii} = b * state.dir{ii} - g{ii};
end

state.grad = gcol;
state.cost = f1;
state.costOld = f0;

end

function y = cell2col(x, len)
    if len > 1
        for ii = 1 : len
            x{ii} = x{ii}(:);
        end
        y = cat(1, x{:});
    else
        y = x{1}(:);
    end
end


