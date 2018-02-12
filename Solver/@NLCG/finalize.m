function state = finalize( nlcg, state )

nlcg.f.funGrad();

if state.nvar == 1
    state.var = state.var{1};
end

end

